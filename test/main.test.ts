import { expect } from "chai";
import { ethers as Ethers } from "ethers";
import { ethers } from "hardhat";
import { REVERT_MESSAGES, World, initializeWorld, fixtureLoader } from "./helper";

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
    await world.contracts.gameCore.whitelistPlugin(world.contracts.spaceshipMainModule.address, 0, 5); // whitelist main module
    await world.contracts.gameCore.whitelistPlugin(world.contracts.shopModule.address, 1, 3); // whitelist main module

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
  });
});

// examples
// await nftContract.mint(...initMintProofsArgs);
// expect(nftContract.mint(...initMintWrongProofArgs)).to.be.revertedWith(revertMessages.INVALID_PROOF);
// expect(await nftContract.balanceOf(addr1.address)).to.be.equal(1); // mint NFT
// const character = await nftContract.characters(0);
// expect(character.cHash).equal(initMintProofsArgs[3][0]);
// expect(character.isRevealed).equal(false);
