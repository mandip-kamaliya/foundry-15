// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";



contract SimpleBankTest is Test{
    SimpleBank simplebank;
    address user = makeAddr("user");
    address adam = makeAddr("adam");
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

     function test_revert_withdrawWithoutDeposit() public{
        vm.expectRevert("user dont have enough funds to withdraw!!");
        vm.prank(user);
        simplebank.withdraw(0.01 ether);
     }

     function test_revert_withdrawMoreThanBalance() public {
        // Arrange: User deposits 1 ETH
        vm.prank(user);
        vm.deal(user,1 ether);
        simplebank.deposit{value: 1 ether}();

        // Act & Assert: User tries to withdraw 2 ETH
        vm.expectRevert("user dont have enough funds to withdraw!!");
        vm.prank(user);
        simplebank.withdraw(2 ether);
    }
}