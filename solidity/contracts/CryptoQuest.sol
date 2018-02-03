pragma solidity ^0.4.0;

contract CryptoQuest {

    address owner;

    mapping(uint => address) ownerByTokenId;
    mapping(uint => Character) characterByTokenId;
    mapping(uint => Item) itemsByTokenId;
    uint lastTokenId;

    mapping(address => uint[]) charactersByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;
    mapping(address => uint[]) itemsByAddress;


    uint8 ITEM_SLOT_HEAD = 0;
    uint8 ITEM_SLOT_RIGHT_HAND = 1;
    struct Character {
        uint256 tokenId;

        // items the Character is wearing
        uint[2] items;

        // attributes of the character
        uint8 health;
        uint8 strength;
    }

    struct Item {
      uint256 tokenId;
      // attributes of the item

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

    function generateItem(/*itemdata*/) public admin {
        Item memory item;
        item.tokenId = lastTokenId++;
        // set item data

        ownerByTokenId[item.tokenId] = owner;
        itemsByTokenId[item.tokenId] = item;
        itemsByAddress[owner].push(item.tokenId);
    }

    function generateCharacter(uint8 health, uint8 strength) public admin {
        Character memory character;
        character.tokenId = lastTokenId++;
        character.strength = strength;
        character.health = health;

        ownerByTokenId[character.tokenId] = owner;
        characterByTokenId[character.tokenId] = character;
        charactersByAddress[owner].push(character.tokenId);
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
