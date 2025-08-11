// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";



contract SimpleBank is Test{
    SimpleBank simplebank;
     function setUp() public {
        simplebank = new SimpleBank();
     }

     function test_deposit() public{
        vm.startPrank(user);
        simplebank.deposit();
        asserEq()

     }
}