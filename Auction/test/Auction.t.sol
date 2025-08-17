// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";
contract AuctionTest is Test{
    Auction public auction;
    address user = makeAddr("user");
    uint256 startingtime;

    function setUp() public{
        startingtime = block.timestamp ; 
        auction = new Auction(1 hours);
        vm.deal(user , 5 ether);
    }

    function test_bid() public{
        vm.prank(user);
        auction.bid{value : 1 ether }();
        assertEq(address(auction).balance , 1 ether);
    }

    function test_timeleft() public{
        assertEq(auction.timeleft(),1 hours );

        vm.warp(startingtime + 1 hours);
        assertEq(auction.timeleft(),0);

        vm.warp(startingtime + 30 minutes);
        assertEq(auction.timeleft(),30 minutes);
    }

    function test_endauction() public{
        vm.warp(startingtime + 1 hours);
        vm.expectEmit(true,true,true,true);
        
        auction.endauction();
    }
}