pragma solidity >=0.5.0 <0.6.0;

import "./common/Ownable.sol";
// import "./common/TradeableERC721Token.sol";
import "./common/ERC721.sol";
import "./MetadataStore.sol";

/**
* @title HeroToken
* @author Arseny Kin
* @notice Contract for ERC721 Hero token
*/


contract HeroToken is ERC721, Ownable {

  string public constant name = "Hero";
  string public constant symbol = "HERO";

  struct HeroToken{
  	uint id; 
  }

  HeroToken[] public heros;

  function mint() public onlyOwner{

  }

}