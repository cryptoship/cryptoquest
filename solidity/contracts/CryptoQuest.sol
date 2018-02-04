pragma solidity ^0.4.0;

contract CryptoQuest {
    
    address public owner;

    mapping(uint => address) ownerByTokenId;
    mapping(uint => Character) characterByTokenId;
    mapping(uint => Item) itemsByTokenId;
    uint lastTokenId;
    
    mapping(address => uint[]) charactersByAddress;
    mapping(address => uint[]) itemsByAddress;
    
    Dungeon[] dungeons;
    
    uint[] randomNumbers;
    uint lastRandonNumberIndex;
    
    uint private characterBasePrice;

    uint8 ITEM_SLOT_HEAD = 0;
    uint8 ITEM_SLOT_NECK = 1;
    uint8 ITEM_SLOT_BODY = 2;
    uint8 ITEM_SLOT_FEET = 3;
    uint8 ITEM_SLOT_LEFT_HAND = 4;
    uint8 ITEM_SLOT_RIGHT_HAND = 5;
	
    struct Character {
        uint256 tokenId;
        
        // items the Character is wearing
        uint[6] items;
        
        // attributes of the character
        uint8 level;
        uint8 health;
        uint8 strength;
        uint8 dexterity;
        uint8 intelligence;
        uint8 wisdom;
        uint8 charisma;		
    }

    struct Item {
      uint256 tokenId;

      uint8 slot;
      string description;
      uint8 armor;
      uint8 damage;
      uint8 attackSpeed;
      uint8 evasion;
      uint8 blockChance;
    }

    struct Dungeon {
      uint8 dungeonId;

      string description;

      uint8 damage;
      uint8 health;
    }
    
    function CryptoQuest() public {
        owner = msg.sender;
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

    function generateItem(uint8 slot,
                          string descripton,
                          uint8 armor,
                          uint8 damage,
                          uint8 attackSpeed,
                          uint8 evasion,
						  uint8 blockChance) public admin {
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
        
        ownerByTokenId[item.tokenId] = owner;
        itemsByTokenId[item.tokenId] = item;
        itemsByAddress[owner].push(item.tokenId);
    }
    
    function setCharacterBasePrice(uint basePrice) public admin {
      characterBasePrice = basePrice;
    }
    
    function getCharacterBasePrice() public admin returns (uint) {
      return characterBasePrice;
    }
    
    function setRandomNumbers(uint[] numbers) public admin {
      randomNumbers = numbers;
      lastRandonNumberIndex = 0;
    }
    
    function getRandomNumbers() public admin returns (uint[]) {
      return randomNumbers;
    }
    
    function generateRandomCharacter() public payable {
      require(msg.value >= characterBasePrice);
      
      
    }
    
    function generateCharacter(uint8 health,
                               uint8 strength,
                               uint8 dexterity,
                               uint8 intelligence,
                               uint8 wisdom,
                               uint8 charisma,
							   uint8 level) public admin {
		
        Character memory character;
        character.tokenId = lastTokenId++;
        ownerByTokenId[character.tokenId] = owner;
        characterByTokenId[character.tokenId] = character;
        charactersByAddress[owner].push(character.tokenId);
		
	    character.health = health;
        character.strength = strength;
		character.dexterity = dexterity;
		character.intelligence = intelligence;
		character.wisdom = wisdom;
		character.charisma = charisma;
		character.level = level;
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
}