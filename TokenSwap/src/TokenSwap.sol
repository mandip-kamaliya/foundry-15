// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import "forge-std/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract TokenSwap is Ownable{
    IERC20 public immutable tokenA ;
    IERC20 public immutable tokenB ;
   
    //events
    event TokenSwapped(address _sender , uint256 _amount);
    event AddLiquidity(uint256 _amount );
    event RemoveLiquidity(uint256 _amount );
    //constructor
    constructor(address _tokenA , address _tokenB) Ownable(msg.sender){
        require(_tokenA != _tokenB,"can not swap same tokens");
        require(_tokenA != address(0) && _tokenB != address(0),"Invalid tokens");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }
    function swap(uint256 _amount ) public{
        require(_amount>0,"amount should be more than zero");
        
        require(_amount <= tokenB.balanceOf(address(this)),"Insufficient liquidity");
            tokenA.transferFrom(msg.sender,address(this),_amount);
            
          tokenB.transfer(msg.sender,_amount);
            emit TokenSwapped(msg.sender , _amount);
    }

    function addLiquidity(uint256 _amount) public{
        require(_amount > 0, "amount should be more than zero");
        tokenB.transferFrom(msg.sender , address(this), _amount);
        emit AddLiquidity(_amount);
    }

    function removeLiquidity(uint256 _amount) public{
        require(_amount <= tokenB.balanceOf(address(this)),"amount is exceeding current liquidity");
        tokenB.transfer(msg.sender,_amount);
        emit RemoveLiquidity(_amount );
    } 
}