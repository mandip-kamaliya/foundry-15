// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract crowdfund{

    struct Campaign{
        string name;
        uint256 id;
    }
    Campaign[] public campaigns;
    mapping (address=>Campaign) public userTocampaign;
    mapping (address=>uint256) public userfunded;

    event Funded(address indexed _sender,uint256 _amount);

    function fundCampaign(uint256 _id) public payable{
        require(msg.value > 0 , "value should be more than zero!!");
        userfunded[msg.sender]+=msg.value;
        emit Funded(msg.sender,msg.value);
    }
    



}