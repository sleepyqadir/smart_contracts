// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract BabuCoin {
    uint contractStartTime;
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to , uint amount);


    modifier onlyOwner {
        require(msg.sender == minter,"only the minter can call this function");
        _;
    }

    modifier timePassed {
        require(block.timestamp >= contractStartTime + 30 );
        _;
    }

    constructor(){
        minter = msg.sender;
        contractStartTime = block.timestamp;
    }

    function mint(address reciever, uint256 amount) public onlyOwner {
        require(amount < 1e60, "amount is too high");
        balances[reciever] += amount;
    }

    function send(address reciever , uint amount) public timePassed {
        require( amount <= balances[msg.sender],"insufficient balance");
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit Sent(msg.sender , reciever,amount);  
    }

}