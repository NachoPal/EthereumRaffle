pragma solidity ^0.4.17;


contract Raffle {

    event PlayerAdded(bytes32 name, uint numAttempts, int balance);


    struct Player {
        uint index;
        bool exists;
        bytes32 name;
        uint numAttempts;
        int balance;
    }

    address[] playersAddresses;

    mapping (address => Player) public players;

    function isARegisteredPlayer(address _address) public view returns(bool registered){
        registered = players[_address].exists;
    }

    function registerPlayer(bytes32 _name) public returns(address newPlayerAddress){
        //Check if the Player already exist
        require(isARegisteredPlayer(msg.sender) == false);

        //Save in addresses array
        uint index = playersAddresses.push(msg.sender) - 1;

        //Save in mapping(address => Player)
        players[msg.sender] = Player(index,true,_name,0,0);

        //Call to the event
        PlayerAdded(_name,0,0);

        newPlayerAddress = msg.sender;
    }

    function getPlayersCount() public view returns(uint count) {
        count = playersAddresses.length;
    }

    function getPlayerAddressAtIndex(uint _index) public view returns(address playerAddress){
        //Make sure I don't try to read a index that doesn't exist??
        require(_index < getPlayersCount());

        playerAddress = playersAddresses[_index];
    }

    function getPlayerByAddress(address _playerAddress) public view returns(bytes32 name, uint numAttempts, int balance) {
        //Check if we are trying to retrieve info from a existing Player
        //require(isARegisteredPlayer(_playerAddress));

        name = players[_playerAddress].name;
        numAttempts = players[_playerAddress].numAttempts;
        balance = players[_playerAddress].balance;
    }

}
