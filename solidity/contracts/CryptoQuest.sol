pragma solidity ^0.4.20;

contract CryptoQuest {

    address public owner;

    mapping(uint => address) ownerByTokenId;
    mapping(uint => Character) characterByTokenId;
    mapping(uint => Item) itemsByTokenId;
    uint lastTokenId;

    mapping(address => uint[]) charactersByAddress;
    mapping(address => uint[]) itemsByAddress;

    Dungeon[] dungeons;

    uint8[] randomNumbers = [0,0,0,0];
    uint lastRandonNumberIndex;

    uint private characterBasePrice;
    uint private itemBasePrice;

    uint8 ITEM_SLOT_HEAD = 0;
    uint8 ITEM_SLOT_NECK = 1;
    uint8 ITEM_SLOT_BODY = 2;
    uint8 ITEM_SLOT_FEET = 3;
    uint8 ITEM_SLOT_LEFT_HAND = 4;
    uint8 ITEM_SLOT_RIGHT_HAND = 5;

    //character types
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
        string name;
        string description;

        //change to equippedCharacterId
        uint onCharacterId;

        uint256 tokenId;
        uint8 slot;
        uint8 armor;
        uint8 damage;
        uint8 attackSpeed;
        uint8 evasion;
        uint8 blockChance;
    }

    Item[] private startItems;

    struct Dungeon {
        uint8 dungeonId;
        // Should description live in the contract or be a
        // const outside of the contract
        string description;

        uint8 damage;
        uint8 health;
    }

    function CryptoQuest() public {
        owner = msg.sender;

        //is this why we were having the zero mapping error? @dankurka
        lastTokenId = 1;


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
                damage: 9,
                attackSpeed: 5,
                evasion : 2,
                blockChance : 1,
                onCharacterId : 0
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
                blockChance : 4,
                onCharacterId : 0
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
                blockChance : 0,
                onCharacterId : 0
            }));

        startItems.push(
            Item({
                tokenId: 0,
                slot: ITEM_SLOT_FEET,
                name: "nice boots",
                description : "",
                armor : 7,
                damage: 0,
                attackSpeed: 0,
                evasion : 3,
                blockChance : 1,
                onCharacterId : 0
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
                blockChance : 1,
                onCharacterId : 0
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
                blockChance : 0,
                onCharacterId : 0
            }));
            //also create a startDungeons init
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

    // //pass the whole item array to this just like equip, uint[6] itemIds
    // function goIntoDungeon(uint characterId, uint headItem, uint rightHandItem) public {
    //     //equip(characterId, headItem, rightHandItem);
    //     require(msg.sender == ownerByTokenId[characterId]);

    //     // is this actually a Character

    //     Character memory character = characterByTokenId[characterId];

    //     Item[] memory items = loadItems(character);

    //     // throw the dice

    //     if (true) {
    //         Item newItem;
    //         //newItem.tokenId = lastTokenId++;
    //         //ownerByTokenId[newItem.tokenId] = msg.sender;
    //         //itemsByTokenId[newItem.tokenId] = newItem;
    //         // newItem.type = ...;
    //     } else {
    //         // choose an item and destroy it
    //         Item memory item = items[0];
    //         //uint tokenId = item.tokenId;

    //         // remove from Character
    //         // remove from owners
    //     }

    // }


    function goIntoDungeonV2(uint8 characterId, uint[6] itemIds, uint dungeonId) public payable {

        require(msg.sender == ownerByTokenId[characterId]);

        //get char
        Character memory character = characterByTokenId[characterId];

        //get totals
        uint8 totalArmor = 0;
        uint8 totalDamage = 0;

        for (uint8 i = 0; i < itemIds.length; i++) {
           uint itemId = itemIds[i];
           if (itemId == 0) {
             continue;
           }
           require (ownerByTokenId[itemId] == msg.sender);
           Item memory item = itemsByTokenId[itemId];
           totalArmor += item.armor;
           totalDamage += item.damage;
        }

       //get dungeon
       //dungeons[dungeonId]
       //check if damage and armor are greater

        Dungeon memory dungeon = Dungeon({
            dungeonId: 34,
            description : "",
            damage: 2,
            health : 2
        });

        if (totalArmor > dungeon.health && totalDamage > dungeon.damage) {
            generateRandomItem();
        } else {
            // choose an item and destroy it
            for ( i = 0; i < itemIds.length; i++) {
                itemId = itemIds[i];
                if (itemId == 0) {
                    continue;
                }

                transferItem(msg.sender, owner, itemId);
                break; //break so we only transfer one item
            }
            //uint tokenId = item.tokenId;
        }

    }
    // kill this?
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
      require(msg.value >= itemBasePrice);

      Item memory item = startItems[getNextRandomNumber() % startItems.length];
      item.tokenId = lastTokenId++;

      item.armor = item.armor + getNextRandomNumber() % 3;
      item.damage = item.damage + getNextRandomNumber() % 5;
      item.attackSpeed = item.attackSpeed + getNextRandomNumber() % 3;
      item.evasion = item.evasion + getNextRandomNumber() % 3;
      item.blockChance = item.blockChance + getNextRandomNumber() % 3;

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
        for (uint i = 0; i < to-from; i++) {
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

        for (uint i = 0; i < to-from; i++) {
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

    function getCharacter(uint characterId) public view returns (uint[15]) {

        Character memory c = characterByTokenId[characterId];
        require(c.tokenId != 0);
        // Why do we need to do things like this as an array?
        // Are we sure there isn't a better way?
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

    function getItem(uint itemId) public view returns (uint[7], string, string) {
        Item memory i = itemsByTokenId[itemId];
        require(i.tokenId != 0);
        uint[7] memory array;
        array[0] = i.tokenId;
        array[1] = i.slot;
        array[2] = i.armor;
        array[3] = i.damage;
        array[4] = i.attackSpeed;
        array[5] = i.evasion;
        array[6] = i.blockChance;

        return (array, i.name, i.description);
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
    }
}
