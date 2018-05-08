# Abie

Abie was first released on March 5th, 2017 under [MIT License](https://github.com/AbieFund/abie/blob/master/LICENSE) with the help of the Ethergency team.

## Intro

Abie is a DAO that includes a voting system and a minimalist membership system resistant to Sybil attacks. Only the vote of the members can trigger a transaction to the beneficiary. The 'liquid democracy' allows members that don't have any device or Internet access to express their opinion on each incoming proposal.

## Test

Make sure you have latest versions of [npm](https://www.npmjs.com/), [nodejs](https://nodejs.org/en/), [truffle](https://github.com/trufflesuite/truffle) and [testrpc](https://www.npmjs.com/package/ethereumjs-testrpc) installed, then launch testrpc on port 9545:
```
testrpc --port 9545
```
In another window, go in your repository and:

```
truffle compile
truffle migrate
truffle test
```

## Run

Install package.json:

```
npm i
```
Then:

```
npm start
```

In your browser, you can now open the interface on port 3000:  

[http://localhost:3000](http://localhost:3000)

## Next steps

* Add the `statementOfIntent` input at deployment 
* Add the `name` input at deployment
* Test setDelegate() in abie.js 
* Test askForMembership() in abie.js 
* Deploy a DAO to main net, donate 10 ETH and call for attacks
* Measure the participation and relevancy rates
* Create an explorer
* Improve the interface

## Resources

* [Project Website](http://abie.fund/) 
* [Using Abie with Remix (video)](https://youtu.be/NCzbua9R_eE)
* [When you test Abie](https://imgur.com/a/m7fFvVi)

Feel free to join the [Riot](https://riot.im/app/#/room/#abie:matrix.org) discussion chan!
