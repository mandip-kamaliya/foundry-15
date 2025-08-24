// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract crowdfund{

    struct Campaign{
        string name;
        uint256 id;
    }
    Campaign[] public campaigns;
    uint256 public nextCampaignId;
    mapping (address=>Campaign) public userTocampaign;
    mapping (address=>uint256) public userfunded;

    event Funded(address indexed _sender,uint256 _amount);
    event AddCampaign(string _name , uint256 indexed _id);

    function fundCampaign(uint256 _id) public payable{
        require(msg.value > 0 , "value should be more than zero!!");
        userfunded[msg.sender]+=msg.value;
        emit Funded(msg.sender,msg.value);
    }

    function addCampaign(string memory _name ) public returns(uint256){
        uint256 newId = nextCampaignId;
        campaigns.push(Campaign({
            name:_name,
            id:newId
        }));
    nextCampaignId++; 
    emit AddCampaign(_name , newId); 
    return newId;    
    }



}