var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer, network) {
  if (network === 'rinkeby') {
    return
  }

  deployer.deploy(Ownable);
};
