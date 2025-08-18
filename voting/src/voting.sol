// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract voting {
    struct proposol {
        string  name;
        uint256 VotedCount;
    }
    proposol[] public proposols;
    string memory proposol ;
    uint256 immutable public fees = 0.01 ether ;
    mapping (uint256 => string ) public indexTOproposol;
    mapping (uint256 => proposol) public votesOnproposol;

    event voted(address indexed _sender );

    function vote(uint256 _fees) public payable{
        (bool sent,) = address(this).call{value:_fees}();
        require("sent","transation failed");
        
        emit voted(msg.sender);
    }
}