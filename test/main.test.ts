import { expect } from "chai";
import { ethers as Ethers } from "ethers";
import { ethers } from "hardhat";
import { REVERT_MESSAGES, World, initializeWorld, fixtureLoader, EMPTY_ADDRESS } from "./helper";

describe("Spaceship", () => {
  let world: World;

  before(async () => {
    world = await fixtureLoader(initializeWorld); // INITIALIZE WORLD
  });

  it("World Initialization check", async () => {
    expect(await world.contracts.gameCore.adminAddress()).to.be.equal(world.users.user1.address);
    expect(await world.contracts.gameCore.daoAddress()).to.be.equal(world.users.user1.address);
    expect(await world.contracts.gameCore.maxCost()).to.be.equal(10);
  });

  it("Whitelist and Blacklist Plugins", async () => {
    // whitelist main module and shop module
    const whitelistTwoModules = async () => {
      await world.contracts.gameCore.whitelistPlugin(world.contracts.spaceshipMainModule.address, 0, 5); // whitelist main module
      await world.contracts.gameCore.whitelistPlugin(world.contracts.shopModule.address, 1, 3); // whitelist main module
    };

    await whitelistTwoModules();

    const spaceshipMainModule = await world.contracts.gameCore.getPlugin(world.contracts.spaceshipMainModule.address);
    expect(spaceshipMainModule.cost).equals(5);
    expect(spaceshipMainModule.pluginType).equals(0);
    expect(spaceshipMainModule.active).equals(true);

    const shopModule = await world.contracts.gameCore.getPlugin(world.contracts.shopModule.address);
    expect(shopModule.cost).equals(3);
    expect(shopModule.pluginType).equals(1);
    expect(shopModule.active).equals(true);

    // test blacklist plugin
    await world.contracts.gameCore.blacklistPlugin(world.contracts.spaceshipMainModule.address); // whitelist main module
    const removedSpaceshipMainModule = await world.contracts.gameCore.getPlugin(world.contracts.spaceshipMainModule.address);
    expect(removedSpaceshipMainModule.active).equal(false);

    await whitelistTwoModules(); // add them back
  });

  it("Install plugins", async () => {
    await world.contracts.gameCore.installPlugin(world.contracts.spaceshipMainModule.address); // install main module for player1
    await world.contracts.gameCore.installPlugin(world.contracts.shopModule.address); // install main module for player1
    const player1Spaceship = await world.contracts.gameCore.getSpaceship(world.users.user1.address);
    expect(player1Spaceship.mainPlugin).equal(world.contracts.spaceshipMainModule.address);
    expect(player1Spaceship.shopPlugin).equal(world.contracts.shopModule.address);
  });

  it("Remove plugins", async () => {
    await world.contracts.gameCore.removePlugin(0); // remove main module
    await world.contracts.gameCore.removePlugin(1); // remove shop module
    const player1Spaceship = await world.contracts.gameCore.getSpaceship(world.users.user1.address);
    expect(player1Spaceship.mainPlugin).equal(EMPTY_ADDRESS);
    expect(player1Spaceship.shopPlugin).equal(EMPTY_ADDRESS);
  });
});
