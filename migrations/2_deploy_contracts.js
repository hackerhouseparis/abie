var Abie = artifacts.require("./Abie.sol");
//var Web3 = require('../node_modules/web3');

module.exports = function(deployer) {
	//var web3RPC = new Web3(deployer.provider);
	deployer.deploy(Abie,["0x8a40f2556344ebdfffec7b66c73b3f702df375b5","0x4dc60a960c4f5ea48f7b8434d4da1ba1537ead3b"]);
	/*web3RPC.eth.getAccounts((error, accounts) => {
  		deployer.deploy(AbieFund,[accounts[0],accounts[1],accounts[2]]);
  	});*/
};
