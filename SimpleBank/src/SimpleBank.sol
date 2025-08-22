// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract SimpleBank{

    //mapings
    mapping (address => uint) public balances;

    //events
    event deposited(uint256 _amount , address _sender);
    event Withdrawal(uint256 _amount , address _sender );


    //functions
    function deposit() public payable{
        require(msg.value>0,"amount should be more than zero");
        balances[msg.sender] += msg.value ;
        emit deposited(msg.value , msg.sender);
    }

      function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount , "user dont have enough funds to withdraw!!");
        balances[msg.sender] -= _amount ;
        emit Withdrawal(_amount , msg.sender);
        (bool success , ) = msg.sender.call{value : _amount}("");
        require(success,"withdrawal failed");
    }

    function getBalance(address _sender) public view returns(uint256){
        return balances[_sender];
    }
}