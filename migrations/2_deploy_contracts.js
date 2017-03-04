var AbieFund = artifacts.require("./AbieFund.sol");

module.exports = function(deployer) {
  deployer.deploy(AbieFund,["0x0","0x0"]);
};
