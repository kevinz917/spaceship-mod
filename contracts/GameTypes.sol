// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library GameTypes {
  struct Plugin {
    uint256 pluginType;
    uint256 cost;
    bool active;
  }

  struct Spaceship {
    address mainPlugin; // actually ... if these are NFTs, should they be given
    address shopPlugin;
    uint256 extraPlugin; // maybe this can be a NFT ID
  }

  struct GameStorage {
    // admin
    address admin;
    address dao;
    bool paused;
    uint256 gameRewards; // rewards for winners
    // game state
    uint256 maxCost; // max cost per spaceship
    address energyToken;
    address[] activePlugins; // list of active plugins used in current round
    address winner;
    mapping(address => address) creators; // plugin address => creators;
    mapping(address => Plugin) plugins; // whitelisted plugins, ideally controlled by DAO every season.
    mapping(address => Spaceship) spaceships; // player owned spaceships
    mapping(address => uint256) spaceshipCosts;
    mapping(address => uint256) positions; // unused, but player coordinate should be here
  }
}
