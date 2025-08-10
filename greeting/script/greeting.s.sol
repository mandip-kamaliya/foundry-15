// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {Greeting} from "../src/Greeting.sol";

contract greeting is Script{
    Greeting public  greeting;

function setUp() public{}
function run() public{
    vm.startBroadcast();
    greeting = new Greeting();
    vm.stopBroadcast();
}


}