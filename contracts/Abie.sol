/* Part of this contract is from the solidity documentation
MIT License: https://github.com/AbieFund/abie/blob/master/LICENSE
*/

pragma solidity ^0.4.8;

/// @title The easy fund
contract Abie {

    bytes32 public name;
    bytes32 public statement;
    uint public fee = 0.1 ether;
    uint public nbMembers;
    uint public nbProposalsFund;
    uint public nbMembershipReq;
    uint public registrationTime = 1 years;
    uint[2] public voteLength = [2 minutes, 2 minutes];
    uint MAX_DELEGATION_DEPTH=10;
    address NOT_COUNTED=0;
    address COUNTED=1;

    event Donated(address donor, uint amount);

    enum ProposalType {AddMember,FundProject} // Different types of proposals.
    enum VoteType {Abstain,Yes,No} // Different value of a vote.

    struct Proposal
    {
        bytes32 name; // short name (up to 32 bytes).
        uint voteYes; // number of YES votes.
        uint voteNo;  // number of abstention. Number of No can be deduced.
        address recipient; // address the funds will be sent.
        uint value; // quantity of wei to be sent.
        bytes32 data; // data of the transaction.
        ProposalType proposalType; // type of the proposal.
        uint endDate; // when the vote will be closed.
        address lastMemberCounted; // last one who was counted or NOT_COUNTED (if the count has not started) or COUNTED (if all the votes has been counted);
        bool executed; // true if the proposal have been executed.
        mapping (address => VoteType) vote; // vote of the party.
    }

    // Is also a node list.
    struct Member
    {
        uint registration;  // date of registration, if 0 the member does not exist.
        address[2] delegate; // delegate[proposalType] gives the delegate for the type.
        address prev;
        address succ; // this should not be deleted even when the member is.
        uint proposalStoppedOnHim; // number of proposals stopped on him.
    }

    mapping (address => Member) public members;

    // Double chained list.
    struct DoubleChainedList
    {
        address first;
        address last;
    }

    // Chain containing all members to iterate on.
    DoubleChainedList memberList;

    Proposal[] public proposals;

    /// Require at least price to be paid.
    modifier costs(uint price) {
        require(msg.value>=price);
        _;
    }

    /// Require the caller to be a member.
    modifier isMember() {
        require(isValidMember(msg.sender));
        _;
    }

    /// @param initialMembers First members of the organization.
    /// @param _name The name of the DAO
    /// @param _statement The statement of intent of the DAO
    function Abie(bytes32 _name, bytes32 _statement, address[] initialMembers) public {

        name=_name;
        statement=_statement;
        for (uint i;i<initialMembers.length;++i){
            Member storage member=members[initialMembers[i]];
            member.registration=now;
            if (i==0) { // initialize the list with the first member
                memberList.first=initialMembers[0];
                memberList.last=initialMembers[0];
            } else { // add members
                addMember(initialMembers[i]);
            }
        }
        nbMembers=initialMembers.length;
        // Set default member.
        if (nbMembers==0){
        addMember(msg.sender);
        }
 }

    // Add the member m to the member list.
    // Assume that there is at least 1 member registrated.
    function addMember(address m) private {
        members[m].registration=now;
        ++nbMembers;
        members[memberList.last].succ=m;
        members[m].prev=memberList.last;
        memberList.last=m;
    }

    /** Choose a delegate.
      * @param proposalType 0 for AddMember, 1 for FundProject.
      * @param target account to delegate to.
      */
    function setDelegate(uint8 proposalType, address target) public
    {
        members[msg.sender].delegate[proposalType] = target;
    }

    /// Receive funds.
    function () payable public{
        Donated(msg.sender, msg.value);
    }

    /// Ask for membership.
    function askMembership () payable public costs(fee) {
         Donated(msg.sender,msg.value); // Register the donation.

        // Create a proposal to add the member.
        proposals.push(Proposal({
          name: 0x0,
          voteYes: 0,
          voteNo: 0,
          recipient: msg.sender,
          value: 0x0,
          data: 0x0,
          proposalType: ProposalType.AddMember,
          endDate: now + 2 minutes,
          //voteLength[uint256(ProposalType.AddMember)],
          lastMemberCounted: 0,
          executed: false
        }));

        ++nbMembershipReq;
    }

    /// Add Proposal.
    function addProposal (bytes32 _name, uint _value, bytes32 _data) payable public costs(fee) {
        Donated(msg.sender,msg.value); // Register the donation.

        // Create a proposal to add the member.
        proposals.push(Proposal({
          name: _name,
          voteYes: 0,
          voteNo: 0,
          recipient: msg.sender,
          value: _value,
          data: _data,
          proposalType: ProposalType.FundProject,
          endDate: now + 2 minutes,
          lastMemberCounted: 0,
          executed: false
        }));

        ++nbProposalsFund;
    }

    /** Vote for a proposal.
     *  @param proposalID ID of the proposal to count votes from.
     *  @param voteType Yes or No.
     */
    function vote (uint proposalID, VoteType voteType) public isMember {
        Proposal storage proposal = proposals[proposalID];
        require(proposal.vote[msg.sender] == VoteType.Abstain); // Has already voted.
        require(proposal.endDate >= now); // Vote is over.
        proposals[proposalID].vote[msg.sender] = voteType;
    }

    /** Count all the votes. You can call this function if gas limit is not an issue.
     *  @param proposalID ID of the proposal to count votes from.
     */
    function countAllVotes (uint proposalID) public{
        countVotes (proposalID,uint(-1));
    }

    /** Count up to max of the votes.
     *  You may have to call this function multiple times if counting once reach the gas limit.
     *  This function is necessary to count in multiple times if counting reach gas limit.
     *  We just count the number of Yes and Abstention, so we will deduce the number of No.
     *  @param proposalID ID of the proposal to count votes from.
     *  @param max maximum to count.
     */
    function countVotes (uint proposalID, uint max) public {
        Proposal storage proposal = proposals[proposalID];
        address current;
        require (proposal.endDate <= now); // You can't count while the vote is not over.
        require (proposal.lastMemberCounted != COUNTED); // The count is already over

        if (proposal.lastMemberCounted == NOT_COUNTED)
            current = memberList.first;
        else
            current = proposal.lastMemberCounted;

        while (max-- != 0) {
            Member storage member = members[current];
            address delegate=current;
            if(isValidMember(current)) {
                uint depth=0;
                // Search the final vote.
                while (true){
                    VoteType voteNow = proposal.vote[delegate];
                    if (voteNow==VoteType.Abstain) { // Look at the delegate
                        depth+=1;
                        delegate=members[delegate].delegate[uint(proposal.proposalType)]; // Find the delegate.
                        if (delegate==current // The delegation chain forms a circle.
                            || delegate==0  // Has not set a delegate.
                            || depth>MAX_DELEGATION_DEPTH) { // Too much depth, we must limit it in order to avoid some circle of delegation made to consume too much gaz.
                           break;
                        }
                    }
                    if (voteNow==VoteType.Yes) {
                        proposal.voteYes+=1;
                        break;
                    } else if (voteNow==VoteType.No) {
                        proposal.voteNo+=1;
                        break;
                    }
                }
            } else {
                // TODO: Delete the members if they are expired.
            }

            current=member.succ; // In next iteration start from the next node.
            if (current==0) { // We reached the last member.
                proposal.lastMemberCounted=COUNTED;
                break;
            }
        }
    }

    function executeAddMemberProposal(uint proposalID) public {
        Proposal storage proposal = proposals[proposalID];
        require (proposal.proposalType == ProposalType.AddMember); // Not a proposal to add a member.
        require (isExecutable(proposalID)); // Proposal was not approved.
        proposal.executed=true; // The proposal will be executed.
        addMember(proposal.recipient);

    }

    // The following function has NOT been reviewed so far.
    function claim(uint proposalID) public payable costs(fee) {
        Proposal storage proposal = proposals[proposalID];
        address beneficiary = proposal.recipient;
        uint value = proposal.value;
        uint check = fee*2+value;
        require (isExecutable(proposalID)); // rejected if not executable
        require(proposal.executed == false); // rejected if executed already
        require (beneficiary == msg.sender); // rejected if caller is not the beneficiary
        proposal.executed = true; // The proposal is flagged ‘executed’.
        proposal.executed = true; // The proposal was executed.
        beneficiary.transfer(check); // The beneficiary gets the requested amount.
    }

    /// CONSTANTS ///

    /** Return the delegate.
     *  @param member member to get the delegate from.
     *  @param proposalType 0 for AddMember, 1 for FundProject.
     */
    function getDelegate(address member, uint8 proposalType) public constant returns (address){
        return members[member].delegate[proposalType];
    }

    /** Return true if the proposal is validated, false otherwise.
     *  @param proposalID ID of the proposal to count votes from.
     */
    function isExecutable(uint proposalID) public constant returns (bool) {
        Proposal storage proposal = proposals[proposalID];

        if (proposal.lastMemberCounted != COUNTED) // Not counted yet.
            return false;
        if (proposal.executed) // The proposal has already been executed.
            return false;
        if (proposal.value > address(this).balance) // Not enough to execute it.
            return false;

        return (proposal.voteYes>proposal.voteNo);
    }

    function isValidMember(address m) public constant returns(bool) {
        if (members[m].registration==0) // Not a member.
            return false;
        if (members[m].registration+registrationTime<now) // Has expired.
            return false;
        return true;
    }

    function contractBalance() public constant returns(uint256) {
        return address(this).balance;
    }

 function timeLeft(uint proposalID) public constant returns(uint256) {
        Proposal storage proposal = proposals[proposalID];
        return proposal.endDate - now;
    }
}
