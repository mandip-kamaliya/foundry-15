// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";



contract SimpleBankTest is Test{
    SimpleBank simplebank;
    address user = makeAddr("user");
     function setUp() public {
        simplebank = new SimpleBank();
     }

     function test_deposit() public{
        vm.startPrank(user);
        vm.deal(user,1 ether);
        simplebank.deposit{value : 0.01 ether}();
        assertEq(simplebank.getBalance(user),0.01 ether);
        vm.stopPrank();
     }

     function test_withdraw() public{
        vm.startPrank(user);
        vm.deal(user,1 ether);
        simplebank.deposit{value : 0.01 ether}();
        simplebank.withdraw(0.01 ether);
        assertEq(simplebank.getBalance(user),0);
        vm.stopPrank();
     }

     function test_amountcheck() public{
        vm.startPrank(user);
        vm.deal(user,1 ether);
        simplebank.deposit{value:0.01 ether}();
        assertEq(simplebank.balances(user),0.01 ether);
        vm.stopPrank();
     }

     function test_revert_depositzero() public{
        vm.expectRevert("amount should be more than zero");
        vm.prank(user);
        simplebank.deposit{value:0 }();
     }
}