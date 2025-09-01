// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test} from "forge-std/Test.sol";
import {crowdfund} from "../src/Crowdfund.sol";
contract crowdfundTest is Test{
    crowdfund public Crowdfund;

    function setUp() public{
        Crowdfund = new crowdfund();
    }
}