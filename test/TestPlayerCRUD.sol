pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PlayerCRUD.sol";

contract TestPlayerCRUD {
    PlayerCRUD playerCRUD = PlayerCRUD(DeployedAddresses.PlayerCRUD());

    function testPlayerRegistration() public {
        //We register a new Player
        playerCRUD.registerPlayer("Nacho");

        bytes32 expectedName = "Nacho";
        bytes32 name;

        uint expectedNumAttempts = 0;
        uint numAttempts;

        int expectedBalance = 0;
        int balance;

        (name, numAttempts, balance) = playerCRUD.getPlayerByAddress(this);

        Assert.equal(name, expectedName, "Player name registration didn't work.");
        Assert.equal(numAttempts, expectedNumAttempts, "Player numAttempts registration didn't work.");
        Assert.equal(balance, expectedBalance, "Player balance didn't work.");

        playerCRUD.deletePlayer(this);

    }

    function testPlayersCounter() public {

        uint expectedNumPlayers = 0;
        uint numPlayers = playerCRUD.getPlayersCount();

        Assert.equal(numPlayers, expectedNumPlayers, "Player's initial counter didn't work");

        playerCRUD.registerPlayer("Nacho");

        numPlayers = playerCRUD.getPlayersCount();
        expectedNumPlayers = 1;

        Assert.equal(numPlayers, expectedNumPlayers, "Player's counter didn't work");

        playerCRUD.deletePlayer(this);
    }
}
