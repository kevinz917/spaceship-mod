//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "./interface/IGameStorage.sol";
import "./GameTypes.sol";

contract GameStorage is IGameStorage {
  GameTypes.GameStorage public s; // storage splot 1 (or 0??)

  function energyTokenAddress() public view override returns (address) {
    return s.energyToken;
  }

  function adminAddress() public view returns (address) {
    return s.admin;
  }

  function daoAddress() public view returns (address) {
    return s.dao;
  }

  function maxCost() public view returns (uint256) {
    return s.maxCost;
  }

  // TODO: Look into if I actually need these
  function getPlugin(address _plugin) public view returns (GameTypes.Plugin memory) {
    return s.plugins[_plugin];
  }
}
