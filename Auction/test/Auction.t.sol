// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";
contract AuctionTest is Test{
    Auction public auction;

    function setUp() public{
        auction = new Auction();
    }
}