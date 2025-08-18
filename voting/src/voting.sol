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

  function vote(uint256 memory ProposolIndex) public{
    require(!hasVoted[msg.sender],"user is already voted!!!");
    require(ProposolIndex <= proposols.length,"proposol dont exists!!");
    proposols[ProposolIndex].VoteCount++;
    hasVoted[msg.sender]=true;
    emit voted(msg.sender);
  }

  function Winner() public{
    uint256 proposolIndex = 0;
    uint256 votes = 0;

    for(let i;i <= proposols.length ; i++){
        if(proposols[i].VoteCount > votes){
            votes = proposols[proposolIndex];
            proposolIndex = i;
        }

    }
    return proposols[proposolIndex].name;
  }
}