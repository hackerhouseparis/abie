# Abie

Abie was first released on March 5th, 2017 under [MIT License](https://github.com/AbieFund/abie/blob/master/LICENSE) with the help of the Ethergency team.

## Intro

Abie is a DAO that includes a voting system and a minimalist membership system resistant to Sybil attacks. Only the vote of the members can trigger a transaction to the beneficiary. The 'liquid democracy' allows members that don't have any device or Internet access to express their opinion on each incoming proposal.

## Test

Make sure you have latest versions of [npm](https://www.npmjs.com/), [nodejs](https://nodejs.org/en/), [truffle](https://github.com/trufflesuite/truffle) and [testrpc](https://www.npmjs.com/package/ethereumjs-testrpc) installed, then launch testrpc on port 9545:
```
testrpc
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

## Contrib

* [Add the `statementOfIntent` input at deployment](https://github.com/AbieFund/abie/projects/1#card-9604673)
* [Add the `name` input at deployment](https://github.com/AbieFund/abie/projects/1#card-9604684)
* [Test setDelegate() in abie.js ](https://github.com/AbieFund/abie/projects/1#card-9604692)
* [Test askForMembership() in abie.js ](https://github.com/AbieFund/abie/projects/1#card-9604696)
* [Deploy a DAO to main net, donate 10 ETH and call for attacks](https://github.com/AbieFund/abie/projects/1#card-9604705)
* [Measure the participation and relevancy rates](https://github.com/AbieFund/abie/projects/1#card-9604708)
* [Create an explorer](https://github.com/AbieFund/abie/projects/1#card-9604722)
* [Improve the interface](https://github.com/AbieFund/abie/projects/1#card-9604731)

## Resources

* [Project Website](http://abie.fund/) 
* [Using Abie with Remix (video)](https://youtu.be/NCzbua9R_eE)
* [When you test Abie](https://imgur.com/a/m7fFvVi)

Feel free to join the [Riot](https://riot.im/app/#/room/#abie:matrix.org) discussion chan!
