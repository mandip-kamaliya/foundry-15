// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Greeting{
    string public GreetingVar;

    function setGreeting(string memory _greeting) public {
        GreetingVar = _greeting ;
    }

    function readGreeting() public view returns(string memory){
        return GreetingVar ;
    }
}