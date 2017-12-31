pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Raffle.sol";

contract TestRaffle {
    Raffle raffle = Raffle(DeployedAddresses.Raffle());

    function testPlayerRegistration() public {
        //We register a new Player
        raffle.registerPlayer("Nacho");

        bytes32 expectedName = "Nacho";
        bytes32 name;

        uint expectedNumAttempts = 0;
        uint numAttempts;

        int expectedBalance = 0;
        int balance;

        (name, numAttempts, balance) = raffle.getPlayerByAddress(msg.sender);

        Assert.equal(name, expectedName, "Player name registration didn't work.");
        Assert.equal(numAttempts, expectedNumAttempts, "Player numAttempts registration didn't work.");
        Assert.equal(balance, expectedBalance, "Player balance didn't work.");

    }
}
