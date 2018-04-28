pragma solidity ^0.4.21;

contract CryptoQuest {

    address public owner;

    mapping(uint => address) ownerByTokenId;
    mapping(uint => Character) characterByTokenId;
    mapping(uint => Item) itemsByTokenId;
    uint lastTokenId;

    mapping(address => uint[]) charactersByAddress; //give user address and get all char associated
    mapping(address => uint[]) itemsByAddress; //give user address and get all items associated

    uint[] itemsInMarketPlace;
    uint[] charactersInMarketPlace;

    Dungeon[] dungeons;

    uint8[] randomNumbers = [0,0,0,0];
    uint lastRandonNumberIndex;

    uint private characterBasePrice;
    uint private itemBasePrice;

    struct Character {
        uint256 tokenId;

        // attributes of the character
        uint8 characterType;
        uint8 level;
        uint8 health;
        uint8 damage;
        uint8 fireResistance;
        uint8 iceResistance;
        uint8 poisonResistance;
        // items the Character is wearing
        uint[6] items;
        string name;

        bool forSale;
        uint price;
        uint8 currentHealth;
        uint healthTime;
    }

    //item slots
    uint8 ITEM_SLOT_HEAD = 0;
    uint8 ITEM_SLOT_NECK = 1;
    uint8 ITEM_SLOT_BODY = 2;
    uint8 ITEM_SLOT_FEET = 3;
    uint8 ITEM_SLOT_LEFT_HAND = 4;
    uint8 ITEM_SLOT_RIGHT_HAND = 5;


    struct Item {
        string name;
        string description;

        //change to equippedCharacterId
        uint onCharacterId;

        uint256 tokenId;
        uint8 slot;
        uint8 armor;
        uint8 damage;
        uint8 fireResistance;
        uint8 iceResistance;
        uint8 poisonResistance;

        // market place
        bool forSale;
        uint256 price;
    }

    Item[] private startItems;

    struct Dungeon {
        uint8 dungeonId;
        string name;
        // Should description live in the contract or be a
        // const outside of the contract
        string description;
        uint8 fireAttack;
        uint8 iceAttack;
        uint8 poisonAttack;
        uint8 damage;
        uint8 health;
    }

    function CryptoQuest() public {
        owner = msg.sender;

        //is this why we were having the zero mapping error? @dankurka
        lastTokenId = 1;


        dungeons.push(
          Dungeon({
            name: "Fire Dungeon",
            dungeonId: 1,
            description: "easy",
            damage: 1,
            health: 1,
            fireAttack: 5,
            iceAttack: 0,
            poisonAttack: 0
        }));

        dungeons.push(
          Dungeon({
            name:"Ice Dungeon",
            dungeonId: 2,
            description: "medium",
            damage: 2,
            health: 2,
            fireAttack: 0,
            iceAttack:  4,
            poisonAttack: 0
        }));

        dungeons.push(
          Dungeon({
            dungeonId: 3,
            name:"Poison Dungeon",
            description: "hard",
            damage: 2,
            health: 3,
            fireAttack: 0,
            iceAttack:  0,
            poisonAttack: 5
            }));




        //shouldnt token ids be set by the lastTokenId prop?
        // We should use a function that ads an item and increments the
        // lastTokenId
        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_RIGHT_HAND,
                name: "Dagger of doom",
                description : "",
                armor : 0,
                damage: 4,
                fireResistance: 0,
                iceResistance : 0,
                poisonResistance : 0,
                onCharacterId : 0,
                forSale: false,
                price : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_RIGHT_HAND,
                name: "sword",
                description : "",
                armor : 3,
                damage: 0,
                fireResistance: 0,
                iceResistance : 0,
                poisonResistance : 0,
                onCharacterId : 0,
                forSale: false,
                price : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_RIGHT_HAND,
                name: "boomerang",
                description : "",
                armor : 0,
                damage: 2,
                fireResistance: 0,
                iceResistance : 0,
                poisonResistance : 0,
                onCharacterId : 0,
                forSale: false,
                price : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_FEET,
                name: "nice boots",
                description : "",
                armor : 7,
                damage : 1,
                fireResistance: 0,
                iceResistance : 0,
                poisonResistance : 0,
                onCharacterId : 0,
                forSale: false,
                price : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_FEET,
                name: "basic boots",
                description : "",
                armor : 6,
                damage : 0,
                fireResistance: 0,
                iceResistance : 0,
                poisonResistance : 0,
                onCharacterId : 0,
                forSale: false,
                price : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_BODY,
                name: "basic chest armor",
                description : "",
                armor : 3,
                damage : 0,
                fireResistance: 0,
                iceResistance : 0,
                poisonResistance : 0,
                onCharacterId : 0,
                forSale: false,
                price : 0
            }));
            //also create a startDungeons init
    }

    function sendItemToMarketPlace(uint256 itemId, uint256 price) public {
      require(msg.sender == ownerByTokenId[itemId]);
      Item item = itemsByTokenId[itemId];

      if (item.onCharacterId != 0) {
        Character character = characterByTokenId[item.onCharacterId];
        for (uint8 i = 0; i < character.items.length; i++) {
           if (character.items[i] == itemId) {
             item.onCharacterId = 0;
             character.items[i] = 0;
             characterByTokenId[item.onCharacterId] = character;
             break;
           }
        }
      }

      item.forSale = true;
      item.price = price;

      itemsInMarketPlace.push(itemId);
    }

    function removeItemFromMarketPlace(uint256 itemId) public {
      require(msg.sender == ownerByTokenId[itemId]);
      Item item = itemsByTokenId[itemId];
      item.forSale = false;
      uint index = findValueInArray(itemsInMarketPlace, itemId);
      itemsInMarketPlace = removeFromArray(itemsInMarketPlace, index);
    }

    function getItemsForSale() public returns (uint[])  {
      return itemsInMarketPlace;
    }

    function sendCharacterToMarketPlace(uint256 characterId, uint256 price) public {
      require(msg.sender == ownerByTokenId[characterId]);
      Character character = characterByTokenId[characterId];

      // remove items from char
      uint256[6] memory itemIds;
      equip(characterId, itemIds);

      character.forSale = true;
      character.price = price;

      charactersInMarketPlace.push(characterId);
    }

    function removeCharacterFromMarketPlace(uint256 characterId) public {
      require(msg.sender == ownerByTokenId[characterId]);
      Character character = characterByTokenId[characterId];
      character.forSale = false;
      characterByTokenId[characterId] = character;
      uint index = findValueInArray(charactersInMarketPlace, characterId);
      charactersInMarketPlace = removeFromArray(charactersInMarketPlace, index);
    }

    function getCharactersForSale() public returns (uint[])  {
      return charactersInMarketPlace;
    }

    //equip character with items
    function equip(uint characterId, uint[6] itemIds) public {
        require(msg.sender == ownerByTokenId[characterId]);

        //load char
        Character storage character = characterByTokenId[characterId];

        //get the items the character is currently wearing
        uint[6] memory oldItems = character.items;

        //remove all items
        for (uint8 i = 0; i < 6; i++) {
          character.items[i] = 0;
        }

        //update all old items to not be worn (onCharacterId = 0)
        for (i = 0; i < 6; i++) {
          uint oldItemId = oldItems[i];
          if (oldItemId == 0) {
            continue;
          }
          Item storage oldItem = itemsByTokenId[oldItemId];
          oldItem.onCharacterId = 0;
        }


        //check to see if they own item, then load item and set it on that item, go to item and link it to character
        for (i = 0; i < itemIds.length; i++) {
           uint itemId = itemIds[i];
           if (itemId == 0) {
             continue;
           }
           require (ownerByTokenId[itemId] == msg.sender);
           Item storage item = itemsByTokenId[itemId];
           item.onCharacterId = characterId;
           character.items[i] = itemId;
        }
    }

    function getItemSummary(uint[6] itemIds) private returns (ItemSummary) {
      uint armor = 0;
      uint damage = 0;
      uint fireResistance = 0;
      uint iceResistance = 0;
      uint poisonResistance = 0;
      for (uint8 i = 0; i < itemIds.length; i++) {
         uint itemId = itemIds[i];
         if (itemId == 0) {
           continue;
         }
         require (ownerByTokenId[itemId] == msg.sender);
         Item memory item = itemsByTokenId[itemId];
         armor += item.armor;
         damage += item.damage;
         fireResistance += item.fireResistance;
         iceResistance += item.iceResistance;
         poisonResistance += item.poisonResistance;
      }

      return ItemSummary({
          armor : armor,
          damage : damage,
          fireResistance : fireResistance,
          iceResistance : iceResistance,
          poisonResistance : poisonResistance
      });
    }


    struct ItemSummary {
      uint armor;
      uint damage;
      uint fireResistance;
      uint iceResistance;
      uint poisonResistance;
    }



    function calculateFightValues(uint8 characterId, uint[6] itemIds) private returns (CharacterFightValues) {
      ItemSummary memory itemSummary = getItemSummary(itemIds);
      Character memory character = characterByTokenId[characterId];

      uint totalCharacterDamage = character.damage + itemSummary.damage;
      uint totalFireResistance = character.fireResistance + itemSummary.armor + itemSummary.fireResistance;
      uint totalIceResistance = character.iceResistance + itemSummary.armor + itemSummary.iceResistance;
      uint totalPoisonResistance = character.poisonResistance + itemSummary.armor + itemSummary.poisonResistance;

      uint[3] memory totalResistanceByElement;
      totalResistanceByElement[0] = totalFireResistance;
      totalResistanceByElement[1] = totalIceResistance;
      totalResistanceByElement[2] = totalPoisonResistance;


      // replenish health
      uint newHealth = character.currentHealth + ((now - character.healthTime)/3600) * 10;
      uint totalHealth = newHealth > character.health ? character.health : newHealth;

      return CharacterFightValues({
        totalHealth : totalHealth,
        totalCharacterDamage : totalCharacterDamage,
        totalResistanceByElement : totalResistanceByElement
      });
    }

    function calculateDungeonFightValues(uint dungeonId) private returns (DungeonFightValues) {
      Dungeon memory dungeon = dungeons[dungeonId];
      uint[3] memory totalDamageByElement;
      totalDamageByElement[0] = dungeon.damage + dungeon.fireAttack;
      totalDamageByElement[1] = dungeon.damage + dungeon.iceAttack;
      totalDamageByElement[2] = dungeon.damage + dungeon.poisonAttack;

      return DungeonFightValues({
        totalHealth : dungeon.health,
        totalDamageByElement: totalDamageByElement
      });
    }

    struct CharacterFightValues {
      uint totalHealth;
      uint totalCharacterDamage;
      uint[3] totalResistanceByElement;
    }

    struct DungeonFightValues {
      uint totalHealth;
      uint[3] totalDamageByElement;
    }

    function selectAttack(Dungeon dungeon) private returns (uint8) {
      // TODO add random attack selection
      return 0;
    }

    function goIntoDungeon(uint8 characterId, uint[6] itemIds, uint dungeonId) public payable {
        require(msg.sender == ownerByTokenId[characterId]);
        equip(characterId, itemIds);
        //get char
        Character memory character = characterByTokenId[characterId];

        CharacterFightValues memory fightValues = calculateFightValues(characterId, itemIds);
        DungeonFightValues memory dungeonFightValues = calculateDungeonFightValues(dungeonId);
        Dungeon memory dungeon = dungeons[dungeonId];

       bool charLost = false;
       uint damageOutput = 0;

       while (true) {

          uint8 attackType = selectAttack(dungeon);
          uint dungeonDamage = dungeonFightValues.totalDamageByElement[attackType];
          uint resistance = fightValues.totalResistanceByElement[attackType];

          damageOutput = dungeonDamage  /*+randomDamage*/ - resistance;
          if (damageOutput > fightValues.totalHealth) {
            charLost = true;
            break;
          } else {
            fightValues.totalHealth = fightValues.totalHealth - damageOutput;
          }

          damageOutput = fightValues.totalCharacterDamage  /*+randomDamage*/;
          if (damageOutput > dungeonFightValues.totalHealth) {
            break;
          } else {
            dungeonFightValues.totalHealth = dungeonFightValues.totalHealth - damageOutput;
          }
       }


       character.currentHealth = uint8(fightValues.totalHealth);
       character.healthTime = now;
       calculateConsequences(charLost, character);
    }

    function calculateConsequences(bool charLost, Character c) private {


      uint256[6] memory itemIds = c.items;
      if (charLost) {
        // choose an item and destroy it
        // TODO(dankurka): if you have no item the character may die
        for (uint8 i = 0; i < itemIds.length; i++) {
            uint itemId = itemIds[i];
            if (itemId == 0) {
                continue;
            }

            transferItem(msg.sender, owner, itemId);
            break; //break so we only transfer one item
        }
      } else {
        doGenerateRandomItem();
      }
    }

    modifier admin() {
        require(msg.sender == owner);
        _;
    }

    function generateRandomItem() public payable {
      require(msg.value >= itemBasePrice);
      doGenerateRandomItem();
    }
    
    function getSemiRandomNumber() public returns (uint8){
        return uint8(keccak256(block.difficulty,now,gasleft()));
    }

    function doGenerateRandomItem() private {


      Item memory templateItem = startItems[getSemiRandomNumber() % startItems.length];
      Item memory item = Item ({
        tokenId: lastTokenId++,
        slot: templateItem.slot,
        name: templateItem.name,
        description : templateItem.description,
        armor : templateItem.armor + getSemiRandomNumber() % 3,
        damage: templateItem.damage + getSemiRandomNumber() % 5,
        fireResistance: templateItem.fireResistance + getSemiRandomNumber() % 3,
        iceResistance : templateItem.iceResistance + getSemiRandomNumber() % 3,
        poisonResistance : templateItem.poisonResistance + getSemiRandomNumber() % 3,
        onCharacterId : 0,
        forSale: false,
        price : 0
      });

      ownerByTokenId[item.tokenId] = msg.sender;
      itemsByTokenId[item.tokenId] = item;
      itemsByAddress[msg.sender].push(item.tokenId);
    }

    function setItemBasePrice(uint basePrice) public admin {
      itemBasePrice = basePrice;
    }

    function getItemBasePrice() public admin returns (uint) {
      return itemBasePrice;
    }

    function setCharacterBasePrice(uint basePrice) public admin {
      characterBasePrice = basePrice;
    }

    function getCharacterBasePrice() public admin returns (uint) {
      return characterBasePrice;
    }

    function setRandomNumbers(uint8[] numbers) public admin {
      randomNumbers = numbers;
      lastRandonNumberIndex = 0;
    }

    function getRandomNumbers() public admin returns (uint8[]) {
        return randomNumbers;
    }

    function generateCharacter(uint8 characterType, string name,
      uint8 health, uint8 damage, uint8 fireResistance, uint8 iceResistance,
      uint8 poisonResistance) public payable {
        require(msg.value >= characterBasePrice);

        uint256 totalAttributes = 0;
        totalAttributes = totalAttributes + health;
        totalAttributes = totalAttributes + damage;
        totalAttributes = totalAttributes + fireResistance;
        totalAttributes = totalAttributes + iceResistance;
        totalAttributes = totalAttributes + poisonResistance;

          require(totalAttributes <= 70);

        generateCharacterForOwner(
          health,
          damage,
          fireResistance,
          iceResistance,
          poisonResistance,
          /* level */ 1,
          characterType,
          name,
          msg.sender);
    }

    function generateRandomCharacter(uint8 characterType, string name) public payable {
        require(msg.value >= characterBasePrice);

        generateCharacterForOwner(
        getRandomAttribute(),
        getRandomAttribute(),
        getRandomAttribute(),
        getRandomAttribute(),
        getRandomAttribute(),
        /* level */ 1,
        characterType,
        name,
        msg.sender);
    }

    function getRandomAttribute() private returns (uint8) {
        return 5 + getNextRandomNumber() % 21;
    }

    function getNextRandomNumber() private returns (uint8) {
        if (lastRandonNumberIndex + 1 >= randomNumbers.length) {
            lastRandonNumberIndex = 0;
        } else {
            lastRandonNumberIndex++;
        }
        return randomNumbers[lastRandonNumberIndex];
    }

    function generateCharacterForOwner(uint8 health,
                                       uint8 damage,
                                        uint8 fireResistance,
                                        uint8 iceResistance,
                                        uint8 poisonResistance,
                                        uint8 level,
                                        uint8 characterType,
                                        string name,
                                        address newOwner) private {

        Character memory character;
        character.health = health;
        character.damage = damage;
        character.fireResistance = fireResistance;
        character.iceResistance = iceResistance;
        character.poisonResistance = poisonResistance;
        character.level = level;
        character.name = name;
        character.forSale = false;
        character.currentHealth = health;
        character.tokenId = lastTokenId++;


        ownerByTokenId[character.tokenId] = newOwner;
        characterByTokenId[character.tokenId] = character;
        charactersByAddress[newOwner].push(character.tokenId);
    }

    function buyItem(uint itemId) public payable {
        // is the item for sale?
        require(ownerByTokenId[itemId] == owner);

        // validate money here (e.g. enough)
        transferItem(owner, msg.sender, itemId);
    }

    function transferItem(address from, address to, uint itemId) private {
        require(ownerByTokenId[itemId] == from);
        require(from != to);

        ownerByTokenId[itemId] = to;
        itemsByAddress[to].push(itemId);

        uint[] memory tokenIds = itemsByAddress[from];
        uint index = findValueInArray(tokenIds, itemId);

        uint[] memory newTokenIds = removeFromArray(tokenIds, index);
        itemsByAddress[from] = newTokenIds;
    }

    function buyCharacter(uint characterId) public payable {
        // is the item for sale?
        require(ownerByTokenId[characterId] == owner);

        // validate money here (e.g. enough)

        transferCharacter(owner, msg.sender, characterId);
    }

    //transfers character from one address to another
    //@params the id of charater
    function transferCharacter(address from, address to, uint characterId) private {
        //check if owner of charater
        require(ownerByTokenId[characterId] == from);

        //change the owner to the to address
        ownerByTokenId[characterId] = to;

        //add this to the to's character array
        charactersByAddress[to].push(characterId);

        //get the array from owns
        uint[] memory tokenIds = charactersByAddress[from];

        //find that character's index
        uint index = findValueInArray(tokenIds, characterId);

        //get back an array after this index(character) has been removed
        uint[] memory newTokenIds = removeFromArray(tokenIds, index);

        //set the new array
        charactersByAddress[from] = newTokenIds;
    }

    function removeFromArray(uint[] array, uint index)  private pure returns(uint[]) {
        require(index < array.length);
        uint[] memory newArray;
        uint newIndex = 0;
        for (uint oldIndex = 0; oldIndex<array.length; oldIndex++){
            if (oldIndex == index) {
                continue;
            } else {
                newArray[newIndex] = array[oldIndex];
                newIndex++;
            }
        }
        return newArray;
    }

    function findValueInArray(uint[] array, uint value)  private pure returns(uint) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return i;
            }
        }
        require(false);
    }

    function getCharacterIdsByAddress(address a) public returns (uint[]){
      return charactersByAddress[a];
    }

    function getItemIdsByAddress(address a) public returns (uint[]){
      return itemsByAddress[a];
    }


    //i feel like this function should return a struct of the character
    function getCharacterDetails(uint characterId) public view returns (uint[18], string) {
        Character memory c = characterByTokenId[characterId];
        require(c.tokenId != 0);
        // Why do we need to do things like this as an array?
        // Are we sure there isn't a better way?
        uint[18] memory array;
        array[0] = c.tokenId;
        array[1] = c.characterType;

        array[2] = c.level;
        array[3] = c.health;
        array[4] = c.damage;
        array[5] = c.fireResistance;
        array[6] = c.iceResistance;
        array[7] = c.poisonResistance;
        array[8] = c.forSale ? 1 : 0;
        array[9] = c.price;
        array[10] = c.currentHealth;
        array[11] = c.healthTime;

        array[12] = c.items[0];
        array[13] = c.items[1];
        array[14] = c.items[2];
        array[15] = c.items[3];
        array[16] = c.items[4];
        array[17] = c.items[5];

        return (array, c.name);
    }

    function getItem(uint itemId) public view returns (uint[9], string, string) {
        Item memory i = itemsByTokenId[itemId];
        require(i.tokenId != 0);
        uint[9] memory array;
        array[0] = i.tokenId;
        array[1] = i.slot;
        array[2] = i.armor;
        array[3] = i.damage;
        array[4] = i.fireResistance;
        array[5] = i.iceResistance;
        array[6] = i.poisonResistance;
        array[7] = i.forSale ? 1 : 0;
        array[8] = i.price;

        return (array, i.name, i.description);
    }
}