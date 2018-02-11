pragma solidity ^0.4.19;

contract CryptoQuest {
    
    address public owner;

    mapping(uint => address) ownerByTokenId;
    mapping(uint => Character) characterByTokenId;
    mapping(uint => Item) itemsByTokenId;
    uint lastTokenId;
    
    mapping(address => uint[]) charactersByAddress;
    mapping(address => uint[]) itemsByAddress;
    
    Dungeon[] dungeons;

    uint8[] randomNumbers;
    uint lastRandonNumberIndex;
    
    uint private characterBasePrice;

    uint8 ITEM_SLOT_HEAD = 0;
    uint8 ITEM_SLOT_NECK = 1;
    uint8 ITEM_SLOT_BODY = 2;
    uint8 ITEM_SLOT_FEET = 3;
    uint8 ITEM_SLOT_LEFT_HAND = 4;
    uint8 ITEM_SLOT_RIGHT_HAND = 5;

    uint8 CHARACTER_TYPE_HUMAN = 0;
    uint8 CHARACTER_TYPE_ORC = 1;
    uint8 CHARACTER_TYPE_ELF = 2;
    uint8 CHARACTER_TYPE_CAT = 3;
    uint8 CHARACTER_TYPE_PANDA = 4;


    struct Character {
        uint256 tokenId;

        // attributes of the character
        uint8 characterType;
        uint8 level;
        uint8 health;
        uint8 strength;
        uint8 dexterity;
        uint8 intelligence;
        uint8 wisdom;
        uint8 charisma;

        // items the Character is wearing
        uint[6] items;
    }

    struct Item {
      uint256 tokenId;

      uint8 slot;
      string description;
      string name;
      uint8 armor;
      uint8 damage;
      uint8 attackSpeed;
      uint8 evasion;
      uint8 blockChance;
    }

    Item[] private startItems;

    struct Dungeon {
      uint8 dungeonId;

      string description;

      uint8 damage;
      uint8 health;
    }

    function CryptoQuest() public {
        owner = msg.sender;
        lastTokenId = 1;

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_RIGHT_HAND,
                name: "Dagger of doom",
                description : "",
                armor : 0,
                damage: 9,
                attackSpeed: 5,
                evasion : 2,
                blockChance : 1
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_RIGHT_HAND,
                name: "sword",
                description : "",
                armor : 3,
                damage: 10,
                attackSpeed: 2,
                evasion : 0,
                blockChance : 4
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_RIGHT_HAND,
                name: "boomerang",
                description : "",
                armor : 0,
                damage: 1,
                attackSpeed: 5,
                evasion : 0,
                blockChance : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_FEET,
                name: "basic boots",
                description : "",
                armor : 6,
                damage: 0,
                attackSpeed: 0,
                evasion : 3,
                blockChance : 1
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_FEET,
                name: "basic boots",
                description : "",
                armor : 6,
                damage: 0,
                attackSpeed: 0,
                evasion : 3,
                blockChance : 1
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_BODY,
                name: "basic chest armor",
                description : "",
                armor : 3,
                damage: 0,
                attackSpeed: 0,
                evasion : 1,
                blockChance : 0
            }));
    }


    function equip(uint characterId, uint headItem, uint rightHandItem) public {
        require(msg.sender == ownerByTokenId[characterId]);
        require(msg.sender == ownerByTokenId[headItem]);
        require(msg.sender == ownerByTokenId[rightHandItem]);

        Character storage character = characterByTokenId[characterId];
        character.items[ITEM_SLOT_HEAD] = headItem;
        character.items[ITEM_SLOT_RIGHT_HAND] = rightHandItem;
    }

    function goIntoDungeon(uint characterId, uint headItem, uint rightHandItem) public {
        equip(characterId, headItem, rightHandItem);
        require(msg.sender == ownerByTokenId[characterId]);

        // is this actually a Character

        Character memory character = characterByTokenId[characterId];

        Item[] memory items = loadItems(character);

        // throw the dice

        if (true) {
            Item newItem;
            //newItem.tokenId = lastTokenId++;
            //ownerByTokenId[newItem.tokenId] = msg.sender;
            //itemsByTokenId[newItem.tokenId] = newItem;
            // newItem.type = ...;
        } else {
            // choose an item and destroy it
            Item memory item = items[0];
            //uint tokenId = item.tokenId;

            // remove from Character
            // remove from owners
        }

    }

    function loadItems(Character character) private view returns (Item[]) {
        require(character.items.length < 256);
        Item[] memory items;
        for (uint8 i = 0; i < character.items.length; i++) {
            items[i] = itemsByTokenId[character.items[i]];
        }
        return items;
    }

    modifier admin() {
        require(msg.sender == owner);
        _;
    }


    function generateRandomItem() public payable {
      require(msg.value >= characterBasePrice);


    }


    function generateItem(uint8 slot,
                              string descripton,
                              uint8 armor,
                              uint8 damage,
                              uint8 attackSpeed,
                              uint8 evasion,
    						  uint8 blockChance) public admin {
            generateItemForOwner(slot, descripton, armor, damage, attackSpeed, evasion, blockChance, owner);
        }

    function generateItemForOwner(uint8 slot,
                          string descripton,
                          uint8 armor,
                          uint8 damage,
                          uint8 attackSpeed,
                          uint8 evasion,
						  uint8 blockChance,
						  address newOwner) private {
        Item memory item;
        item.tokenId = lastTokenId++;
        // set item data
		item.slot = slot;
		item.description = descripton;
		item.armor = armor;
		item.damage = damage;
		item.attackSpeed = attackSpeed;
		item.evasion = evasion;
		item.blockChance = blockChance;
        
        ownerByTokenId[item.tokenId] = newOwner;
        itemsByTokenId[item.tokenId] = item;
        itemsByAddress[newOwner].push(item.tokenId);
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
    
    function generateRandomCharacter(uint8 characterType) public payable {
      require(msg.value >= characterBasePrice);
      require(characterType <= CHARACTER_TYPE_PANDA);

      generateCharacterForOwner(
          getRandomAttribute(),
          getRandomAttribute(),
          getRandomAttribute(),
          getRandomAttribute(),
          getRandomAttribute(),
          getRandomAttribute(),
          /* level */ 1,
          characterType,
          msg.sender);
    }

    function getRandomAttribute() private returns (uint8) {
        return 5; //+ getNextRandomNumber() % 21;
    }

    function getNextRandomNumber() private returns (uint8) {
        if (lastRandonNumberIndex + 1 >= randomNumbers.length) {
            lastRandonNumberIndex = 0;
        } else {
            lastRandonNumberIndex++;
        }
        return randomNumbers[lastRandonNumberIndex];
    }

    function generateCharacter(uint8 health,
                               uint8 strength,
                               uint8 dexterity,
                               uint8 intelligence,
                               uint8 wisdom,
                               uint8 charisma,
							   uint8 level,
							   uint8 characterType) public admin {
        generateCharacterForOwner(health, strength, dexterity, intelligence, wisdom, charisma, level, characterType, owner);
    }

    function generateCharacterForOwner(uint8 health,
                               uint8 strength,
                               uint8 dexterity,
                               uint8 intelligence,
                               uint8 wisdom,
                               uint8 charisma,
							   uint8 level,
							   uint8 characterType,
							   address newOwner) private {

        Character memory character;

        character.health = health;
        character.strength = strength;
        character.dexterity = dexterity;
        character.intelligence = intelligence;
        character.wisdom = wisdom;
        character.charisma = charisma;
        character.level = level;
        character.tokenId = lastTokenId++;


        ownerByTokenId[character.tokenId] = newOwner;
        characterByTokenId[character.tokenId] = character;
        charactersByAddress[newOwner].push(character.tokenId);



    }
    
    function getTotalItemsForSale() public view returns (uint) {
        return getTotalItemsForOwner(owner);
    }
    
    function getTotalCharactersForSale() public view returns (uint) {
        return getTotalCharactersForOwner(owner);
    }
    
    function getItemsForSale(uint from, uint to) public view returns (Item[]) {
        return getItems(from, to, owner);
    }
    
    function getCharactersForSale(uint from, uint to) public view returns (Character[]) {
        return getCharacters(from, to, owner);
    }
    
    
    function getMyTotalCharacterCount() public view returns (uint) {
        return getTotalCharactersForOwner(msg.sender);
    }
    
    function getMyTotalItemCount() public view returns (uint) {
        return getTotalItemsForOwner(msg.sender);
    }
    
    function getMyCharacters(uint from, uint to) public view returns (Character[]){
        return getCharacters(from, to, msg.sender);
    }
    
    function getMyItems(uint from, uint to) public view returns (Item[]){
        return getItems(from, to, msg.sender);
    }
    
    
    function getTotalItemsForOwner(address owningAddress) private view returns (uint) {
        return itemsByAddress[owningAddress].length;
    }
    
    function getTotalCharactersForOwner(address owningAddress) private view returns (uint) {
        return charactersByAddress[owningAddress].length;
    }
    
    function getItems(uint from, uint to, address owningAddress) private view returns (Item[]) {
        uint[] memory itemIds = itemsByAddress[owningAddress];
        require(from < to);
        require(to <= itemIds.length);
        
        Item[] memory items;
        for (uint i = 0; i < to- from; i++) {
            uint tokenId = itemIds[i + from];
            items[i] = itemsByTokenId[tokenId];
        }
        
        return items;
    }
    
    function getCharacters(uint from, uint to, address owningAddress) private view returns (Character[]) {
        uint[] memory characterIds = charactersByAddress[owningAddress];
        require(from < to);
        require(to <= characterIds.length);
        
        Character[] memory characters;
        
        for (uint i = 0; i < to- from; i++) {
            uint tokenId = characterIds[i + from];
            characters[i] = characterByTokenId[tokenId];
        }
        
        return characters;
    }
    
    function buyItem(uint itemId) public payable {
        // is the item for sale?
        require(ownerByTokenId[itemId] == owner);
        
        // validate money here (e.g. enough)
        
        transferItem(owner, msg.sender, itemId);
    }
    
    
    
    function transferItem(address from, address to, uint itemId) private {
        require(ownerByTokenId[itemId] == from);
        
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
    
    function transferCharacter(address from, address to, uint characterId) private {
        require(ownerByTokenId[characterId] == from);
        
        ownerByTokenId[characterId] = to;
        charactersByAddress[to].push(characterId);
        
        uint[] memory tokenIds = charactersByAddress[from];
        uint index = findValueInArray(tokenIds, characterId);
        
        uint[] memory newTokenIds = removeFromArray(tokenIds, index);
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
        for (uint i = 0; i <array.length; i++){
            if (array[i] == value) {
                return i;
            }
        }
        require(false);
    }

    function getCharacterIdsByAddress(address a) public admin returns (uint[]){
      return charactersByAddress[a];
    }

    function getCharacter(uint characterId) public view returns (uint[15]) {
                      Character memory c = characterByTokenId[characterId];
                      uint[15] memory array;
                      array[0] = c.tokenId;
                      array[1] = c.characterType;


                      array[2] = c.level;
                      array[3] = c.health;
                      array[4] = c.strength;
                      array[5] = c.dexterity;
                      array[6] = c.intelligence;
                      array[7] = c.wisdom;
                      array[8] = c.charisma;

                      array[9] = c.items[0];
                      array[10] = c.items[1];
                      array[11] = c.items[2];
                      array[12] = c.items[3];
                      array[13] = c.items[4];
                      array[14] = c.items[5];

                      return array;
                }


        function strConcat(string first, string second) private returns (string) {
              bytes memory bytesFirst = bytes(first);
              bytes memory bytesSecond = bytes(second);

              string memory tempString = new string(bytesFirst.length + bytesSecond.length);
              bytes memory array = bytes(tempString);
              uint j = 0;
              for (uint i = 0; i < bytesFirst.length; i++) {
                array[j++] = bytesFirst[i];
              }

              for (i = 0; i < bytesSecond.length; i++) {
                  array[j++] = bytesSecond[i];
              }

              return string(array);
          }

          function uintToString(uint v) constant returns (string str) {
                                          if (v == 0) {
                                            return "0";
                                          }

                                          string memory result;

                                          while(v != 0) {
                                              uint remainder = v % 10;
                                              v = v / 10;
                                              bytes[] memory b;
                                              if (v == 0) {
                                                  result = strConcat(result, "0");
                                              } else if (v == 1) {
                                                  result = strConcat(result, "1");

                                              } else if (v == 2) {
                                                  result = strConcat(result, "2");

                                              } else if (v == 3) {
                                                  result = strConcat(result, "3");

                                              } else if (v == 4) {
                                                  result = strConcat(result, "4");

                                              } else if (v == 5) {
                                                  result = strConcat(result, "5");

                                              } else if (v == 6) {
                                                  result = strConcat(result, "6");

                                              } else if (v == 7) {
                                                  result = strConcat(result, "7");

                                              }else if (v == 8) {
                                                  result = strConcat(result, "8");

                                              }else if (v == 9) {
                                                  result = strConcat(result, "9");

                                              }


                                          }
                                          return result;

                                         }
}