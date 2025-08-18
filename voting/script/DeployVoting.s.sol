// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/voting.sol";
contract DeployVoting is Script{
    Voting voting;

    function run() public{
        vm.startBroadcast();
        voting = new Voting();
        voting.addProposol("go to mainnet");
        vm.stopBroadcast();
    }

}