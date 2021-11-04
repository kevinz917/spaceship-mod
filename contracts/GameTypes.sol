//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

library GameTypes {
  struct Plugin {
    uint256 pluginType;
    uint256 cost;
    bool active;
  }

  struct Spaceship {
    address sentryPlugin; // actually ... if these are NFTs, should they be given
    address shopPlugin;
    uint256 extraPlugin; // maybe this can be a NFT ID
  }

  struct GameStorage {
    // admin
    address admin;
    bool paused;
    uint256 maxCost;
    // game state
    address energyToken;
    mapping(address => Plugin) plugins; // whitelisted elements, ideally controlled by DAO every season.
    mapping(address => Spaceship) spaceships; // player owned spaceships
    mapping(address => uint256) spaceshipCosts;
  }
}
