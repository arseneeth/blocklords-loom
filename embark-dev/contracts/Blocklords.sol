pragma solidity >=0.5.0 <0.6.0;

import "./MetadataStore.sol";
import "./HeroToken.sol";

/**
* @title Blocklords
* @author Arseny Kin
* @notice Blocklords main contract
*/


contract Blocklords is HeroToken{

  // Market Durations
  uint constant HOURS_8       = 28800;      // 28_800 Seconds are 8 hours
  uint constant HOURS_12      = 43200;     // 43_200 Seconds are 12 hours
  uint constant HOURS_24      = 86400;     // 86_400 Seconds are 24 hours

  // Battle Results
  uint constant ATTACKER_WON  = 1;
  uint constant ATTACKER_LOSE = 2;

  // Battle Types
  uint constant PVP= 1;       // Player Against Player at the Strongholds
  uint constant PVC= 2;       // Player Against City
  uint constant PVE= 3;       // Player Against NPC on the map

  event HeroCreation(address creator, uint id);
  event HeroCreationWithReferalLink(address creator, uint id, address referer_address);


  MetadataStore public metadataStore;
  HeroToken public heroToken;

  function createHero(address payable _player,uint _id, uint[] memory _heroStats/*, uint[] _heroItems*/) public payable {
    metadataStore.addHero(_player, _id, _heroStats);
    heroToken.mintTo(_player, _id);
  }

}