// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Subscription.sol";
import "./mocks/MockERC20.sol";

contract SubscriptionTest is Test {
    Subscription public subscriptionContract;
    MockERC20 public token;
    
    address public owner = address(0x1);
    address public user = address(0x2);

    uint256 public constant INITIAL_FEE = 100 * 1e18; // 100 tokens

    function setUp() public {
        vm.startPrank(owner);
        token = new MockERC20("Test Token", "TT");
        subscriptionContract = new Subscription(address(token), INITIAL_FEE);
        vm.stopPrank();

        // Give the user some tokens to pay for the subscription
        token.mint(user, 1000 * 1e18);
    }

    function test_SubscribeSuccessfully() public {
        vm.startPrank(user);
        // User must approve the contract to spend tokens on their behalf
        token.approve(address(subscriptionContract), INITIAL_FEE);
        subscriptionContract.subscribe();
        vm.stopPrank();

        Subscription.Subscriber memory sub = subscriptionContract.subscribers(user);
        assertTrue(sub.isActive, "User should be active");
        assertEq(sub.nextPaymentDue, block.timestamp + 30 days, "Next payment date is wrong");
        assertEq(token.balanceOf(address(subscriptionContract)), INITIAL_FEE, "Contract balance is wrong");
    }

    function test_Fail_SubscribeWithInsufficientAllowance() public {
        vm.startPrank(user);
        // Note: No token.approve() call here
        vm.expectRevert(); // Expects the transaction to fail
        subscriptionContract.subscribe();
        vm.stopPrank();
    }

    function test_Unsubscribe() public {
        // First, subscribe the user
        vm.startPrank(user);
        token.approve(address(subscriptionContract), INITIAL_FEE);
        subscriptionContract.subscribe();
        vm.stopPrank();

        // Now, unsubscribe
        vm.startPrank(user);
        subscriptionContract.unsubscribe();
        vm.stopPrank();

        Subscription.Subscriber memory sub = subscriptionContract.subscribers(user);
        assertFalse(sub.isActive, "User should be inactive after unsubscribing");
    }

    function test_OwnerCanWithdraw() public {
        // User subscribes and pays
        vm.prank(user);
        token.approve(address(subscriptionContract), INITIAL_FEE);
        vm.prank(user);
        subscriptionContract.subscribe();

        uint256 contractBalance = token.balanceOf(address(subscriptionContract));
        assertEq(contractBalance, INITIAL_FEE);

        // Owner withdraws
        vm.prank(owner);
        subscriptionContract.withdraw();

        assertEq(token.balanceOf(address(subscriptionContract)), 0, "Contract balance should be zero after withdrawal");
        assertEq(token.balanceOf(owner), contractBalance, "Owner did not receive the funds");
    }

    function test_Fail_NonOwnerCannotWithdraw() public {
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        subscriptionContract.withdraw();
    }
}