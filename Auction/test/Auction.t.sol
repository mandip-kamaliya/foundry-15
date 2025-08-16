// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";
contract AuctionTest is Test{
    Auction public auction;
    address user = makeAddr("user");

    function setUp() public{
        auction = new Auction(200000);
        vm.deal(user , 5 ether);
    }

    function test_bid() public{
        vm.prank(user);
        auction.bid{value : 1 ether }();
        assertEq(address(auction).balance , 1 ether);
    }
}