//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interface/IGameStorage.sol";

contract ModuleBaseTemplate {
  address gameStorage;

  mapping(address => uint256) balances; // user balances

  event Receive(uint256 _amount, address _owner);
  event Emit(uint256 _amount, address _owner);

  constructor(address _gameStorage) {
    gameStorage = _gameStorage;
  }

  // receives a ERC-20 token representing "energy" - inspired by FTL. Energy can be spent in future use cases
  // TODO: Transfering energy = staking ... what can we do with this ?
  // TODO: Finalize this and refactor ...
  function receiveResource(uint256 _amount) public {
    require(IERC20(IGameStorage(gameStorage).energyTokenAddress()).balanceOf(msg.sender) > _amount, "Insufficient tokens");
    IERC20(IGameStorage(gameStorage).energyTokenAddress()).transferFrom(msg.sender, address(this), _amount);
    balances[msg.sender] += _amount;

    emit Receive(_amount, address(this));
  }

  // send resource to other module of the ship. Ships have to re-balance resource between sub-modules of the ship.
  function sendResource(uint256 _amount, address _module) public {
    require(balances[msg.sender] >= _amount, "Insufficient funds");
    require(IERC20(IGameStorage(gameStorage).energyTokenAddress()).balanceOf(address(this)) > _amount, "Insufficient tokens");
    IERC20(IERC20(IGameStorage(gameStorage).energyTokenAddress())).transferFrom(address(this), _module, _amount);
    balances[msg.sender] -= _amount;

    emit Emit(_amount, address(this));
  }
}
