var PlayerCRUD = artifacts.require("./PlayerCRUD.sol");
var Raffle = artifacts.require("./Raffle.sol");

module.exports = function(deployer) {
  deployer.deploy(PlayerCRUD);
  deployer.deploy(Raffle);
};