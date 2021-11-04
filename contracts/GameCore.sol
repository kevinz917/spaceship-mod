//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "./GameTypes.sol";
import "./GameStorage.sol";

contract GameCore is GameStorage {
  constructor() {}

  ///////////////////////////////////
  /////// SPACESHIP CONTROL /////////
  ///////////////////////////////////

  // Install spaceship module
  function installPlugin(address _module) public {
    require(s.plugins[_module].active, "Plugin is inactive");
    require(getCurrentCost() + s.plugins[_module].cost < s.maxCost, "Exceeds budget");

    uint256 _spaceshipType = s.plugins[_module].pluginType; // get plugin type

    if (_spaceshipType == 0) {
      s.spaceships[msg.sender].sentryPlugin = _module;
    } else if (_spaceshipType == 1) {
      s.spaceships[msg.sender].shopPlugin = _module;
    }
  }

  // Remove spacehsip module
  function removePlugin(uint256 _type) public {
    if (_type == 0) {
      s.spaceships[msg.sender].sentryPlugin = address(0);
    } else if (_type == 1) {
      s.spaceships[msg.sender].shopPlugin = address(0);
    }
  }

  // Get current cost of spaceship
  function getCurrentCost() public view returns (uint256) {
    return s.spaceshipCosts[msg.sender];
  }

  ///////////////////////////////////
  ////////// DAO CONTROL ////////////
  ///////////////////////////////////

  // Every new round, DAOs whitelist a new set of plugins.
  // Current plugins are removed
  function changeRounds(
    address[] memory _modules,
    uint256[] memory _types,
    uint256[] memory _costs
  ) public onlyDAO {
    // Remove all plugins from current round
    for (uint256 i = 0; i < s.activePlugins.length; i++) {
      blacklistPlugin(s.activePlugins[i]);
    }

    // Add new plugins voted by community for next round
    for (uint256 i = 0; i < _modules.length; i++) {
      whitelistPlugin(_modules[i], _types[i], _costs[i]);
    }
  }

  // Add module to game
  function whitelistPlugin(
    address _module,
    uint256 _type,
    uint256 _cost
  ) private {
    s.plugins[_module] = GameTypes.Plugin({ pluginType: _type, cost: _cost, active: true });
    s.activePlugins.push(_module);
  }

  // Remove module from game
  function blacklistPlugin(address _module) private {
    require(s.plugins[_module].active == true, "Module doesn't exist");
    s.plugins[_module].active = false;
  }

  ///////////////////////////////////
  //////////  MODIFIERS ////////////
  ///////////////////////////////////
  modifier onlyAdmin() {
    require(msg.sender == s.admin, "Not admin");
    _;
  }

  modifier onlyDAO() {
    require(msg.sender == s.dao, "Not DAO");
    _;
  }
}
