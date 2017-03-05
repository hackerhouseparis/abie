/* Part of this contract is from the solidity documentation
TODO: Set a license.
*/

pragma solidity ^0.4.8;

/// @title Fund for donations.
contract AbieFund {
    
    uint membershipFee = 0.1 ether;
    uint nbMembers;
    uint registrationTime = 1 years;
    uint[2] voteLength = [1 weeks, 1 weeks];

    event Donated(address donor, uint amount);
    
    enum ProposalType {AddMember,FundProject} // Different types of proposals.
    enum VoteType {Abstain,Yes,No} // Different value of a vote.

    struct Proposal
    {
        bytes32 name;       // short name (up to 32 bytes).
        uint voteYes;     // number of YES votes.
        uint voteAbstain;     // number of abstention. Number of No can be deduced.
        address recipient;     // address the funds will be sent.
        uint value;         // quantity of wei to be sent.
        bytes32 data;       // data of the transaction.
        ProposalType proposalType;  // type of the proposal.
        uint endDate; // when the vote will be closed.
        mapping (address => VoteType) vote; // vote of the party.
        mapping (address => bool) voteCounted; // has the vote been counted yet?
    }
    
    // Is also a node list.
    struct Member
    {
        uint registration;  // date of registration, if 0 the member does not exist.
        address[2] delegate; // delegate[proposalType] gives the delegate for the type.
        address prev;
        address succ;
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
        if (msg.value<price)
            throw;
        _;
    }
    
    /// Require the caller to be a member.
    modifier isMember() {
    
        if (members[msg.sender].registration==0) // Not a member.
            throw;
        if (members[msg.sender].registration+registrationTime<now) // Has expired.
            throw;
        _;
    }

/*
function insertEnd(List list, Node newNode)
     if list.lastNode == null
         insertBeginning(list, newNode)
     else
         insertAfter(list, list.lastNode, newNode)
*/

    /// @param initialMembers First members of the organization.
    function AbieFund(address[] initialMembers) {
        for (uint i;i<initialMembers.length;++i){
            Member member=members[initialMembers[i]];
            member.registration=now;
            if (i==0) { // initialize the list with the first member
                memberList.first=initialMembers[0];
                memberList.last=initialMembers[0];
            } else { // add members
                addMember(initialMembers[i]);
            }
        }
        nbMembers=initialMembers.length;
    }
    
    // Add the member m to the member list.
    // Assume that there is at least 1 member registrated.
    function addMember(address m) private {
        members[memberList.last].succ=m;
        members[m].prev=memberList.last;
        memberList.last=m;
    }
    
    /** Choose a delegate.
      * @param proposalType 0 for AddMember, 1 for FundProject.
      * @param target account to delegate to.
      */
    function setDelegate(uint8 proposalType, address target) isMember
    {
        members[msg.sender].delegate[proposalType] = target;
    }

    /// Receive funds.
    function () payable {
        Donated(msg.sender, msg.value);
    }
    
    /// Ask membership of the fund.
    function askMembership () payable costs(membershipFee) {
        Donated(msg.sender,msg.value); // Register the donation.
        // Create a proposal to add the member.
        proposals.push(Proposal({
        name: 0x0,
        voteYes: 0,
        voteAbstain: 0,
        recipient: msg.sender,
        value: 0x0,
        data: 0x0,
        proposalType: ProposalType.AddMember,
        endDate: now + voteLength[uint256(ProposalType.AddMember)]
        }));
    }
    
    /** Vote for a proposal.
     *  @param proposalID ID of the proposal to count votes from.
     *  @param voteType Yes or No.
     */
    function vote (uint proposalID, VoteType voteType) isMember {
        Proposal proposal = proposals[proposalID];
        if (proposal.vote[msg.sender] != VoteType.Abstain) // Has already voted.
            throw;
        if (proposal.endDate < now) // Vote is over.
            throw;
        proposals[proposalID].vote[msg.sender] = voteType;
    }
    
    /** Count all the votes of a proposal.
     *  @param proposalID ID of the proposal to count votes from. 
     */
    function countAllVotes (uint proposalID) {
        countVotes (proposalID, memberList.first, 0);
    }
    
    /** Count the votes from start to end.
     *  This function is necessary to count in multiple times if counting reach gas limit.
     *  We just count the number of Yes and Abstention, so we will deduce the number of No.
     *  @param proposalID ID of the proposal to count votes from.
     *  @param start First member to count from.
     *  @param end   Count votes of all members before this one (end is not included), put to 0 to count till the end.
     */
    function countVotes (uint proposalID, address start, address end) {
        Proposal proposal = proposals[proposalID];
        
        while (start != end) {
            Member member=members[start];
            if (proposal.voteCounted[start]==false) { // Verify the vote has not been counted yet.
                proposal.voteCounted[start]=true; // The vote will be counted.
                
                address delegate=start;
                // Seach the final vote.
                while (true){
                    VoteType vote=proposal.vote[delegate];
                    if (vote==VoteType.Abstain) { // Look at the delegate
                        delegate=members[delegate].delegate[uint(proposal.proposalType)]; // Find the delegate.
                        if (delegate==start || delegate==0) { // Back to the start of the loop or failed to name a delegate.
                           proposal.voteAbstain+=1;
                           break;
                        }
                    }
                    if (vote==VoteType.Yes) {
                        proposal.voteYes+=1;
                        break;
                    }
                    // Else voted No, so we don't count.
                }
                
            }
            start=member.succ; // In next iteration start from the next node.
            
            // TODO: Delete the members if they are expired.
        }
        
    }
    


    /// CONSTANTS ///
    
    /** Return the delegate.
     *  @param member member to get the delegate from.
     *  @param proposalType 0 for AddMember, 1 for FundProject.
     */
    function getDelegate(address member, uint8 proposalType) constant returns (address){
        return members[member].delegate[proposalType];
    }
    
    /** Return true if the proposal is validated, false otherwise.
     *  @param proposalID ID of the proposal to count votes from.
     */
    function isValidated(uint proposalID) returns (bool) {
        Proposal proposal = proposals[proposalID];
        if (proposal.endDate > now)
            return false;
            
        // Deduce the number of votes No by discounting the number of abstentions and votes Yes.
        uint voteNo=nbMembers;
        if (voteNo-proposal.voteYes>voteNo) // Overflow somewhere.
            return false;
        else
            voteNo-=proposal.voteYes;
            
        if (voteNo-proposal.voteAbstain>voteNo) // Overflow somewhere.
            return false;
        else
            voteNo-=proposal.voteAbstain; 
        
        return (proposal.voteYes>voteNo);
    }

}




