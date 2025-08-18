// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract voting {
    struct proposol {
        string  name;
        uint256 VoteCount;
    }
    proposol[] public proposols;
    string memory proposol ;
    mapping ( address => bool) public hasVoted;

    event voted(address indexed _sender );

    function addProposol(string memory _name) public {
        proposols.push(proposol({name:_name , VoteCount:0}));
    }

    function vote(uint256 _fees) public payable{
        (bool sent,) = address(this).call{value:_fees}();
        require("sent","transation failed");
        
        emit voted(msg.sender);
    }
}