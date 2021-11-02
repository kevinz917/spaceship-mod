//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/ShipModule.sol";

// TODO: Should this be ERC721?
// A spaceship is the base template for a game element.
// Spaceships can snap onto other game elements one owns
// for instance, every base template can own 1 shop.
contract SpaceshipModule is Ownable, Module {
  address public scrapMetalAddress; // ERC20 token of scrap metal
  mapping(uint256 => address) public modules;
  uint256 public moduleCount = 2;
  uint256 public cost;
  string public moduleType;

  event Receive(uint256 _amount, address _owner);
  event Emit(uint256 _amount, address _owner);

  constructor(
    address _scrapMetalAddress,
    address _shopAddress,
    address _storageAddress
  ) {
    scrapMetalAddress = _scrapMetalAddress;
    modules[0] = _shopAddress;
    modules[1] = _storageAddress;
    moduleType = "base";
    cost = 10;
  }

  // install module
  function installModule(uint256 _nameCode, address _module) public {
    require(SpaceshipModule(_module).cost() + cost <= 20, "Exceeds cost"); // get price of module, and add it to cost.
    modules[_nameCode] = _module;
  }

  // receives a ERC-20 token representing "scrap metal" - inspired by FTL. Scrap metal can be
  // TODO: Turn this into staking rather than other things.
  function receiveResource(uint256 _amount) public override {
    require(IERC20(scrapMetalAddress).balanceOf(msg.sender) > _amount, "Insufficient tokens");
    IERC20(scrapMetalAddress).transferFrom(msg.sender, address(this), _amount);

    emit Receive(_amount, address(this));
  }

  // send resource to other module of the ship. Ships have to re-balance resource between sub-modules of the ship.
  function sendResource(uint256 _amount, address _module) public override ownsModules(_module) {
    // module needs to be owned by owner
    require(IERC20(scrapMetalAddress).balanceOf(address(this)) > _amount, "Insufficient tokens");
    IERC20(scrapMetalAddress).transferFrom(address(this), _module, _amount);

    emit Emit(_amount, address(this));
  }

  // modifiers
  modifier ownsModules(address _module) {
    bool isWhitelisted = true;
    for (uint256 i = 0; i < moduleCount; i++) {
      if (modules[i] != address(0)) {
        isWhitelisted = false;
      }
    }
    require(isWhitelisted, "Not whitelisted");
    _;
  }
}
