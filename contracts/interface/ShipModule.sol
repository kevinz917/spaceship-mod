//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

// A universal module interface every ship module (can be created by gamers!) are used by
interface Module {
  function receiveResource(uint256 _amount) external;

  function sendResource(uint256 _amount) external;
}
