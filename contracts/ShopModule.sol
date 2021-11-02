//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/ShipModule.sol";

contract ShopModule is Ownable, Module {
  uint256 public scrapMetal;
  string public moduleType;

  constructor() {
    moduleType = "shop";
  }

  // IF YOU STAKE ON MY SHOP MODULE YOU'RE EFFECTIVELY YIELD FARMINGGGGGGG LFGGG

  // Add
}
