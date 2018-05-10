/***

When using truffle:
Uncomment lines 13, 17, 18 and 19 and comment line 16 .

When using the interface:
Uncomment line 16 and comment lines 13, 17, 18 and 19.
Replace the 2 addr manually at line 16.

***/

var Abie = artifacts.require("./Abie.sol");
//var Web3 = require('../node_modules/web3');

module.exports = function(deployer) {
	deployer.deploy(Abie,["addr","addr"]);
		//web3.eth.getAccounts((error, accounts) => {
		//deployer.deploy(Abie,[accounts[0],accounts[1]])
	//});
};
