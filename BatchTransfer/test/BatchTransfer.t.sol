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
        uint256 count = 10 ; 

        address payable[] memory recipients = new address payable[](count);

        for (uint256 i =0 ; i < count ; i++){
            recipients[i] = payable(address(uint160(i+1000)));
        }
        uint256 amount = 10 ether ;
        batchtransfer.disburse{value :amount }(recipients);
        assertTrue(address(batchtransfer).balance < count);

    }

}