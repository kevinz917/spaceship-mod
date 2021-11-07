//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./GameTypes.sol";
import "./GameStorage.sol";

contract GameCore is GameStorage {
  constructor(
    address _admin,
    address _dao,
    uint256 _maxCost
  ) {
    s.admin = _admin;
    s.dao = _dao;
    s.maxCost = _maxCost;
  }

  ///////////////////////////////////
  /////// SPACESHIP CONTROL /////////
  ///////////////////////////////////

  event Attack(uint256 _damage, uint256 _attacker, uint256 _target);

  // Install spaceship module
  function installPlugin(address _module) public {
    require(s.plugins[_module].active, "Plugin is inactive");
    require(getCurrentCost() + s.plugins[_module].cost < s.maxCost, "Exceeds budget");

    uint256 _spaceshipType = s.plugins[_module].pluginType; // get plugin type

    // TOOD: Add cost to ship
    if (_spaceshipType == 0) {
      s.spaceships[msg.sender].mainPlugin = _module;
    } else if (_spaceshipType == 1) {
      s.spaceships[msg.sender].shopPlugin = _module;
    }
  }

  // Remove spacehsip module
  function removePlugin(uint256 _type) public {
    if (_type == 0) {
      s.spaceships[msg.sender].mainPlugin = address(0);
    } else if (_type == 1) {
      s.spaceships[msg.sender].shopPlugin = address(0);
    }
  }

  // Get current cost of spaceship
  function getCurrentCost() public view returns (uint256) {
    return s.spaceshipCosts[msg.sender];
  }

  // TODO: Complete functiion
  // Attack spaceship
  function attackSpaceship(address _targetPlayer, address _targetModuleAddress) public {
    // In a game like Darkforest this needs to be enforced with a ZKP
    uint256 stakedEnergyAmount = IERC20(energyTokenAddress()).balanceOf(_targetModuleAddress);
    uint256 attackAmount = stakedEnergyAmount; // TODO: get random value based on energy it has on module
    IERC20(energyTokenAddress()).transferFrom(_targetPlayer, address(0), attackAmount);
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
  ) public onlyDAO {
    s.plugins[_module] = GameTypes.Plugin({ pluginType: _type, cost: _cost, active: true });
    s.activePlugins.push(_module);
  }

  // Remove module from game
  function blacklistPlugin(address _module) public onlyDAO {
    require(s.plugins[_module].active == true, "Module doesn't exist");
    s.plugins[_module].active = false;
  }

  function setDAOaddress(address _dao) public onlyAdmin {
    s.dao = _dao;
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
