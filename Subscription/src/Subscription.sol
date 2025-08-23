// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Subscription is Ownable {
    // --- State Variables ---

    IERC20 public immutable paymentToken;
    uint256 public subscriptionFee;

    struct Subscriber {
        bool isActive;
        uint256 nextPaymentDue;
    }

    mapping(address => Subscriber) public subscribers;

    // --- Events ---

    event Subscribed(address indexed user, uint256 feePaid, uint256 nextPayment);
    event Unsubscribed(address indexed user);
    event FeeChanged(uint256 newFee);

    // --- Constructor ---

    /**
     * @param _tokenAddress The address of the ERC20 token for payments.
     * @param _initialFee The initial monthly subscription fee.
     */
    constructor(address _tokenAddress, uint256 _initialFee) Ownable(msg.sender) {
        require(_tokenAddress != address(0), "Token address cannot be zero");
        require(_initialFee > 0, "Fee must be greater than zero");
        paymentToken = IERC20(_tokenAddress);
        subscriptionFee = _initialFee;
    }

    // --- Public & External Functions ---

    /**
     * @notice Allows a user to subscribe by paying the first month's fee.
     * @dev The user must first approve the contract to spend subscriptionFee tokens.
     */
    function subscribe() external {
        Subscriber storage subscriber = subscribers[msg.sender];
        require(!subscriber.isActive, "Already subscribed");

        // Transfer fee from user to this contract
        bool success = paymentToken.transferFrom(msg.sender, address(this), subscriptionFee);
        require(success, "Token transfer failed");

        // Set subscription details
        subscriber.isActive = true;
        subscriber.nextPaymentDue = block.timestamp + 30 days;

        emit Subscribed(msg.sender, subscriptionFee, subscriber.nextPaymentDue);
    }

    /**
     * @notice Allows a user to cancel their subscription.
     */
    function unsubscribe() external {
        Subscriber storage subscriber = subscribers[msg.sender];
        require(subscriber.isActive, "Not subscribed");

        subscriber.isActive = false;
        // nextPaymentDue is left as is for historical data
        
        emit Unsubscribed(msg.sender);
    }

    // --- Owner-Only Functions ---

    /**
     * @notice Allows the owner to withdraw the entire token balance of the contract.
     */
    function withdraw() external onlyOwner {
        uint256 balance = paymentToken.balanceOf(address(this));
        require(balance > 0, "No funds to withdraw");
        
        bool success = paymentToken.transfer(owner(), balance);
        require(success, "Withdrawal failed");
    }

    /**
     * @notice Allows the owner to update the monthly subscription fee.
     * @param _newFee The new subscription fee.
     */
    function setSubscriptionFee(uint256 _newFee) external onlyOwner {
        require(_newFee > 0, "Fee must be greater than zero");
        subscriptionFee = _newFee;
        emit FeeChanged(_newFee);
    }
}