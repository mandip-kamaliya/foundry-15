// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test} from "forge-std/Test.sol";
import {crowdfund} from "../src/Crowdfund.sol";
contract crowdfundTest is Test{
    crowdfund public Crowdfund;
    address user = makeAddr("user");

    function setUp() public{
        Crowdfund = new crowdfund();
    }

    function test_addCampaign() public{
        uint256 id = Crowdfund.addCampaign("Test Campaign");
        (address owner, string memory name, uint256 campaignId) = Crowdfund.campaigns(0);
        assertEq(owner, address(this));
        assertEq(name, "Test Campaign");
        assertEq(campaignId, id);
    }

    function test_fundCampaign() public{
        uint256 id = Crowdfund.addCampaign("Test Campaign");
        (address owner, string memory name, uint256 campaignId) = Crowdfund.campaigns(0);
        vm.deal(user,1 ether);
        vm.prank(user);
        Crowdfund.fundCampaign{value:1 ether}(id);
        assertEq(Crowdfund.contributions(id,user),1 ether);
    }

    function test_refundCampaign() public{
         uint256 id = Crowdfund.addCampaign("Test Campaign");
        (address owner, string memory name, uint256 campaignId) = Crowdfund.campaigns(0);
        vm.deal(user,1 ether);
        vm.startPrank(user);
        Crowdfund.fundCampaign{value:1 ether}(id);
        Crowdfund.refundCampaign(id);
        assertEq(user.balance,1 ether);
    }
}