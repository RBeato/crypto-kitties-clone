const Migrations = artifacts.require("Kittycontract");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
