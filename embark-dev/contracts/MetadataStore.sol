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

    function setBlocklordsAddress(address _blocklords) public onlyOwner {
        blocklords = _blocklords;
    }


/**
* @dev Hero struct and methods
*/

    struct Hero{
        address payable OWNER;     // Wallet address of Player that owns Hero
        uint LEADERSHIP;   // Leadership Stat value
        uint INTELLIGENCE; // Intelligence Stat value
        uint STRENGTH;     // Strength Stat value
        uint SPEED;        // Speed Stat value
        uint DEFENSE;      // Defense Stat value
        uint CREATED_TIME;
    }

    mapping (uint => Hero) heroes;
    mapping (address => uint) playerHeroes;

    function addHero(address payable _player,uint _id, uint[] memory _heroStats/*, uint[] _heroItems*/) public payable returns(bool) {
        require(msg.sender == blocklords,
            "Only blocklords contract can initiate this transaction");

        heroes[_id] = Hero(_player, _heroStats[0], _heroStats[1],  _heroStats[2], _heroStats[3], _heroStats[4], block.number);
        playerHeroes[_player] = _id;

        return true;
    }

    function getHero(uint id) public view returns(address, uint, uint, uint, uint, uint, uint){
        return (heroes[id].OWNER, heroes[id].LEADERSHIP, heroes[id].INTELLIGENCE, heroes[id].STRENGTH, heroes[id].SPEED, heroes[id].DEFENSE, heroes[id].CREATED_TIME);
    }

    function getPlayerHeroId(address heroOwner) public view returns(uint) {
      if (heroOwner != 0x0000000000000000000000000000000000000000)
        return playerHeroes[heroOwner];
      return playerHeroes[msg.sender];
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