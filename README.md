# Abie

## Test smart contract
ii
```
truffle compile
truffle migrate
truffle test
```

## Run dapp

```
npm i
npm start
```

## IPFS
Ii
Public Gateway:

https://ipfs.io/ipfs/{hash}

Markdown reader example:

https://ipfs.io/ipfs/QmSrCRJmzE4zE1nAfWPbzVfanKQNBhp7ZWmMnEdbiLvYNh/mdown#/ipfs/QmfQ75DjAxYzxMP2hdm6o4wFwZS5t7uorEZ2pX9AKXEg2u

Javascript IPFS library:

https://github.com/ipfs/js-ipfs#use-in-the-browser-with-browserify-webpack-or-any-bundler

more examples:

https://github.com/ipfs/awesome-ipfs#single-page-webapps

## Code 
i

### Variables de configurations:

```javascript

    uint membershipFee = 0.1 ether;
    uint nbMembers;
    uint registrationTime = 1 years;

    uint8 public test = 8; // temp for test purpose

```

### Event

```javascript
    event Donated(address donor, uint amount);
```
this is the definition of the notification which is triggered when a donation occured. 

### Enums

```javascript
    enum ProposalType {AddMember,FundProject} // Different types of proposals.
    enum VoteType {Abstain,Yes,No} // Different value of a vote.

```
Proposal is a generic type.
AddMember : this proposal contain a vote to confirm a new voter
FundProject: this type of proposal contain a vote to fund a project 

VoteType
This is the content of a single vote. a voter can either vote yes, no or abstain. (default: abstain)
if a voter abstain, his vote goes to his delegate.

### Structs

```javascript

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

```

A proposal represent either a proposal to confirm a new voter or a vote to fund a project.
In the case of a project, the data should be the IPFS link of the description.

Because of the liquid democratie, the vote are counted only after the deadline. That way, if someone did not vote, his delegate vote for him.

when the vote are counted we follow a chained list, and we update the voteCounted array such that we always have voteYes + voteAbstain = #voteCounted. If we run out of fuel, we can run this function in multiples steps.
At the end, voteYes + voteAbstain = #vote

```javascript

    struct Member
    {
        uint registration;  // date of registration, if 0 the member does not exist.
        address[2] delegate; // delegate[proposalType] gives the delegate for the type.
    }
 ```

A Member represent a voting Weight, given to a particular account. the owner of the account has the power to vote once for each proposal.
If the member did not vote before the deadline for a proposal, his vote weight goes to another member called his delegate. (if he selected one).

 It has two delegate, one for new members proposal, and one for fund proposals

 ```javascript

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

}
```
