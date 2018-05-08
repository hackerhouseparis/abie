# Abie

Abie was first released on March 5th, 2017 under [MIT License](https://github.com/AbieFund/abie/blob/master/LICENSE) with the help of the Ethergency team.

## Intro

Abie is a DAO that includes a voting system and a minimalist membership system resistant to Sybil attacks. Only the vote of the members can trigger a transaction to the beneficiary. The 'liquid democracy' allows members that don't have any device or Internet access to express their opinion on each incoming proposal.

## Test

Make sure you have latest versions of [npm](https://www.npmjs.com/), [node](https://nodejs.org/en/), [truffle](https://github.com/trufflesuite/truffle) and [ganache](https://www.npmjs.com/package/ganache-cli) installed, then launch ganache-cli:

```
ganache-cli
```

In a new window:

```
git clone https://github.com/AbieFund/abie.git
cd abie
```

Then:

```
npm i
truffle migrate
truffle test
```
#### Versions

* node v9.4.0
* npm 5.7.1
* Ganache CLI v6.1.0 (ganache-core: 2.1.0)
* Truffle v4.0.5 (core: 4.0.5)
* Solidity v0.4.18 (solc-js)

## Run

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
* [Abie Wiki](https://github.com/AbieFund/abie/wiki)
* [Using Abie with Remix (video)](https://youtu.be/NCzbua9R_eE)
* [When you test Abie](https://imgur.com/a/m7fFvVi)

Feel free to join the [Riot](https://riot.im/app/#/room/#abie:matrix.org) discussion chan!
