# Abie Fund

last review on 07 Mars 2017 (Loïc)

## Contexte

Aujourd'hui, les gens donnent de moins en moins d'argent aux ONG car ils ne savent pas où va l'argent, ils ne sont en aucun cas inclus dans le choix des projets à financer.

En effet, les ONG ont la réputation d'être des entités opaques et se retrouve régulièrement au centre de scandales. 
Parmi tout l'argent donné aux ONG, très peu fini effectivement par financer réellement un projet. 

Le but de ce projet est de permettre à des gens partageant un intérêt pour une cause de se regrouper à l'intérieur d'une communauté afin de financer directement des projets liés à cette cause, sans aucun intermédiaire.

Nous avons choisi pour cela de créer une application décentralisée (Dapp).

Cette Dapp reposera sur la blockchain ethereum ainsi que sur le protocole de stockage IPFS.

L'avantage d'une telle application est qu'elle permet par essence une totale transparence sur l'utilisation des fonds. 
De même, elle ne requière aucun intermédiaire, elle fonctionne de manière autonome.

La version initiale de cette application à été développé en 24h le weekend du samedi 4 mars 2017, à l'occasion du 5ème hackation organisé par la HackerHouse-Paris.

### Cette Dapp doit au minimum permettre les fonctionnalitées suivantes:

1. Tout le monde à le droit de faire un don pour une cause.

2. Tout le monde à le droit de soumettre un projet pour une cause.

3. les membres de la communauté votent afin de débloquer les fonds pour un projet.

4. Tout le monde ayant fait un don peut demander à devenir membre de la communauté.

5. les membres de la communauté votent afin d'accepter une demande d'adhésion à la communauté (permet d'éviter les attaques sibylles)

6. Le vote se fait en démocratie liquide. Ainsi chaque membre de la communauté choisi un délégué. Pour chaque vote il a le choix de voter, ou de se reposer sur le vote de son délégué.


Par soucis de synthèse, La description technique est en anglais.

## Features & Technical blocks



| Features		| Prio	|Blocks								| Poc / Prod	| Status|
|-----------------------|-------|---------------------------------------------------------------|---------------|-------|
| Accept donation 	|1	|								|		|
|			|	| GUI: donation form						| Poc		|
|			|	| Contract: open to donation					| Poc		|
|			|	| Contract: Trigger notification				| Poc		|
| Community vote	|2	|								|		|
|			|	| GUI: load proposal + vote form				| Prod		|
|			|	| Contract: create a Member object				| Poc		|
|			|	| Contract: function vote					| Poc		|
|			|	| Contract: Count votes						| Poc		|
|			|	| Contract: Define vote end					|		|
|			|	| Contract: on vote success, pay the beneficiary		| Prod		|
|			|	| Contract: better payement policy				| Prod		|
| Submit a proposal 	|3	|								|		|
|			|	| GUI: "add a proposal" form					| Poc		|
|			|	| Contract: create a proposal object				| Poc		|
|			|	| Contract: check if the contract holds enough funds		| Prod		|
|			|	| IPFS: upload prop description					| Prod		|
| Add a new member 	|4	|								|		|
|			|	| GUI: ask for membership					| Poc		|
|			|	| GUI:vote for membership request				| Prod		|
|			|	| Contract: 'verification vote' as a proposal (with different type)| Poc	|
|			|	| Contract: Define membership expiration			| Poc		|
|			|	| Contract: Ask membership with fees				| Poc		|
|			|	| On vote success, Add member in a chained list			| Poc		|
| Allow delegate	|5	| 								|		|
|			|	| GUI: form choose Delegate					| Poc		|
|			|	| Contract: add delegate in Member object			| Poc		|
|			|	| Contract: set delegate					| Poc		|
|			|	| Contract: Count vote with delegates				| Poc		|
| Proposal review	|6	|  								| 		|
|			|	| GUI: see members review request				| Prod		|
|			|	| GUI: see proposal reviews					| Prod		|
|			|	| GUI: form post a review 					| Prod		|
|			|	| Contract: Randomly choose a reviewer				| Prod		|
|			|	| Contract: notify a member that he has been choosen for a review| Prod		|
|			|	| Contract: store IPFS hash					|		|
|			|	| IPFS: upload prop review					| Prod		|
| Upload photo		|7	| 								|		|
|			|	| GUI: Upload form 						| Prod		|
|			|	| Contract: store IPFS hash					| Prod		|
|			|	| IPFS store photo						| Prod		|
| Validate a photo	|8	| 								|		|
| 			|	| GUI: see photos & vote 					|		|
|			|	| Contract: vote for a photo 					|		|
| Deploy a new contract |9	| 								|		|
|			|	| GUI: create new contract (new cause) 				| Prod		|
|			|	| Contract: set initial voters in constructor			| Poc		|

## Test smart contract

```
sudo npm install -g truffle
sudo npm install -g test-rpc

```

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

We will use IPFS protocol to store projects' descriptions, projects' reviews, and projects' pictures to prove that the beneficiary has realized his project.

Some usefull links related to IPFS:


Public Gateway:

https://ipfs.io/ipfs/hash

Markdown reader example:

https://ipfs.io/ipfs/QmSrCRJmzE4zE1nAfWPbzVfanKQNBhp7ZWmMnEdbiLvYNh/mdown#/ipfs/file_hash

Javascript IPFS library:

https://github.com/ipfs/js-ipfs

more examples:

https://github.com/ipfs/awesome-ipfs

## Code 

### Variables de configurations:

```javascript

    uint public membershipFee = 0.1 ether;
    uint public deposit = 1 ether;
    uint public nbMembers;
    uint public registrationTime = 1 years;
    uint[2] public voteLength = [1 weeks, 1 weeks];
    uint MAX_DELEGATION_DEPTH=1000;
    address NOT_COUNTED=0;
    address COUNTED=1;

```

### Event

```javascript
    event Donated(address donor, uint amount);
```
This is the definition of the notification which is triggered when a donation is made. 

### Enums

```javascript
    enum ProposalType {AddMember,FundProject} // Different types of proposals.
    enum VoteType {Abstain,Yes,No} // Different value of a vote.

```
Proposal is a generic type.

AddMember: this proposal contain a vote to approve a new voter.

FundProject: this type of proposal contains a vote to fund a project. 

VoteType

This is the content of a single vote. A voter can either vote yes, no or abstain. (default: abstain)
If a voter abstains, his vote goes to his delegate.

### Structs

```javascript

    struct Proposal
    {
        bytes32 name;       // short name (up to 32 bytes).
        uint voteYes;     // number of YES votes.
        uint voteNo;     // number of abstention. Number of No can be deduced.
        address recipient;     // address the funds will be sent.
        uint value;         // quantity of wei to be sent.
        bytes32 data;       // data of the transaction.
        ProposalType proposalType;  // type of the proposal.
        uint endDate; // when the vote will be closed.
        address lastMemberCounted; // last one who was counted or NOT_COUNTED (if the count has not started) or COUNTED (if all the votes has been counted);
        bool executed; // True if the proposal have been executed.
        mapping (address => VoteType) vote; // vote of the party.
    }

```

A proposal represents either a proposal to confirm a new voter or a vote to fund a project.

In the case of a project, the data should be the IPFS link of the description.

Because of the liquid democracy, the vote are counted only after the deadline. That way, if someone did not vote, his delegate votes for him.

When the votes are counted we follow a chained list, and we update the lastMemberCounted. making the count in one step is likely to reach gas limit; remembering last member counted allow us to make this count in multiple step.


```javascript

    // Is also a node list.
    struct Member
    {
        uint registration;  // date of registration, if 0 the member does not exist.
        address[2] delegate; // delegate[proposalType] gives the delegate for the type.
        address prev;
        address succ; // This should not be deleted even when the member is.
        uint proposalStoppedOnHim; // Number of proposals stopped on him.
    }

```

A Member represents voting weight of 1, given to a particular account. The owner of the account has the power to vote once for each proposal.
If the member did not vote before the deadline for a proposal, his vote weight goes to another member called his delegate. (if he selected one).

It has two delegates, one for new members proposal, and one for fund proposals.

```javascript

    // Double chained list.
    struct DoubleChainedList
    {
        address first;
        address last;
    }

```
### Global variables

```javascript

    mapping (address => Member) public members;



    // Chain containing all members to iterate on.
    DoubleChainedList memberList;

    Proposal[] public proposals;

```
### Modifiers

```javascript

    /// Require at least price to be paid.
    modifier costs(uint price) {
        if (msg.value<price)
            throw;
        _;
    }

    /// Require the caller to be a member.
    modifier isMember() {
        if(!isValidMember(msg.sender))
            throw;
        _;
    }

```
### Functions

```javascript

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

```


```javascript

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

```


```javascript

    /// Ask membership of the fund.
    function askMembership () payable costs(membershipFee) {
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
          endDate: now + voteLength[uint256(ProposalType.AddMember)],
          lastMemberCounted: 0,
          executed: false
        }));
    }

```
This function can be called by anny account who claims membership. if the caller give more than the fee, the function emit an event donated and add a new proposal object to the proposals list with type AddMember.


```javascript

    /// Add Proposal.
    function addProposal (bytes32 _name, uint _value, bytes32 _data) payable costs(deposit) {
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
          endDate: now,
          lastMemberCounted: 0,
          executed: false
        }));
    }

```


```javascript

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

```


```javascript

    /** Count all the votes. You can call this function if gas limit is not an issue.
     *  @param proposalID ID of the proposal to count votes from.
     */
    function countAllVotes (uint proposalID) {
        countVotes (proposalID,uint(-1));
    }

```


```javascript

    /** Count up to max of the votes.
     *  You may have to call this function multiple times if counting once reach the gas limit.
     *  This function is necessary to count in multiple times if counting reach gas limit.
     *  We just count the number of Yes and Abstention, so we will deduce the number of No.
     *  @param proposalID ID of the proposal to count votes from.
     *  @param max maximum to count.
     */
    function countVotes (uint proposalID, uint max) {
        Proposal proposal = proposals[proposalID];
        address current;
        if (proposal.endDate > now) // You can't count while the vote is not over.
            throw;
        if (proposal.lastMemberCounted == COUNTED) // The count is already over
            throw;

        if (proposal.lastMemberCounted == NOT_COUNTED)
            current = memberList.first;
        else
            current = proposal.lastMemberCounted;

        while (max-- != 0) {
            Member member=members[current];
            address delegate=current;
            if(isValidMember(current)) {
                uint depth=0;
                // Seach the final vote.
                while (true){
                    VoteType vote=proposal.vote[delegate];
                    if (vote==VoteType.Abstain) { // Look at the delegate
                        depth+=1;
                        delegate=members[delegate].delegate[uint(proposal.proposalType)]; // Find the delegate.
                        if (delegate==current // The delegation chain forms a circle.
                            || delegate==0  // Has not set a delegate.
                            || depth>MAX_DELEGATION_DEPTH) { // Too much depth, we must limit it in order to avoid some circle of delegation made to consume too much gaz.
                           break;
                        }
                    }
                    if (vote==VoteType.Yes) {
                        proposal.voteYes+=1;
                        break;
                    } else if (vote==VoteType.No) {
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

```


```javascript

    function executeAddMemberProposal(uint proposalID) {
        Proposal proposal = proposals[proposalID];
        if (proposal.proposalType != ProposalType.AddMember) // Not a proposal to add a member.
            throw;
        if (!isExecutable(proposalID)) // Proposal was not approved.
            throw;
        proposal.executed=true; // The proposal will be executed.
        addMember(proposal.recipient);
    }

```


```javascript

    /// CONSTANTS ///

    /** Return the delegate.
     *  @param member member to get the delegate from.
     *  @param proposalType 0 for AddMember, 1 for FundProject.
     */
    function getDelegate(address member, uint8 proposalType) constant returns (address){
        return members[member].delegate[proposalType];
    }

```


```javascript

    /** Return true if the proposal is validated, false otherwise.
     *  @param proposalID ID of the proposal to count votes from.
     */
    function isExecutable(uint proposalID) constant returns (bool) {
        Proposal proposal = proposals[proposalID];

        if (proposal.lastMemberCounted != COUNTED) // Not counted yet.
            return false;
        if (proposal.executed) // The proposal has already been executed.
            return false;
        if (proposal.value>this.balance) // Not enough to execute it.
            return false;

        return (proposal.voteYes>proposal.voteNo);
    }

```


```javascript

    function isValidMember(address m) constant returns(bool) {
        if (members[m].registration==0) // Not a member.
            return false;
        if (members[m].registration+registrationTime<now) // Has expired.
            return false;
        return true;
    }

}
```
