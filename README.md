# Abie Fund

Abie Fund was first released on March 5th, 2017 under [MIT License](https://github.com/AbieFund/abie/blob/master/LICENSE).

## Intro

Abie Fund is a DAO that includes a voting system based on liquid democracy (delegative model). The community vote triggers a transaction to the beneficiary. We vote when a proposal is submitted or when someone asks for membership (Sybil-proof).

Liquid democracy allows participants that don't have any device or Internet access to vote on each incoming proposal, and therefore increase the participation rate. 

## Use cases

* A community that wants to fund initiatives for one specific and global cause
* A group of people or orgs that need to raise fund in emergency
* A brand that allows its customers to directly manage the funds allocated to certain objectives
* A city hall that would give more decision power to people on one specific project

They can all use Abie to **take collective decisions and actions in an intuitive and easy way**.:sparkles:

## Features

* Enable external donations (including anon)
* Any donor can request membership
* Anyone can submit a proposal
* The vote of the community triggers the transaction to the beneficiary
* Members have one right to vote each proposal or membership request
* As the vote follow the rules of liquid democracy, you can choose (or become) a delegate
* You can switch delegate or switch to direct democracy at anytime

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

1. Allow users to trigger the `addProposal()` and `vote()` functions from http://abie.fund/app.html (**reward is set to 1 ETH per function**).
2. Improve the [tests](https://github.com/AbieFund/abie/tree/master/test)

Feel free to join our [Slack](http://slack.abie.fund).
