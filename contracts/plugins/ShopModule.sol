//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interface/IShipModule.sol";
import "../GameStorage.sol";

// TODO: Add ship interface
contract ShopModule is Ownable {
  address gameStorage;

  event Receive(uint256 _amount, address _owner);
  event Emit(uint256 _amount, address _owner);

  constructor(address _gameStorage) {
    gameStorage = _gameStorage;
  }

  // IF YOU STAKE ON MY SHOP MODULE YOU'RE EFFECTIVELY YIELD FARMINGGGGGGG LFGGG ***

  function receiveResource(uint256 _amount) public {
    require(IERC20(IGameStorage(gameStorage).energyTokenAddress()).balanceOf(msg.sender) > _amount, "Insufficient tokens");
    IERC20(IGameStorage(gameStorage).energyTokenAddress()).transferFrom(msg.sender, address(this), _amount);

    emit Receive(_amount, address(this));
  }

  // send resource to other module of the ship. Ships have to re-balance resource between sub-modules of the ship.
  function sendResource(uint256 _amount, address _module) public {
    require(IERC20(IGameStorage(gameStorage).energyTokenAddress()).balanceOf(address(this)) > _amount, "Insufficient tokens");
    IERC20(IERC20(IGameStorage(gameStorage).energyTokenAddress())).transferFrom(address(this), _module, _amount);

    emit Emit(_amount, address(this));
  }
}
