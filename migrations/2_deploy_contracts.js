var Players = artifacts.require("./Players.sol");
//var Raffles = artifacts.require("./Raffles.sol");


module.exports = function(deployer) {
  deployer.deploy(Players);
  //deployer.deploy(Raffles);
};