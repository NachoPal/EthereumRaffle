pragma solidity ^0.4.17;

import "./Raffles.sol";


contract Players is Raffles{

    event PlayerAdded(bytes32 name, uint numAttempts, int balance);
    event PlayerDeleted(address playerAddress, bytes32 name);


    struct Player {
        uint index;
        bool exists;
        bytes32 name;
        uint numAttempts;
        int balance;
        bytes32[] raffles;
    }

    address[] playersAddresses;

    mapping (address => Player) public players;

    function isRegistered(address _address) public view returns(bool registered){
        registered = players[_address].exists;
    }

    function register(bytes32 _name) public returns(address newPlayerAddress){
        //Check if the Player already exist
        require(isRegistered(msg.sender) == false);

        //Save in addresses array
        uint index = playersAddresses.push(msg.sender) - 1;

        //Save in mapping(address => Player)
        bytes32[] memory raffles;

        players[msg.sender] = Player({index: index, exists:true, name: _name, numAttempts: 0, balance: 0, raffles: raffles});

        //Call to the event
        PlayerAdded(_name,0,0);

        newPlayerAddress = msg.sender;
    }

    function counter() public view returns(uint count) {
        count = playersAddresses.length;
    }

    function addressAtIndex(uint _index) public view returns(address playerAddress){
        //Make sure I don't try to read a index that doesn't exist
        require(_index < counter());

        playerAddress = playersAddresses[_index];
    }

    function byAddress(address _playerAddress) public view returns(bytes32 name, uint numAttempts, int balance) {
        //Check if we are trying to retrieve info from a existing Player
        require(isRegistered(_playerAddress));

        name = players[_playerAddress].name;
        numAttempts = players[_playerAddress].numAttempts;
        balance = players[_playerAddress].balance;
    }

    function destroy(address _playerAddress) public {
        //Check that the account to be deleted exist
        //Check only the owner of the account is going to delete it
        require(isRegistered(msg.sender) && msg.sender == _playerAddress);


        //We replace the address we want to delete by the last address of the array
        uint index = players[_playerAddress].index;
        bytes32 name = players[lastIndexAddress].name;
        uint lastIndex = playersAddresses.length - 1;

        address lastIndexAddress = playersAddresses[lastIndex];

        playersAddresses[index] = lastIndexAddress;

        //Remove last address and update Player
        playersAddresses.length --;

        //Update index in Player stored in mapping(address => Player)
        players[lastIndexAddress].index = index;

        //Remove info from deleted Player stored in mapping(address => Player)
        players[_playerAddress].name = "0x0";
        players[_playerAddress].exists = false;
        players[_playerAddress].numAttempts = 0;
        players[_playerAddress].balance = 0;


        PlayerDeleted(_playerAddress, name);
    }

    function play(bytes32 _id) public payable {
        //Check the Player exists
        require(isRegistered(msg.sender));

        //Check the Raffle exists and is not finished
        //if (raffles[_id].exists && raffles[_id].finished == false) {
            uint nextTicketNumber = raffles[_id].lastTicketNumber + 1;

            raffles[_id].ticketOwner[nextTicketNumber] = msg.sender;
            raffles[_id].playerTicketsNumbers[msg.sender].push(nextTicketNumber);

            raffles[_id].lastTicketNumber = nextTicketNumber;
        //}
    }

}
