// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract BatchTransfer{
    function disburse(address payable[] calldata _recipients) public payable{
        uint256 recipientlength = _recipients.length;
        require(recipientlength > 0 , "recipients are empty");
        require(msg.value > 0 , "amount should be more than zero");

        uint256 amountperrecipient = msg.value / recipientlength ;

        for(uint256 i = 0 ; i < recipientlength ; i++){
            (bool sent ,) = _recipients[i].call{value : amountperrecipient}("");
            require(sent,"transfer failed");
        }
    }
}