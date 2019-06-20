pragma solidity >=0.5.0 <0.6.0;

import "./common/Ownable.sol";
// import "./Blocklords.sol";

//import "../common/MessageSigned.sol";

/**
* @title MetadataStore
* @author Arseny Kin
* @notice Blocklords data storage
*/


contract MetadataStore is Ownable {

    address public blocklords;
    address public heroToken;

    function setBlocklordsAddress(address _blocklords) public onlyOwner {
        blocklords = _blocklords;
    }

    function setHeroTokenAddress(address _heroToken) public onlyOwner {
        heroToken = _heroToken;
    }

  // function random(uint entropy, uint number) private view returns (uint8) {
  //      // NOTE: This random generator is not entirely safe and   could potentially compromise the game
  //         return uint8(1 + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, entropy)))%number);
  //    }

    function dataHash(
        bytes32 _signature,
        uint _nonce        
    ) internal view returns (bytes32) {
        // TODO: add signature verification
        return keccak256(abi.encodePacked(address(this), _signature, _nonce));
    }

  function random(bytes32 entropy, uint nonce) private view returns (uint8) { // TODO: check do we really need nonce here!
       // NOTE: This random generator is not entirely safe and   could potentially compromise the game,
          return uint8(1 + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, entropy)))%nonce);
     }


/**
* @dev Hero struct and methods
*/

    struct Hero{
        uint LEADERSHIP;   // Leadership Stat value
        uint INTELLIGENCE; // Intelligence Stat value
        uint STRENGTH;     // Strength Stat value
        uint SPEED;        // Speed Stat value
        uint DEFENSE;      // Defense Stat value
        uint CREATED_TIME;
    }

    mapping (uint => Hero) heroes;

    function addHero(uint _id, uint[] memory _heroStats/*, uint[] _heroItems*/) public payable returns(bool) {
        require(msg.sender == blocklords,
            "Only blocklords contract can initiate this transaction");

        heroes[_id] = Hero( _heroStats[0], _heroStats[1],  _heroStats[2], _heroStats[3], _heroStats[4], block.number);

        return true;
    }

    function getHero(uint id) public view returns(uint, uint, uint, uint, uint, uint){
        return (heroes[id].LEADERSHIP, heroes[id].INTELLIGENCE, heroes[id].STRENGTH, heroes[id].SPEED, heroes[id].DEFENSE, heroes[id].CREATED_TIME);
    }


/**  
* @dev Item struct and methods
*/

    struct Item{

        uint STAT_TYPE; // Item can increase only one stat of Hero, there are five: Leadership, Defense, Speed, Strength and Intelligence
        uint QUALITY; // Item can be in different Quality. Used in Gameplay.

        uint GENERATION; // Items are given to Players only as a reward for holding Strongholds on map, or when players create a hero.
                         // Items are given from a list of items batches. Item batches are putted on Blockchain at once by Game Owner.
                         // Each of Item batches is called as a generation.

        uint STAT_VALUE;
        uint LEVEL;
        uint XP;         // Each battle where, Item was used by Hero, increases Experience (XP). Experiences increases Level. Level increases Stat value of Item
        address payable OWNER;   // Wallet address of Item owner.
    }

    mapping (uint => Item) public items;
    mapping (uint => uint) public updated_items; // battle id => item id

    function addItem (
      uint _creationType,
      uint _id,
      uint _statType,
      uint _quality,
      uint _generation,
      uint _statValue
    ) public {
        require(msg.sender == blocklords,
            "Only blocklords contract can initiate this transaction");

        require( _id > 0, "ITEM_ID_MUST_BE_HIGHER" );
        require( items[_id].OWNER == 0x0000000000000000000000000000000000000000, "ITEM_IN_BLOCKCHAIN" );

        items[_id] = Item(_statType, _quality, _generation, _statValue, 0, 0, msg.sender);

        // if ( creationType == STRONGHOLD_REWARD_BATCH ) {
        //   addStrongholdReward( id );     //if putItem(stronghold reward) ==> add to StrongholdReward
        // }
    }

    function getItem(uint id) public view returns(uint, uint, uint, uint, uint, uint, address payable){
      return (items[id].STAT_TYPE, items[id].QUALITY, items[id].GENERATION, items[id].STAT_VALUE, items[id].LEVEL, items[id].XP, items[id].OWNER);
    }

    function getUpdatedItem(uint battleId) public view returns(uint) {
      return updated_items[battleId];
    }

    function isUpgradableItem(uint id) private view returns (bool){
      if (id == 0) return false;
      if (items[id].STAT_VALUE == 0) return false;

      if (items[id].QUALITY == 1 && items[id].LEVEL == 3) return false;
      if (items[id].QUALITY == 2 && items[id].LEVEL == 5) return false;
      if (items[id].QUALITY == 3 && items[id].LEVEL == 7) return false;
      if (items[id].QUALITY == 4 && items[id].LEVEL == 9) return false;
      if (items[id].QUALITY == 5 && items[id].LEVEL == 10) return false;

      return true;
    }



    // TODO: update item stats functions

   function updateItemsStats(uint[5] memory itemIds, uint battleId, uint battleResult) public {
      uint zero = 0;
      uint[5] memory existedItems = [zero, zero, zero, zero, zero];
      uint itemIndexesAmount = zero;

      for (uint i=zero; i<itemIds.length; i++) {
          // Check if Exp can be increased
          if (isUpgradableItem(itemIds[i])) {

            existedItems[itemIndexesAmount] = itemIds[i];
            itemIndexesAmount++;
          }
      }

      // No Upgradable Items
      if (itemIndexesAmount == zero) {
        return;
      }

      // uint seed = block.number + randomFromAddress(msg.sender) + getBalance();
      
      bytes32 _signature = '0x'; // !!! FOR TEST PURPOSES ONLY
      uint _nonce = 1; // !!! FOR TEST PURPOSES ONLY

      bytes32 bytesHash = dataHash(_signature, _nonce);
      uint randomIndex = random(bytesHash, _nonce);
      randomIndex--; // It always starts from 1. While arrays start from 0

      uint id = existedItems[randomIndex];


      // Increase XP that represents on how many battles the Item was involved into

// !!! TODO: maybe introduce battle system in the separate smart contract

      // if (battleResult == ATTACKER_WON)
      //   items[id].XP = items[id].XP + 2;
      // else
      //   items[id].XP = items[id].XP + 1;


      // Increase Level
      if (
                items[id].LEVEL == 0 && items[id].XP >= 2 ||
                items[id].LEVEL == 1 && items[id].XP >= 6 ||
                items[id].LEVEL == 2 && items[id].XP >= 20 ||
                items[id].LEVEL == 3 && items[id].XP >= 48 ||
                items[id].LEVEL == 4 && items[id].XP >= 92 ||
                items[id].LEVEL == 5 && items[id].XP >= 152 ||
                items[id].LEVEL == 6 && items[id].XP >= 228 ||
                items[id].LEVEL == 7 && items[id].XP >= 318 ||
                items[id].LEVEL == 8 && items[id].XP >= 434 ||
                items[id].LEVEL == 9 && items[id].XP >= 580
      ) {
        items[id].LEVEL = items[id].LEVEL + 1;
        items[id].STAT_VALUE = items[id].STAT_VALUE + 1;
        // return "Item level is increased by 1";
      }

      updated_items[battleId] = id;
    }


/**
* @dev MarketItem struct and methods
*/

    struct MarketItemData{

            uint Price; // Fixed Price of Item defined by Item owner
            uint Duration; // 8, 12, 24 hours
            uint CreatedTime; // Unix timestamp in seconds
            uint City; // City ID (item can be added onto the market only through cities.)
            address payable Seller; // Wallet Address of Item owner
    }





/**
* @dev City struct and methods
*/

    struct City{

        uint ID; // city ID
        uint Hero;  // id of the hero owner
        uint Size; // BIG, MEDIUM, SMALL
        uint CofferSize; // size of the city coffer
        uint CreatedBlock;
        uint MarketCap;
        uint MarketAmount;
    }

/**
* @dev Stronghold struct and methods
*/

    struct Stronghold{
        uint ID;           // Stronghold ID
        uint Hero;         // Hero ID, that occupies Stronghold on map
        uint CreatedBlock; // The Blockchain Height

    }

/**
* @dev BattleLog struct and methods
*/

    struct BattleLog{

        uint[2] BattleResultType; // BattleResultType[0]: 0 - Attacker WON, 1 - Attacker Lose ; BattleResultType[1]: 0 - City, 1 - Stronghold, 2 - Bandit Camp
        uint Attacker;
        uint[2] AttackerTroops;       // Attacker's troops amount that were involved in the battle & remained troops
        uint[5] AttackerItems;        // Item IDs that were equipped by Attacker during battle.
        uint DefenderObject;   // City|Stronghold|NPC ID based on battle type
        uint Defender;         // City Owner ID|Stronghold Owner ID or NPC ID
        uint[2] DefenderTroops;
        uint[5] DefenderItems;
        uint Time;             // Unix Timestamp in seconds. Time, when battle happened
        }

/**
* @dev DropData struct and methods
*/

    struct DropData{       // Information of Item that player can get as a reward.
        uint Block;        // Blockchain Height, in which player got Item as a reward
        uint StrongholdId; // Stronghold on the map, for which player got Item
        uint ItemId;       // Item id that was given as a reward
        uint HeroId;
        uint PreviousBlock;
    }


}