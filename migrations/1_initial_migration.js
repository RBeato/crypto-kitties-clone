const Token = artifacts.require("Migrations");

module.exports = function (deployer) {
  deployer.deploy(Token);
};