// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TokenSwap.sol";

/**
 * @title MockERC20
 * @notice A self-contained mock ERC20 contract for testing.
 * @dev This version is written from scratch to avoid dependency conflicts
 * and includes robust checks in its functions.
 */
contract MockERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }

    function mint(address to, uint256 amount) public {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        uint256 fromBalance = balanceOf[msg.sender];
        require(fromBalance >= amount, "MockERC20: transfer amount exceeds balance");
        balanceOf[msg.sender] = fromBalance - amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = allowance[from][msg.sender];
        require(currentAllowance >= amount, "MockERC20: insufficient allowance");
        allowance[from][msg.sender] = currentAllowance - amount;

        uint256 fromBalance = balanceOf[from];
        require(fromBalance >= amount, "MockERC20: transfer amount exceeds balance");
        balanceOf[from] = fromBalance - amount;
        
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}


contract TokenSwapInvariantTest is Test {
    TokenSwap public swapContract;
    MockERC20 public tokenA;
    MockERC20 public tokenB;
    Handler public handler;

    function setUp() public {
        tokenA = new MockERC20("Token A", "TKA");
        tokenB = new MockERC20("Token B", "TKB");
        
        address owner = makeAddr("owner");
        vm.prank(owner);
        swapContract = new TokenSwap(address(tokenA), address(tokenB));
        
        handler = new Handler(swapContract, tokenA, tokenB);
        
        targetContract(address(handler));
    }

    function invariant_conservationOfValue() public {
        uint256 tokenAGained = tokenA.balanceOf(address(swapContract));
        uint256 tokenBLost = handler.initialLiquidity() - tokenB.balanceOf(address(swapContract));

        assertEq(tokenAGained, tokenBLost);
    }
}

contract Handler is Test {
    TokenSwap public swapContract;
    MockERC20 public tokenA;
    MockERC20 public tokenB;

    uint256 public initialLiquidity = 1_000_000 ether;

    constructor(TokenSwap _swapContract, MockERC20 _tokenA, MockERC20 _tokenB) {
        swapContract = _swapContract;
        tokenA = _tokenA;
        tokenB = _tokenB;
        tokenB.mint(address(swapContract), initialLiquidity);
    }
    
    function swap(uint256 _amount) public {
        uint256 contractLiquidity = tokenB.balanceOf(address(swapContract));
        if (contractLiquidity == 0) return; // Cannot swap if no liquidity

        _amount = bound(_amount, 1, contractLiquidity);
        
        address caller = msg.sender;
        tokenA.mint(caller, _amount);
        
        vm.prank(caller);
        tokenA.approve(address(swapContract), _amount);
        
        vm.prank(caller);
        swapContract.swap(_amount);
    }
}
