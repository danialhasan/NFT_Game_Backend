// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Imports
// NFT contract to inherit from. This is the battle-tested contract to reliably mint ERC721 tokens.
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

// openzeppelin helper functions
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

import 'hardhat/console.sol';

contract Game {
  // These are the attributes our characters will have.
  struct CharacterAttributes {
    uint256 characterIndex;
    string name;
    string imageURI;
    uint256 hp;
    uint256 maxHp;
    uint256 attackDamage;
  }
  // This is an array of characters. Each character has the structure found in CharacterAttributes.
  CharacterAttributes[] defaultCharacters;

  // These are default attributes. We pass this into the contract during deployment.
  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint256[] memory characterMaxHp,
    uint256[] memory characterAttackDamage
  ) {
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
  }
}
