// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract crowdfund{

    struct Campaign{
        address owner;
        string name;
        uint256 id;
    }

    error _Notfunded();
    error _CampaignNotFound();
    error _TransactionFailed();
    error _MoreThanZero();
    error _IdIsNotValid();

    Campaign[] public campaigns;
    uint256 public nextCampaignId;
    mapping(uint256=>mapping(address=>uint256)) public contributions;
    mapping (address=>uint256) public userfunded;
    mapping (uint256=>Campaign) public CampaignById;

    event Funded(address indexed _sender,uint256 _amount);
    event AddCampaign(string _name , uint256 indexed _id);
    event RefundedCampaign(address _sender , uint256 _id , uint256 _refundValue);

    function fundCampaign(uint256 _id) public payable{
        if(msg.value>0){
            revert _MoreThanZero();
        }
        if(CampaignById[_id].owner == address(0)){
            revert _IdIsNotValid();
        }
        contributions[_id][msg.sender]+=msg.value;
        emit Funded(msg.sender,msg.value);
    }

    function addCampaign(string memory _name ) public returns(uint256){
        uint256 newId = nextCampaignId;
        campaigns.push(Campaign({
            owner:msg.sender,
            name:_name,
            id:newId
        }));
        nextCampaignId++; 
        emit AddCampaign(_name , newId); 
        return newId;    
    }
    function refundCampaign(uint256 _id) public{
        if(CampaignById[_id].owner == address(0)){
            revert _CampaignNotFound();
        }
        if(userfunded[msg.sender]==0){
            revert _Notfunded();
        }
        uint256 refundedAmount = contributions[_id][msg.sender];
        (bool success,) = msg.sender.call{value:refundedAmount}("");
        if(!success){
            revert _TransactionFailed();
        }
        emit RefundedCampaign(msg.sender,_id,refundedAmount);
    }
    function withdraw(uint256 _id) private{
        uint256 withdrawedAmount = userfunded[msg.sender];
            userfunded[msg.sender] = 0;

        (bool success,) = CampaignById[_id].owner.call{value:withdrawedAmount}("");
        if(!success){
                userfunded[msg.sender] = withdrawedAmount;
                revert _TransactionFailed();
        }
 }

}