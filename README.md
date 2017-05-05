# Abie Fund

Abie Fund was first released on March 5th, 2017 under [MIT License](https://github.com/AbieFund/abie/blob/master/LICENSE).

We’re on [Slack](http://slack.abie.fund)! Don't hesitate to join.

## Welcome to Abie!

Abie Fund is a DAO that includes a voting system based on "liquid democracy". The community vote triggers a transaction to the beneficiary. We vote when a proposal is submitted or when someone asks for membership (Sybil-proof).

## Use cases

* A group of people that want to fund initiatives for one specific cause
* A transparent common account, easy to manage and ridiculously easy to deploy and configure quickly
* A corporate brand that would allow its customers to directly manage the funds allocated to certain objectives
* A city hall that would give more decision power to people on one specific project
* A group of friends trading together, voting every week to adjust their collective investment

They can all use Abie to **take collective decisions and actions in an intuitive and easy way**.

## Implemented Features

* Enable external donations (including anon)
* Anyone can submit a proposal
* The vote of the community triggers the transaction to the beneficiary
* Any donor can request membership
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

## Get involved

You can find a [presentation](http://prez.abie.fund) [Fench] and our [roadmap](http://slack.abie.fund).

**All contribs are rewarded**, we're backed by lucky crypto investors! ;) 

Feel free to your pull request or send offers at **team@abie.fund**.

## Next steps

1. Deploy on mainnet
2. Fund one first demo project
3. Select 3 different use cases and measure performance
4. Improve the documentation
5. Listen to users fedbacks

## Resources 

### IPFS and storage

We will use IPFS protocol to store projects' descriptions, reviews and photos related to each proposal.

Some useful links about IPFS:

* Public Gateway: https://ipfs.io/ipfs/hash
* Markdown reader example: https://ipfs.io/ipfs/QmSrCRJmzE4zE1nAfWPbzVfanKQNBhp7ZWmMnEdbiLvYNh/mdown#/ipfs/file_hash
* Javascript IPFS library: https://github.com/ipfs/js-ipfs
* More examples: https://github.com/ipfs/awesome-ipfs
