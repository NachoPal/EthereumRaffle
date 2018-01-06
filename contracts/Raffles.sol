pragma solidity ^0.4.17;


contract Raffles {

    //Also used as nonce
    uint public length = 0;


    struct Raffle {
        bytes32 id;
        bytes32 next;
        bool exists;
        bool finished;
        uint price;
        uint lifespan;

        mapping (uint => address) ticketOwner;
        mapping (address => uint[]) playerTicketsNumbers;

        uint lastTicketNumber;
        uint winnerTicket;
    }

    //Linked list of Raffle
    bytes32 public head;
    mapping (bytes32 => Raffle) public raffles;


    function Raffles() {}

    function isActiveRaffle(_raffle) public view returns(bool active) {
        active = (_raffle.exists) && (_raffle.finished == false);
    }

    function create(uint _price, uint _lifespan) private returns(bool){
        Raffle memory raffle = Raffle(0,head,true,false,_price,_lifespan);

        bytes32 id = sha3(raffle.price,raffle.lifespan,now,length);
        raffles[id] = raffle;
        raffle = raffle[id];
        raffle.id = id;

        head = id;
        length = length + 1;
    }

    function getWinnerNumber() private{

    }

//    function destroy(uint _index) private{
//
//    }

}
