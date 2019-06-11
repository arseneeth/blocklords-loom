pragma solidity >=0.5.0 <0.6.0;

import "./common/Ownable.sol";
import "./openzeppelin/ERC721Full.sol"; 
// import "./MetadataStore.sol";

/**
* @title HeroToken
* @author Arseny Kin
* @notice Contract for ERC721 Hero token
*/
contract HeroToken is ERC721Full, Ownable/*, MetadataStore*/ {
  
	constructor() ERC721Full("HeroToken", "BLT") public { }

	function mintTo(address _to, uint _tokenId) public onlyOwner{
		// TODO: check if hero exists
		// TODO: add signature check
		_mint(_to, _tokenId);
	}

}