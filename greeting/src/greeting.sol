// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract greeting{
    string public Greeting;

    function setGreeting(string memory _greeting) public {
        Greeting = _greeting ;
    }

    function readGreeting() public view returns(string memory){
        return Greeting ;
    }
}