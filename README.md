# Abie Fund

Abie Fund was first released on March 5th, 2017 under [MIT License](https://github.com/AbieFund/abie/blob/master/LICENSE) with the help of Ethergency team.

## Intro

Abie Fund is a DAO that includes a voting system based on liquid democracy (delegative model). The community vote triggers a transaction to the beneficiary. We vote when a proposal is submitted or when someone asks for membership (Sybil-proof).

Liquid democracy allows participants that don't have any device or Internet access to vote on each incoming proposal, and therefore increase the participation rate. 

## Use cases

* A community that wants to fund initiatives for one specific and global cause
* A group of people or orgs that need to raise fund in emergency
* A brand that allows its customers to directly manage the funds allocated to certain objectives
* A city hall that would give more decision power to people on one specific project

They can use Abie to **take collective decisions and actions in an intuitive and easy way**.

## Features

* Enable external donations (including anon)
* Any donor can request membership
* Anyone can submit a proposal
* The vote of the community triggers the transaction to the beneficiary
* Members have one right to vote each proposal (including membership request)
* As the vote follow the rules of liquid democracy, you can choose (or become) a delegate
* You can switch delegate or switch to direct democracy

## Test

```
npm install -g truffle
npm install -g ethereumjs-testrpc
```

```
truffle compile
truffle migrate
truffle test
```

## Run

```
npm i
npm start
```

## Next steps
JS + Redux + React
* Create basic UI so that users can trigger the following 3 'vital' functions : addProposal(), vote(), and executeProposal()
* Deploy on mainnet --> v0.1 release
* Set a 3 ETH bug bounty programme : a contract holding 3 ETH, capped at 5 ETH, 1 week voting period.
* Add membership functions triggers in UI
* Add the setDelegate() function trigger in UI
* v1 release

Feel free to join our [Slack](http://slack.abie.fund)!
