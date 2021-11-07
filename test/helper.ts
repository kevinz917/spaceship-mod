import { ethers, waffle } from "hardhat";
import { ethers as Ethers } from "ethers";

// see fixtures: https://ethereum-waffle.readthedocs.io/en/latest/fixtures.html
export const fixtureLoader = waffle.createFixtureLoader();

export const shopMetadataURL = "www.google.com";
export const EMPTY_ADDRESS = "0x0000000000000000000000000000000000000000";
export interface World {
  contracts: {
    gameCore: Ethers.Contract;
    spaceshipMainModule: Ethers.Contract;
    shopModule: Ethers.Contract;
  };
  users: {
    user1: any;
    user2: any;
    user3: any;
  };
}

// initialize world params
export const initializeWorld = async (): Promise<World> => {
  let gameCore: Ethers.Contract;
  let spaceshipMainModule: Ethers.Contract;
  let shopModule: Ethers.Contract;
  let user1: any;
  let user2: any;
  let user3: any;
  let user4: any; // donation recipient for shopModule

  // TODO: Add more initial vending machine locations :)))
  [user1, user2, user3, user4] = await ethers.getSigners();
  gameCore = await (await ethers.getContractFactory("GameCore")).deploy(user1.address, user1.address, 10);
  spaceshipMainModule = await (await ethers.getContractFactory("SpaceshipModule")).deploy(gameCore.address);
  shopModule = await (await ethers.getContractFactory("ShopModule")).deploy(gameCore.address, shopMetadataURL, user4.address);

  return {
    contracts: {
      gameCore,
      spaceshipMainModule,
      shopModule,
    },
    users: {
      user1,
      user2,
      user3,
    },
  };
};

export enum REVERT_MESSAGES {
  INVALID_PROOF = "Proof is not valid",
}
