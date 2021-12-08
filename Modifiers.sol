// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract BabuCoin {
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to , uint amount);


    modifier onlyOwner {
        require(msg.sender == minter,"only the minter can call this function");
        _;
    }

    modifier amountGreaterThan(uint256 amount){
        require(amount < 1e60, "amount is too high");
        _;
    }

    modifier balanceGreaterThan(uint amount){
        require( amount <= balances[msg.sender],"insufficient balance");
        _;
    }

    constructor(){
        minter = msg.sender;
    }

    function mint(address reciever, uint256 amount) public onlyOwner amountGreaterThan(amount){
        balances[reciever] += amount;
    }

    function send(address reciever , uint amount) public balanceGreaterThan(amount) {
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit Sent(msg.sender , reciever,amount);  
    }

}