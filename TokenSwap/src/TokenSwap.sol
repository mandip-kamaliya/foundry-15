// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import "forge-std/interfaces/IERC20.sol";
contract TokenSwap{
    IERC20 public immutable tokenA ;
    IERC20 public immutable tokenB ;
   
    //events
    event TokenSwapped(address _sender , uint256 _amount);
    event AddLiquidity(uint256 _amount , address _token);
    event RemoveLiquidity(uint267 _amount , address _token);
    //constructor
    constructor(address _tokenA , address _tokenB) IERC20{
        require(_tokenA != _tokenB,"can not swap same tokens");
        require(_tokenA != address(0) && _tokenB != address(0),"Invalid tokens");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }
    function swap(uint256 _amount ) public{
        require(_amount>0,"amount should be more than zero");
        require(tokenB.balanceOf(address(this)>0,"not enough tokenB to swap"));
            tokenA.transferFrom(msg.sender,address(this),_amount);
            
          tokenB.transferFrom(address(this),msg.sender,_amount);
            emit TokenSwapped(msg.sender , _amount);
    }

    function addLiquidity(uint256 _amount) public{
        require(_amount > 0, "amount should be more than zero");
        tokenB.transferFrom(msg.sender , address(this), _amount);
        emit AddLiquidity(_amount,tokenB);
    }
}