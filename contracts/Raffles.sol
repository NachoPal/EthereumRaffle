pragma solidity ^0.4.17;


contract Raffles {

    struct Raffle {
        bytes32 next;
        bool exists;
        bool finished;
        uint price;
        uint lifespan;
        uint winnerNumber;
        mapping (address => uint) players;

    }

    bytes32 public head;
    mapping (bytes32 => Raffle) public raffles;


    function Raffles() {}

    function isActiveRaffle(_raffle) public view returns(bool active) {
        active = (_raffle.exists) && (_raffle.finished == false);
    }

    function create(uint _price, uint _lifespan) private returns(Raffle newRaffle){
        uint position = rafflesIndexes.push(msg.sender) - 1;

        uint index = rafflesIndexes.push(count) - 1;

        Raffle newRaffle = Raffle(index,true,false,_price,_lifespan,0);
        raffles[count] = newRaffle;
        count++;
    }

    function getWinnerNumber() private{

    }

//    function destroy(uint _index) private{
//
//    }

}
