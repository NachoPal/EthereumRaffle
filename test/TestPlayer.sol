pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Raffles.sol";


contract TestPlayer {
    Raffles raffle = Raffles(DeployedAddresses.Raffles());

    function testPlayerRegistration() public {
        //We register a new Player
        raffle.registerPlayer("Nacho");

        bytes32 expectedName = "Nacho";
        bytes32 name;


        uint expectedNumAttempts = 0;
        uint numAttempts;

        int expectedBalance = 0;
        int balance;

        (name, numAttempts, balance) = raffle.playerByAddress(this);

        Assert.equal(name, expectedName, "Player name registration didn't work.");
        Assert.equal(numAttempts, expectedNumAttempts, "Player numAttempts registration didn't work.");
        Assert.equal(balance, expectedBalance, "Player balance didn't work.");

        raffle.destroyPlayer(this);

    }

    function testPlayersCounter() public {

        uint expectedNumPlayers = 0;
        uint numPlayers = raffle.countTotalPlayers();

        Assert.equal(numPlayers, expectedNumPlayers, "Player's initial counter didn't work");

        raffle.registerPlayer("Nacho");

        numPlayers = raffle.countTotalPlayers();
        expectedNumPlayers = 1;

        Assert.equal(numPlayers, expectedNumPlayers, "Player's counter didn't work");

        raffle.destroyPlayer(this);
    }
}
