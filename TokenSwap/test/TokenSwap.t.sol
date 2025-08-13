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
    function  test_addLiquidity() public{
        uint256 Liquidity = 1000 ether ;
        
        tokenB.mint(owner,Liquidity);
        vm.prank(owner);
        tokenB.approve(address(SwapContract),Liquidity);
        vm.prank(owner);
        SwapContract.addLiquidity(Liquidity);
        assertEq(tokenB.balanceOf(owner),0);
    }

    function testFuzz_Swap_Successfull(uint256 _amount) public{
        uint256 Liquidity = 1000 ether ;
        vm.assume(_amount > 0 && _amount<=Liquidity);
        tokenB.mint(owner,Liquidity);
        vm.prank(owner);
        tokenB.approve(address(SwapContract),Liquidity);
        vm.prank(owner);
        SwapContract.addLiquidity(Liquidity);
        assertEq(tokenB.balanceOf(address(SwapContract)),Liquidity);

        tokenA.mint(user,_amount);
        vm.prank(user);
        tokenA.approve(address(SwapContract),_amount);
        vm.prank(user);
        SwapContract.swap(_amount);
        assertEq(tokenA.balanceOf(user),0);
        assertEq(tokenB.balanceOf(user),_amount);
        assertEq(tokenA.balanceOf(address(SwapContract)),_amount);
        assertEq(tokenB.balanceOf(address(SwapContract)),Liquidity - _amount);
    }

    function testFuzz_Swap_RevertIfInsufficientLiquidity(uint256 _liquidity , uint256 _amount) public{
        vm.assume(_amount > _liquidity);
        vm.assume(_liquidity >0);
         tokenB.mint(owner,_liquidity);
        vm.prank(owner);
        tokenB.approve(address(SwapContract),_liquidity);
        vm.prank(owner);
        SwapContract.addLiquidity(_liquidity);
        assertEq(tokenB.balanceOf(address(SwapContract)),_liquidity);

        tokenA.mint(user,_amount);
        vm.prank(user);
        tokenA.approve(address(SwapContract),_amount);
        vm.expectRevert("Insufficient liquidity");
        vm.prank(user);
        SwapContract.swap(_amount);
    }

    contract Handler is Test {
        mokeERC20 public tokenA;
        mokeERC20 public tokenB;
        TokenSwap public SwapContract;

        uint256 public initialLiquidity = 1000000 ether;

        constructor(TokenSwap _swapcontract,mokeERC20 _tokenA , mokeERC20 _tokenB ){
            
        }

    }
}
