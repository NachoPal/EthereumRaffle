pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Players.sol";


contract TestPlayer {
    Players player = Players(DeployedAddresses.Players());

    function testPlayerRegistration() public {
        //We register a new Player
        player.register("Nacho");

        bytes32 expectedName = "Nacho";
        bytes32 name;

        uint expectedNumAttempts = 0;
        uint numAttempts;

        int expectedBalance = 0;
        int balance;

        (name, numAttempts, balance) = player.byAddress(this);

        Assert.equal(name, expectedName, "Player name registration didn't work.");
        Assert.equal(numAttempts, expectedNumAttempts, "Player numAttempts registration didn't work.");
        Assert.equal(balance, expectedBalance, "Player balance didn't work.");

        player.destroy(this);

    }

    function testPlayersCounter() public {

        uint expectedNumPlayers = 0;
        uint numPlayers = player.counter();

        Assert.equal(numPlayers, expectedNumPlayers, "Player's initial counter didn't work");

        player.register("Nacho");

        numPlayers = player.counter();
        expectedNumPlayers = 1;

        Assert.equal(numPlayers, expectedNumPlayers, "Player's counter didn't work");

        player.destroy(this);
    }
}
