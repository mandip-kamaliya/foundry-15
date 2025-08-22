// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Wallet
 * @author Rajkot, Gujarat
 * @notice A simple multisig wallet for educational purposes.
 */
contract Wallet {
    error NotOwner();
    error AlreadyOwner();
    error TxNotFound();
    error AlreadyConfirmed();
    error NotEnoughConfirmations();
    error TxAlreadyExecuted();
    error TransferFailed();

    // Event declarations
    event Deposit(address indexed sender, uint amount);
    event TransactionSubmitted(uint indexed txId, address indexed destination, uint value, bytes data);
    event TransactionConfirmed(uint indexed txId, address indexed owner);
    event TransactionExecuted(uint indexed txId);

    // State variables
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public requiredConfirmations;

    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    // Modifiers
    modifier onlyOwner() {
        if (!isOwner[msg.sender]) revert NotOwner();
        _;
    }

    modifier txExists(uint _txId) {
        if (_txId >= transactions.length) revert TxNotFound();
        _;
    }

    modifier notExecuted(uint _txId) {
        if (transactions[_txId].executed) revert TxAlreadyExecuted();
        _;
    }

    /**
     * @dev Sets up the multisig wallet with initial owners and required confirmations.
     */
    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            if (owner == address(0) || isOwner[owner]) revert AlreadyOwner();
            isOwner[owner] = true;
            owners.push(owner);
        }
        requiredConfirmations = _required;
    }

    // Allows the wallet to receive Ether
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev Allows an owner to submit a new transaction.
     */
    function submitTransaction(address _destination, uint _value, bytes calldata _data) external onlyOwner {
        uint txId = transactions.length;
        transactions.push(Transaction({destination: _destination, value: _value, data: _data, executed: false}));
        emit TransactionSubmitted(txId, _destination, _value, _data);
    }

    /**
     * @dev Allows an owner to confirm a pending transaction.
     */
    function confirmTransaction(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        if (confirmations[_txId][msg.sender]) revert AlreadyConfirmed();
        confirmations[_txId][msg.sender] = true;
        emit TransactionConfirmed(_txId, msg.sender);
    }

    /**
     * @dev Allows an owner to execute a transaction after enough confirmations.
     */
    function executeTransaction(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        uint confirmationCount = 0;
        for (uint i = 0; i < owners.length; i++) {
            if (confirmations[_txId][owners[i]]) {
                confirmationCount++;
            }
        }

        if (confirmationCount < requiredConfirmations) revert NotEnoughConfirmations();

        Transaction storage _tx = transactions[_txId];
        _tx.executed = true;

        (bool success, ) = _tx.destination.call{value: _tx.value}(_tx.data);
        if (!success) revert TransferFailed();

        emit TransactionExecuted(_txId);
    }
}