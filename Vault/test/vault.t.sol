// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;
    address public owner = address(0x1);
    address public user = address(0x2);

    function setUp() public {
        // As part of setup, we become the owner to deploy the contract
        vm.prank(owner);
        vault = new Vault();

        // Send some starting ETH to the user for testing
        vm.deal(user, 10 ether);
    }

    // --- Access Control Tests ---
    function test_OnlyOwnerCanPause() public {
        // We expect this call to fail with the NotOwner error
        vm.expectRevert(Vault.NotOwner.selector);
        
        // Prank as a regular user and try to pause the contract
        vm.prank(user);
        vault.setPaused(true);
    }

    function test_OwnerCanPauseAndUnpause() public {
        vm.prank(owner);
        vault.setPaused(true);
        assertTrue(vault.isPaused());

        vm.prank(owner);
        vault.setPaused(false);
        assertFalse(vault.isPaused());
    }

    // --- State Logic Tests ---
    function test_CannotDepositWhenPaused() public {
        // Owner pauses the contract
        vm.prank(owner);
        vault.setPaused(true);

        // Expect the deposit to revert with the Paused error
        vm.expectRevert(Vault.Paused.selector);

        // Prank as a user and try to deposit
        vm.prank(user);
        vm.deal(user, 1 ether); // Give user some ETH
        vault.deposit{value: 1 ether}();
    }

    function test_UserCanDepositAndWithdraw() public {
        // User deposits 1 ether
        vm.prank(user);
        vault.deposit{value: 1 ether}();
        assertEq(vault.balances(user), 1 ether);
        assertEq(address(vault).balance, 1 ether);

        // User withdraws their balance
        vm.prank(user);
        vault.withdraw();
        assertEq(vault.balances(user), 0);
        assertEq(address(vault).balance, 0);
    }
}