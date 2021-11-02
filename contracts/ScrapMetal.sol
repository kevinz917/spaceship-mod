// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// ScrapMetal is a ERC20 Token
// TODO: How can we restrict this such that it's not a paid to win game?
contract ScrapMetal is ERC20 {
  constructor(
    string memory name,
    string memory symbol,
    uint256 supply
  ) ERC20(name, symbol) {
    _mint(msg.sender, supply);
  }
}
