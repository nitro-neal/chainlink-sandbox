const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const SimpleStorage = artifacts.require("SimpleStorage");
const SimpleBUSD = artifacts.require("SimpleBUSD");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.deploy(SimpleStorage);
  deployer.deploy(SimpleBUSD);
};
