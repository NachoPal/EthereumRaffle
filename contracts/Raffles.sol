pragma solidity ^0.4.17;

import "./Players.sol";


contract Raffles is Players{

    //Also used as nonce
    uint public length = 0;

    struct Raffle {
        bytes32 id;
        bytes32 next;
        bool exists;
        bool finished;
        uint price;
        uint lifespan;

        uint lastTicketNumber;
        uint winnerTicket;

        mapping (uint => address) ticketOwner;
        mapping (address => uint[]) playerTicketsNumbers;
    }

    //Linked list of Raffle
    bytes32 public head;
    mapping (bytes32 => Raffle) public raffles;


    function Raffles() public {}

//    function isActiveRaffle(Raffle _raffle) external view returns(bool active) {
//        active = (_raffle.exists) && (_raffle.finished == false);
//    }

    function create(uint _price, uint _lifespan) public returns(bool){
        Raffle memory raffle = Raffle(0,head,true,false,_price,_lifespan,0,0);

        bytes32 id = keccak256(raffle.price,raffle.lifespan,now,length);
        raffles[id] = raffle;
        raffle = raffles[id];
        raffle.id = id;

        head = id;
        length = length + 1;
    }

    function ownerByTicket(bytes32 _raffleAddress, uint _ticketNumber) public view returns(address owner){
        owner = raffles[_raffleAddress].ticketOwner[_ticketNumber];
    }

    function ticketsByOwner(bytes32 _raffleAddress, address _ownerAddress) external view returns(uint[] tickets){
        tickets = raffles[_raffleAddress].playerTicketsNumbers[_ownerAddress];
    }

    function getWinnerNumber() private{

    }

    function play(bytes32 _raffleId) public payable {
        //Check the Player exists
        require(isRegistered(msg.sender));

        //Check the Raffle exists and is not finished
        if (raffles[_raffleId].exists && raffles[_raffleId].finished == false) {
            uint nextTicketNumber = raffles[_raffleId].lastTicketNumber + 1;

            raffles[_raffleId].ticketOwner[nextTicketNumber] = msg.sender;
            raffles[_raffleId].playerTicketsNumbers[msg.sender].push(nextTicketNumber);

            raffles[_raffleId].lastTicketNumber = nextTicketNumber;
        }
    }

//    function destroy(uint _index) private{
//
//    }

}
