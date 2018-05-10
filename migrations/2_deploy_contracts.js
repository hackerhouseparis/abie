var Web3 = require('../node_modules/web3')
const Abie = artifacts.require("Abie")

module.exports = function(deployer) {
		web3.eth.getAccounts((error, accounts) => {
		deployer.deploy(Abie,[accounts[0],accounts[1]])
	});
};
