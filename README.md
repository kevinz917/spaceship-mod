# 🛸 Spaceship Game

So far, on-chain games we see are interoperable in the sense that their financial assets are - [tradeable cards](https://twitter.com/ParallelNFT), [pets](https://twitter.com/aavegotchi), etc. Beyond the interoperability of assets, how do we make games modular?

How can we make on-chain games more composable and get more players involved in the game creation process? What would a plugin / modding ecosystem look like? How do players get rewarded for their work?

## Overview

This is a proof of concept on-chain game framework that enables:

- Users to write plugins with a shared interface in an upgradeable manner.
- Introduce those plugins through DAO decision making.
- Allow plugin creators to receive revenue splits when winnings are distributed at the end of game.

## How it works

Here, I present a spaceship game. In this game, every user owns a spaceship, and they build the spaceships by selecting a few components such as a base template, a shop module, sentry gun. The player can customize their spaceship by installing modules (plugins). These modules are created by community members, and voted on by the community (DAO). The DAO can plug in governance modules, whitelist these modules, and include them in the next round of the game.

One interesting game mechanic I'm also exploring is the inclusion of a ERC20 token denoting "energy". Users have an upper bound on the number of tokens and must balance them between different modules to super / discharge abilities. Future game mechanics such as attack and defense are correlated with the way users distribute the tokens within the spaceship. This was inspired by [FTL](https://store.steampowered.com/app/212680/FTL_Faster_Than_Light/).

## Future plans

Here are some areas I'm actively thinking about

- What does interoperability look like for games beyond the interoperability of assets themselves?
- Would an on-chain game engine make sense and why.
- How defi elements like flashloans, fractional, can play into games. More specifically, what are defi mechanisms that wouldn't make sense in the real world but would in games?
- Games as a distribution channel and how they can leverage that. What are the different business models games can have. Thinking about Netflix vs. Hulu, the Figma plugin ecosystem. etc.

SO to [chub.eth](https://twitter.com/chubivan) for walking through the technicals of DF.

Please follow me [here](https://twitter.com/kzdagoof) and reach out [here](https://thekevinz.com/) to jam on ideas!
