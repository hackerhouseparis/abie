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

```javascript
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

}
```
