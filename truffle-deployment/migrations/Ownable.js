var SimpleStore = artifacts.require("./Ownable.sol");

module.exports = function(deployer, network) {
  if (network === 'rinkeby') {
    return
  }

  deployer.deploy(SimpleStore);
};
