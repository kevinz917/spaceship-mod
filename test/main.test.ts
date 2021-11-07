import { expect } from "chai";
import { ethers as Ethers } from "ethers";
import { ethers, waffle } from "hardhat";
import { REVERT_MESSAGES, World, initializeWorld, fixtureLoader, EMPTY_ADDRESS, contracts, users } from "./helper";

describe("Spaceship", () => {
  let world: World;
  let contracts: contracts;
  let users: users;

  let plugin1creator: any;
  let plugin2creator: any;

  before(async () => {
    world = await fixtureLoader(initializeWorld); // INITIALIZE WORLD
    contracts = world.contracts;
    users = world.users;
    plugin1creator = world.users.user1;
    plugin2creator = world.users.user2;
  });

  it("World Initialization check", async () => {
    expect(await contracts.gameCore.adminAddress()).to.be.equal(users.user1.address);
    expect(await contracts.gameCore.daoAddress()).to.be.equal(users.user1.address);
    expect(await contracts.gameCore.maxCost()).to.be.equal(10);
    expect(await contracts.gameCore.getGameReward()).to.be.equal(ethers.utils.parseEther("100"));
  });

  it("Whitelist and Blacklist Plugins", async () => {
    // whitelist main module and shop module
    const whitelistTwoModules = async () => {
      await contracts.gameCore.whitelistPlugin(plugin1creator.address, contracts.spaceshipMainModule.address, 0, 5); // whitelist main module
      await contracts.gameCore.whitelistPlugin(plugin2creator.address, contracts.shopModule.address, 1, 3); // whitelist main module
    };

    await whitelistTwoModules();

    // verify creators are correct
    expect(await contracts.gameCore.getCreator(contracts.spaceshipMainModule.address)).to.be.equal(plugin1creator.address);
    expect(await contracts.gameCore.getCreator(contracts.shopModule.address)).to.be.equal(plugin2creator.address);

    const spaceshipMainModule = await contracts.gameCore.getPlugin(contracts.spaceshipMainModule.address);
    expect(spaceshipMainModule.cost).equals(5);
    expect(spaceshipMainModule.pluginType).equals(0);
    expect(spaceshipMainModule.active).equals(true);

    const shopModule = await contracts.gameCore.getPlugin(contracts.shopModule.address);
    expect(shopModule.cost).equals(3);
    expect(shopModule.pluginType).equals(1);
    expect(shopModule.active).equals(true);

    // test blacklist plugin
    await contracts.gameCore.blacklistPlugin(contracts.spaceshipMainModule.address); // whitelist main module
    const removedSpaceshipMainModule = await contracts.gameCore.getPlugin(contracts.spaceshipMainModule.address);
    expect(removedSpaceshipMainModule.active).equal(false);

    await whitelistTwoModules(); // add them back
  });

  it("Install plugins", async () => {
    await contracts.gameCore.installPlugin(contracts.spaceshipMainModule.address); // install main module for player1
    await contracts.gameCore.installPlugin(contracts.shopModule.address); // install main module for player1
    const player1Spaceship = await contracts.gameCore.getSpaceship(users.user1.address);
    expect(player1Spaceship.mainPlugin).equal(contracts.spaceshipMainModule.address);
    expect(player1Spaceship.shopPlugin).equal(contracts.shopModule.address);
  });

  it("Remove plugins", async () => {
    await contracts.gameCore.removePlugin(0); // remove main module
    await contracts.gameCore.removePlugin(1); // remove shop module
    const player1Spaceship = await contracts.gameCore.getSpaceship(users.user1.address);
    expect(player1Spaceship.mainPlugin).equal(EMPTY_ADDRESS);
    expect(player1Spaceship.shopPlugin).equal(EMPTY_ADDRESS);
  });

  it("Finalize game", async () => {
    await contracts.gameCore.setWinner(users.user1.address); // set arbitrary winner
    expect(await contracts.gameCore.getWinner()).to.be.equal(users.user1.address);

    const contractBalance = ethers.utils.formatEther(await world.provider.getBalance(contracts.gameCore.address));
    console.log(contractBalance);

    await contracts.gameCore.distributeWinnings(); // payout winners

    expect(Number(ethers.utils.formatEther(await world.provider.getBalance(plugin1creator.address))) - Number(ethers.utils.formatEther(await world.provider.getBalance(plugin1creator.address))))
      .to.be.least(97)
      .to.be.most(100);
  });
});
