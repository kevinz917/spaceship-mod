// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../GameTypes.sol";

// A universal module interface every ship module (can be created by gamers!) are used by
interface IGameStorage {
  function energyTokenAddress() external returns (address);

  function adminAddress() external returns (address);

  function daoAddress() external returns (address);

  function maxCost() external returns (uint256);

  function getPlugin(address _plugin) external returns (GameTypes.Plugin memory);

  function getSpaceship(address _player) external returns (GameTypes.Spaceship memory);

  function isPluginActive(address _plugin) external returns (bool);

  function getGameReward() external returns (uint256);

  function getWinner() external returns (address);

  function getCreator(address _plugin) external returns (address);
}
