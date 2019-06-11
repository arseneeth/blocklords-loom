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

    address public blocklords;

    function setBlocklordsAddress(address _blocklords) public onlyOwner {
        blocklords = _blocklords;
    }
  
	constructor() ERC721Full("HeroToken", "BLT") public { }

    /**
    * @dev calculates the next token ID based on totalSupply
    * @return uint256 for the next token ID
    */
    function _getNextTokenId() private view returns (uint256) {
        return totalSupply().add(1); 
    }

    /**
    * @dev Mints a token to an address 
    * @param _to address of the future owner of the token
    * @return uint256 for the token ID
    */
 
	function mintTo(address _to) public onlyOwner returns(uint256){
        require(msg.sender == blocklords, // TODO: add signature check
            "Only blocklords contract can initiate this transaction");

		// TODO: add check if hero exists
		uint256 newTokenId = _getNextTokenId();
		_mint(_to, newTokenId);
		return newTokenId;
	}

}