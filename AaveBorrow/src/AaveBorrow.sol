// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Aave V3 Interfaces
interface IPool {
    function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf) external;
}

interface IWETHGateway {
    function depositETH(address pool, address onBehalfOf, uint16 referralCode) external payable;
}

contract AaveBorrow {
    // --- Aave Mainnet Addresses ---
    // Aave V3 Pool contract on Ethereum Mainnet
    IPool public constant POOL = IPool(0x87870Bca3F3fD6036aBfe49E277c72477f8A6354);
    // WETH Token on Ethereum Mainnet
    IERC20 public constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    // USDC Token on Ethereum Mainnet
    IERC20 public constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    // Aave WETH Gateway for depositing ETH as WETH collateral
    IWETHGateway public constant WETH_GATEWAY = IWETHGateway(0x387d311e47e80b498169e6fb51d3193167d89F7d);
    
    // Function to deposit ETH as WETH collateral into Aave
    function depositCollateral() public payable {
        // Use the WETH Gateway to wrap ETH and deposit it into the Aave Pool in one transaction
        WETH_GATEWAY.depositETH{value: msg.value}(address(POOL), address(this), 0);
    }
    
    // Function to borrow USDC against the deposited collateral
    function borrowUSDC(uint256 amount) public {
        // Borrow USDC from the Aave Pool
        // InterestRateMode 2 = Variable interest rate
        POOL.borrow(address(USDC), amount, 2, 0, address(this));
    }
}