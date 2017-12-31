pragma solidity ^0.4.19;


contract Raffle {

    event PlayerAdded(string name, uint numAttempts, int balance);


    struct Player {
        uint index;
        bool exists;
        string name;
        uint numAttempts;
        int balance;
    }

    address[] playersAddresses;

    mapping (address => Player) public players;

    function isAregisteredPlayer(address _address) private returns(bool registered){
        registered = players[_address].exists;
    }

    function registerPlayer(string _name) {
        //Check if the Player already exist
        require(isARegisteredPlayer(msg.sender) == false);

        //Save in addresses array
        uint index = playersAddresses.push(msg.sender) - 1;

        //Save in mapping(address => Player)
        players[msg.sender] = Player(index,true,_name,0,0);

        //Call to the event
        PlayerAdded(_name,0,0);
    }

    function getPlayersCount() public constant returns(uint count) {
        count = playersAddressIndex.length;
    }

    function getPlayerAddressAtIndex(uint _index) public view returns(address playerAddress){
        playerAddress = playersAddresses[index];
    }

    function getPlayerByAddress(address _playerAddress) public view returns(string name, uint numAttempts, int balance) {
        //Check if we are trying to retrieve info from a existing Player
        require(isAregisteredPlayer(_playerAddress));

        name = players[_playerAddress].name;
        numAttempts = players[_playerAddress].numAttempts;
        balance = players[_playerAddress].balance;
    }

}
