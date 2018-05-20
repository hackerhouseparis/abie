var Abie = artifacts.require("./Abie.sol");
module.exports = function(deployer) {
		web3.eth.getAccounts((error, accounts) => {
		deployer.deploy(Abie,"0x596f","0x596f",[accounts[0],accounts[1]])
	});
};
