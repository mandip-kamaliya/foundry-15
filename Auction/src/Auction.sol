// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Auction { 
    uint256 public highestbid;
    address public highestbidder;
    uint256 public auctionendtime;
    bool ended;

    function bid() public payable{
        require(msg.value > highestbid , "bid is not acceptable");
        highestbid = msg.value;

    }
}