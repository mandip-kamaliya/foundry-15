// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {NFT} from "../src/NFT.sol";
import {Script} from "forge-std/Script.sol";

contract DeployNft is Script {
    Nft nft;

    function run() public{
        vm.startBroadcast();
        nft = new NFT();
        vm.stopBroadcast();
    }
}