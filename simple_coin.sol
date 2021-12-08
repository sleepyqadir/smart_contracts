// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract BabuCoin {
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to , uint amount);

    constructor(){
        minter = msg.sender;
    }

    function mint(address reciever, uint256 amount) public {
        require(amount < 1e60, "amount is too high");
        require(msg.sender == minter, "invalid account to mint babu coins");
        balances[reciever] += amount;
    }

    function send(address reciever , uint amount) public {
        require( amount <= balances[msg.sender],"insufficient balance");
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit Sent(msg.sender , reciever,amount);  
    }

}
