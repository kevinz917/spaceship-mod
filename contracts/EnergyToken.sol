// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Should energy be a ERC20 token to begin with? How is energy harnesssed?

// Energy is a ERC20 Token
// TODO: How can we restrict this such that it's not a paid to win game?
contract Energy is ERC20 {
  bool locked;

  constructor(
    string memory name,
    string memory symbol,
    uint256 supply
  ) ERC20(name, symbol) {
    _mint(msg.sender, supply);
    locked = true;
  }

  // TODO: Should
}
