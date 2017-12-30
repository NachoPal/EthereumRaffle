pragma solidity ^0.4.19;


contract Raffle {

    //ESTOY AQUI AÑADIENDO EVENTOS
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

    function isAregisteredPlayer(address _address) return(bool registered){
        return players[_address].exists
    }

    function registerPlayer(string _name) {
        //Check if the Player already exist
        require(isARegisteredPlayer(msg.sender) == false);

        //Save in addresses array
        uint index = playersAddresses.push(msg.sender) - 1;

        players[msg.sender] = Player(index,true,_name,0,0);
    }

    function getPlayersCount() public constant returns(uint count) {
        return playersAddressIndex.length;
    }

    function getPlayerAddressAtIndex(uint _index) public view return(address playerAddress){
        return playersAddresses[index];
    }

    function getPlayerByAddress(address _playerAddress) public view return(string name, uint numAttemps, int balance) {
        require(isAregisteredPlayer(address _playerAddress));
        players[_playerAddress];
    }

}
