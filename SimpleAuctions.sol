// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

 contract SimpleAuction {
     
     // parameters for the simpleAuction
     address payable public beneficiary;
     uint public auctionEndTime;

    //current state of the auctionEndTime

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) public pendingReturns;

    bool ended = false;

    event HighestBidIncrease(address bidder,uint amount);
    event AuctionEnded(address winner , uint amount);


    constructor(uint _biddingTime , address payable _beneficiary){
        auctionEndTime =  block.timestamp + _biddingTime;
        beneficiary = _beneficiary;
    }

    function bid() public payable {
        if(block.timestamp > auctionEndTime){
            revert("auction has been added");
        }
        if(msg.value <= highestBid){
            revert("There is already a higher or equal bid");
        }
        if(highestBid != 0){
            pendingReturns[highestBidder] = highestBid;            
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncrease(msg.sender,msg.value);
    }

    function withdraw() public returns(bool){
        uint amount = pendingReturns[msg.sender];
        if(amount > 0){
            pendingReturns[msg.sender] = 0;
            if(!payable(msg.sender).send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public{
        if(block.timestamp < auctionEndTime){
            revert("The auction has not ended yet");
        }
        if(ended){
            revert("Auction has already been ended");
        }
        ended = true;
        emit AuctionEnded(highestBidder,highestBid);
        beneficiary.transfer(highestBid);
    }
 }