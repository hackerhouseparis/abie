/* Part of this contract is from the solidity documentation
TODO: Set a license.
*/

pragma solidity ^0.4.8;

/// @title Voting with delegation.
contract AbieFund {
<<<<<<< HEAD

    uint membershipFee=0.1 ether;

    uint8 public test = 8;

    event Donated(address indexed donor, uint amount);

=======
    
    uint membershipFee = 0.1 ether;
    uint nbMembers;
    uint registrationTime = 1 years;

    event Donated(address donor, uint amount);
    
>>>>>>> e939cedaa7e669c88ad2c94b1df6ccfbbd4667cf
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
        mapping (address => VoteType) vote; // vote of the party.
        mapping (address => bool) voteCounted;
    }


    struct Member
    {
        uint registration;  // date of registration, if 0 the member does not exist.
        address[2] delegate; // delegate[proposalType] gives the delegate for the type.
    }

    mapping (address => Member) public members;

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

    /// @param initialMembers First members of the organization.
    function AbieFund(address[] initialMembers) {
        for (uint i;i<initialMembers.length;++i)
            members[initialMembers[i]].registration=now;
        nbMembers=initialMembers.length;
    }

    /** Choose a delegate.
      * @param proposalType 0 for AddMember, 1 for FundProject.
      * @param target account to delegate to.
      */
    function setDelegate(uint8 proposalType, address target)
    {
        members[msg.sender].delegate[proposalType] = target;
    }

    /// Receive funds.
    function () payable {
        Donated(msg.sender, msg.value);
    }

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
        proposalType: ProposalType.AddMember
        }));
    }
    
    function vote (uint proposal, VoteType voteType) isMember {
        // TODO
    }
    


    /// GETTERS ///

    /** Return the delegate.
     *  @param member member to get the delegate from.
     *  @param proposalType 0 for AddMember, 1 for FundProject.
     */
    function getDelegate(address member, uint8 proposalType) constant returns (address){
        return members[member].delegate[proposalType];
    }

    function getTest() returns (uint8) {
      return test;
    }

}

<<<<<<< HEAD


/*
    mapping(address => Voter) public voters;
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation.
        bool voted;  // if true, that person already voted.
        address delegate; // person delegated to.
        uint vote;   // index of the voted proposal.
    }


    // This declares a state variable that.
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) {
        if (msg.sender != chairperson || voters[voter].voted) {
            // `throw` terminates and reverts all changes to
            // the state and to Ether balances. It is often
            // a good idea to use this if functions are
            // called incorrectly. But watch out, this
            // will also consume all provided gas.
            throw;
        }
        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) {
        // assigns reference
        Voter sender = voters[msg.sender];
        if (sender.voted)
            throw;

        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (
            voters[to].delegate != address(0) &&
            voters[to].delegate != msg.sender
        ) {
            to = voters[to].delegate;
        }

        // We found a loop in the delegation, not allowed.
        if (to == msg.sender) {
            throw;
        }

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter delegate = voters[to];
        if (delegate.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) {
        Voter sender = voters[msg.sender];
        if (sender.voted)
            throw;
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() constant
            returns (uint winningProposal)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() constant
            returns (bytes32 winnerName)
    {
        winnerName = proposals[winningProposal()].name;
    }

*/
=======
>>>>>>> e939cedaa7e669c88ad2c94b1df6ccfbbd4667cf
