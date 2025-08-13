// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract mokeERC20 is ERC20{

    constructor(string memory _name , string memory _symbol) ERC20("name","symbol"){}
    function mint(address _to , uint256 _amount) public {
        _mint(_to , _amount);
    }
}
contract TokenSwapTest is Test{
    mokeERC20 public tokenA;
    mokeERC20 public tokenB;
    TokenSwap public SwapContract ;
    address public owner = makeAddr("owner");
    address public user = makeAddr("user");

    function setUp() public{
       tokenA = new mokeERC20("TOKEN A","TKA");
       tokenB = new mokeERC20("TOKEN B","TKB");
       vm.prank(owner);
       SwapContract = new TokenSwap(address(tokenA) , address(tokenB));
    }

    function test_InitialState() public{
        assertEq(SwapContract.owner(),owner);
        assertEq(address(SwapContract.tokenA()),address(tokenA));
        assertEq(address(SwapContract.tokenB()),address(tokenB));
    }

}
