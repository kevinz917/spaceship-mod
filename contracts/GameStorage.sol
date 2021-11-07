// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./interface/IGameStorage.sol";
import "./GameTypes.sol";

contract GameStorage is IGameStorage {
  GameTypes.GameStorage public s; // storage splot 1 (or 0??)

  function energyTokenAddress() public view override returns (address) {
    return s.energyToken;
  }

  function adminAddress() public view override returns (address) {
    return s.admin;
  }

  function daoAddress() public view override returns (address) {
    return s.dao;
  }

  function maxCost() public view override returns (uint256) {
    return s.maxCost;
  }

  // TODO: Look into if I actually need these
  function getPlugin(address _plugin) public view override returns (GameTypes.Plugin memory) {
    return s.plugins[_plugin];
  }

  function getSpaceship(address _player) public view override returns (GameTypes.Spaceship memory) {
    return s.spaceships[_player];
  }

  function isPluginActive(address _plugin) public view override returns (bool) {
    return s.plugins[_plugin].active;
  }

  function getCreator(address _plugin) public view override returns (address) {
    return s.creators[_plugin];
  }

  function getGameReward() public view override returns (uint256) {
    return s.gameRewards;
  }

  function getWinner() public view override returns (address) {
    return s.winner;
  }
}
