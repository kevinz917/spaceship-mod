//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "./ModuleBaseTemplate.sol";

// TODO: Should this be ERC721?
// This is an example of a main spaceship contract. It inherits the base base template contract, which
// every module created needs to inherit to contain all the values
contract SpaceshipModule is ModuleBaseTemplate {
  bytes32[] messages;
  address baseTemplate;

  constructor(address _gameStorage) ModuleBaseTemplate(_gameStorage) {}

  // An example function. It would be interesting to leave a message on someone's spaceship
  function leaveMessage(bytes32 _messages) public {
    messages.push(_messages);
  }
}
