//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract cityPoll {
    address public owner;
   
     struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }


    mapping(uint => City) public cities; //mapping city Id with the City ctruct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    
    uint256 public cityCount = 1; // number of city added
   
    constructor(string memory _cityName) public {
    owner=msg.sender;
    cities[0].cityName=_cityName;
    cities[0].vote=0;
  
    }
 
 


    function addCity(string memory _cityName) public {
         require(owner==msg.sender,"Must be an owner");
        // City storage newCity = cities[cityCount];
        cities[cityCount].cityName = _cityName;
        cityCount++;

    }
    
    function vote(uint8 _cityId ) public {
        require(!hasVoted[msg.sender],"You have already voted");
        City storage VoteCity = cities[_cityId];
         VoteCity.vote++;
         hasVoted[msg.sender]=true;

        
        //TODO Vote the selected city through cityID

    }
    function getCity(uint _cityId) public view returns (string memory) {
        return cities[_cityId].cityName;
 
    }
    function getVote(uint _cityId) public view returns (uint256) {
   
        return cities[_cityId].vote;
    }
}
