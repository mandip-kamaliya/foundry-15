// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Auction { 
    uint256 public highestbid;
    address public highestbidder;
    uint256 public auctionendtime;
    address owner;
    bool ended;

    constructor(uint256 duration){
        owner = msg.sender;
        auctionendtime = block.timestamp + duration ;
    }

    //events
    event bidPlaced(address indexed bidder , uint256 _amount);
    event WinnerAnounce(address indexed Winner , uint256 _amount);

    function bid() public payable{
        require(msg.value > highestbid , "bid is low");
        highestbid = msg.value;
        highestbidder = msg.sender;

        emit bidPlaced(msg.sender , msg.value);
    }

    function timeleft() public returns(uint256){
        return (auctionendtime - block.timestamp) ;
    }

    function endauction() public{
        require(block.timestamp >= auctionendtime , "auction is active");
        require(!ended,"auction is already ended");
        ended = true ;
        emit WinnerAnounce(highestbidder,highestbid);
    }
}