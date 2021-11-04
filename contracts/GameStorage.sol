//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "./interface/IGameStorage.sol";
import "./GameTypes.sol";

contract GameStorage is IGameStorage {
  GameTypes.GameStorage public s; // storage splot 1 (or 0??)

  function energyTokenAddress() public view override returns (address) {
    return s.energyToken;
  }
}
