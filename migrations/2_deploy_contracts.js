var AbieFund = artifacts.require("./AbieFund.sol");
var Web3 = require('../node_modules/web3');

module.exports = function(deployer) {
	var web3RPC = new Web3(deployer.provider);
	web3RPC.eth.getAccounts(function(error, accounts) {
  		deployer.deploy(AbieFund,[accounts[0],accounts[1],accounts[2]]);
  	});
};
