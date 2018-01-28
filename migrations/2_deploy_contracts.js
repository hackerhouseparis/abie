var AbieFund = artifacts.require("./AbieFund.sol");
//var Web3 = require('../node_modules/web3');

module.exports = function(deployer) {
	//var web3RPC = new Web3(deployer.provider);
	deployer.deploy(AbieFund,["0x627306090abab3a6e1400e9345bc60c78a8bef57","0xf17f52151ebef6c7334fad080c5704d77216b732"]);
	/*web3RPC.eth.getAccounts((error, accounts) => {
  		deployer.deploy(AbieFund,[accounts[0],accounts[1],accounts[2]]);
  	});*/
};
