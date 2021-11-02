//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/ShipModule.sol";

contract ShopModule is Ownable, Module {
  address public scrapMetalAddress; // ERC20 token of scrap metal
  mapping(uint256 => address) public modules;
  uint256 public moduleCount = 2;
  uint256 public cost;

  event Receive(uint256 _amount, address _owner);
  event Emit(uint256 _amount, address _owner);

  // IF YOU STAKE ON MY SHOP MODULE YOU'RE EFFECTIVELY YIELD FARMINGGGGGGG LFGGG ***

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
