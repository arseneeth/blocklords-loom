pragma solidity >=0.5.0 <0.6.0;

import "../common/Ownable.sol";
import "../common/ERC721.sol";


contract HeroERC721 is ERC721, Ownable {

  string public constant name = "Hero";
  string public constant symbol = "HERO";

  struct Hero{
  	uint id; 
  }

  Hero[] public heros;

}