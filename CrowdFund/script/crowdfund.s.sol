// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {crowdfund} from "../src/Crowdfund.sol";
contract CrowdfundScript is Script{
    crowdfund public crowdFund;

    
    function run() public{
        vm.startBroadcast();
        crowdFund = new crowdfund();
        vm.stopBroadcast();

    }
}