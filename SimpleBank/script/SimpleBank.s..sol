// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankScript is Script {
    SimpleBank public simplebank;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        simplebank = new SimpleBank();

        vm.stopBroadcast();
    }
}
