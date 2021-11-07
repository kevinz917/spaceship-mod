// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// A universal module interface every ship module (can be created by gamers!) are used by
interface Module {
  function receiveResource(uint256 _amount) external;

  function sendResource(uint256 _amount, address _module) external;

  function getCost() external returns (uint256);
}
