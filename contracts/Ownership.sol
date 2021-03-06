pragma solidity ^0.4.17;


contract Ownership {

    //Assigned at the construction, so msg.sender will be the account which creates
    //the contract
    address public originalOwner = msg.sender;
    mapping (address => bool) owners;

    function Ownership() public {
        //Add owner to the list of owners
        owners[originalOwner] = true;
    }

    modifier isOwner(address _address) {
        require(owners[_address]);
        _;
    }

    modifier isOriginalOwner() {
        require(msg.sender == originalOwner);
        _;
    }

    //Adding new owners.
    function addOwner(address _newOwner) external returns(bool) {
        //Only the original owner has the right to add new ones
        if(msg.sender == originalOwner) {
            owners[_newOwner] = true;
            return true;
        }else {
            return false;
        }
    }

    function removeOwner(address _toRemoveOwner) external returns(bool) {
        //Only the original owner has the right to add new ones
        //Make sure the original owner doesn't remove itself
        if(msg.sender == originalOwner && msg.sender != _toRemoveOwner) {
            owners[_toRemoveOwner] = false;
            return true;
        }else {
            return false;
        }
    }
}
