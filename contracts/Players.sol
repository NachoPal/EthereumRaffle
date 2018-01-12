pragma solidity ^0.4.17;


contract Players {

    event PlayerAdded(bytes32 name, uint pendingWithdrawals);
    event PlayerDeleted(address playerAddress, bytes32 name);


    struct Player {
        uint index;
        bool exists;
        bytes32 name;
        uint pendingWithdrawals;
        bytes32[] raffles;
    }

    address[] playersAddresses;

    mapping (address => Player) public players;


    function isRegistered(address _address)
        public view returns(bool)
    {
        return players[_address].exists;
    }


    function registerPlayer(bytes32 _name)
        public returns(address newPlayerAddress)
    {
        //Check if the Player already exist
        require(isRegistered(msg.sender) == false);

        //Save in addresses array
        uint index = playersAddresses.push(msg.sender) - 1;

        //Save in mapping(address => Player)
        bytes32[] memory raffles;

        players[msg.sender] = Player({index: index,
                                    exists:true,
                                    name: _name,
                                    pendingWithdrawals: 0,
                                    raffles: raffles});

        //Call to the event
        PlayerAdded(_name,0);

        newPlayerAddress = msg.sender;
    }


    function countTotalPlayers()
        public view returns(uint count)
    {
        count = playersAddresses.length;
    }


    function playerAddressAtIndex(uint _index)
        public view returns(address playerAddress)
    {
        //Make sure I don't try to read a index that doesn't exist
        require(_index < countTotalPlayers());

        playerAddress = playersAddresses[_index];
    }


    function playerByAddress(address _playerAddress)
        public view returns(bytes32 name, uint pendingWithdrawals)
    {
        //Check if we are trying to retrieve info from a existing Player
        require(isRegistered(_playerAddress));

        name = players[_playerAddress].name;
        pendingWithdrawals = players[_playerAddress].pendingWithdrawals;
    }


    function playerRaffles(address _playerAddress)
        external view returns(bytes32[] playedRaffles)
    {
        playedRaffles = players[_playerAddress].raffles;
    }


    function destroyPlayer(address _playerAddress) public {
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

        PlayerDeleted(_playerAddress, name);
    }
}
