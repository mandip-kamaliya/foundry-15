// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {BatchTransfer} from "../src/BatchTransfer.sol";
contract BatchTransferTest is Test{
    BatchTransfer public batchtransfer ; 

    function setUp() public{
        batchtransfer = new BatchTransfer();
    }

    function test_disburse() public {
        
    }

}