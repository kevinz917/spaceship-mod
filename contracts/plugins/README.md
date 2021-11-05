## Contract files

`ModuleBaseTemplate.sol`

The base template code every module (plugin) must inherit so each module can be allocated energy tokens. This is totally
an arbitrary game mechanic I came up with but it demonstrates that plugins all need to share some sort of interface

`SpaceshipMainModule.sol`

The main spaceship module that serves as the base for a spaceship the player owns.

`ShopModule.sol`

Example of a player / community created module. Here, players can donate ERC20 energy game tokens for a memorabilia NFT.
