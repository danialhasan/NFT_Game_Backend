// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Imports
// NFT contract to inherit from. This is the battle-tested contract to reliably mint ERC721 tokens.
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

// openzeppelin helper functions
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

// import Base64 helper functions from contract
import './libraries/Base64.sol';

import 'hardhat/console.sol';

contract Game is ERC721 {
  // These are the attributes our characters will have.
  struct CharacterAttributes {
    uint256 characterIndex;
    string name;
    string imageURI;
    uint256 hp;
    uint256 maxHp;
    uint256 attackDamage;
  }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds; // Counter variable

  // This is an array of characters. Each character has the structure found in CharacterAttributes.
  CharacterAttributes[] defaultCharacters;

  // What does all this mapping shit mean?
  // Map nft's tokenId to its attributes.
  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
  // Map address to NFTs tokenId. This way we can store the owner of the NFT and reference it later.
  mapping(address => uint256) public nftHolders;

  // These are default attributes. We pass this into the contract during deployment.
  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint256[] memory characterMaxHp,
    uint256[] memory characterAttackDamage
  ) ERC721('Heros', 'HERO') {
    console.log('Contract deployed.');

    // We'll iterate through this to generate some default characters.
    for (uint256 i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(
        CharacterAttributes({
          characterIndex: i,
          name: characterNames[i],
          maxHp: characterMaxHp[i],
          hp: characterMaxHp[i],
          attackDamage: characterAttackDamage[i],
          imageURI: characterImageURIs[i]
        })
      );

      CharacterAttributes memory character = defaultCharacters[i];
      console.log(
        'Initialized %s with %s HP, with image %s',
        character.name,
        character.maxHp,
        character.imageURI
      );
    }
    // Increment tokenId in the constructor, so that the first NFT has an id of 1.
    _tokenIds.increment();
  }

  // this function formats the character attributes of the tokenId given into JSON-formatted base-64.
  function tokenURI(uint256 _tokenId)
    public
    view
    override
    returns (string memory)
  {
    CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

    string memory strHp = Strings.toString(charAttributes.hp);
    string memory strMaxHp = Strings.toString(charAttributes.maxHp);
    string memory strAttackDamage = Strings.toString(
      charAttributes.attackDamage
    );

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',
            strHp,
            ', "max_value":',
            strMaxHp,
            '}, { "trait_type": "Attack Damage", "value": ',
            strAttackDamage,
            '} ]}'
          )
        )
      )
    );

    string memory output = string(
      abi.encodePacked('data:application/json;base64,', json)
    );

    return output;
  }

  // What does 'external' mean?
  function mintCharacterNFT(uint256 _characterIndex) external {
    // Get current token ID
    uint256 newItemId = _tokenIds.current();

    // Map the tokenID to their character attributes.
    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      maxHp: defaultCharacters[_characterIndex].maxHp,
      hp: defaultCharacters[_characterIndex].hp,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      attackDamage: defaultCharacters[_characterIndex].attackDamage
    });

    console.log(
      'Minted NFT with tokenId %s and characterIndex %s',
      newItemId,
      _characterIndex
    );
    // _setTokenURI(newItemId, nftHolderAttributes(newItemId));
    // safely mint NFT using OpenZeppelin provided function (assign token ID to callers wallet address)
    _safeMint(msg.sender, newItemId);
    // Keep an easy way to see who owns what NFT.
    nftHolders[msg.sender] = newItemId;

    // increment tokenId for next person's NFT
    _tokenIds.increment();
  }
}
