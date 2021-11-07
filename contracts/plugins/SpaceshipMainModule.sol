// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./ModuleBaseTemplate.sol";

// TODO: Should this be ERC721?
// This is an example of a main spaceship contract. It inherits the base base template contract, which
// every module created needs to inherit to contain all the values
contract SpaceshipModule is ModuleBaseTemplate {
  bytes32[] messages;

  constructor(address _gameCore) ModuleBaseTemplate(_gameCore) {}

  // An example function. It would be interesting to leave a message on someone's spaceship
  function leaveMessage(bytes32 _messages) public {
    messages.push(_messages);
  }
}
