//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/ShipModule.sol";

// TODO: Should this be ERC721?
// A spaceship is the base template for a game element.
// Spaceships can snap onto other game elements one owns
// for instance, every base template can own 1 shop.
contract SpaceshipModule is Ownable, Module {
  uint256 public scrapMetal;
  string public moduleType;

  constructor() {
    moduleType = "base";
  }

  event Receive(uint256 _amount, address _owner);
  event Emit(uint256 _amount, address _owner);

  // receives a ERC-20 token representing "scrap metal" - inspired by FTL. Scrap metal can be
  // TODO: Turn this into staking rather than other things.
  function receiveResource(uint256 _amount) public override {
    scrapMetal += _amount;

    emit Receive(_amount, address(this));
  }

  // send resource to other module of the ship. Ships have to re-balance resource between sub-modules of the ship.
  function sendResource(uint256 _amount) public override {
    require(scrapMetal >= _amount, "Not enough resources");
    scrapMetal -= _amount;

    emit Emit(_amount, address(this));
  }

  // withdraw all underlying ERC20 tokens
  function withdrawAll() public {}
}
