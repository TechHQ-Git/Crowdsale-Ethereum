var Token = artifacts.require("Token");
var Crowdsale = artifacts.require("Crowdsale");

module.exports = function(deployer) {
  deployer.deploy(Token);
  deployer.deploy(Crowdsale);
};

