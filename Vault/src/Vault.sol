// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Vault
 * @author Rajkot, Gujarat
 * @notice A simple vault for depositing and withdrawing ETH with security features.
 */
contract Vault {
    // --- Errors ---
    error NotOwner();
    error Paused();
    error NotPaused();
    error TransferFailed();
    error NoReentrancy();

    // --- State Variables ---
    address public immutable owner;
    mapping(address => uint) public balances;
    bool public isPaused;
    bool internal locked; // Reentrancy guard

    // --- Events ---
    event Deposited(address indexed user, uint amount);
    event Withdrawn(address indexed user, uint amount);
    event PausedStateChanged(bool isPaused);

    // --- Modifiers ---
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier whenNotPaused() {
        if (isPaused) revert Paused();
        _;
    }

    modifier whenPaused() {
        if (!isPaused) revert NotPaused();
        _;
    }

    modifier nonReentrant() {
        if (locked) revert NoReentrancy();
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
    }

    // --- Functions ---
    function deposit() public payable whenNotPaused {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() external nonReentrant whenNotPaused {
        uint amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        // Checks-Effects-Interactions Pattern
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) revert TransferFailed();

        emit Withdrawn(msg.sender, amount);
    }

    function setPaused(bool _paused) external onlyOwner {
        isPaused = _paused;
        emit PausedStateChanged(_paused);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {
        deposit();
    }
}