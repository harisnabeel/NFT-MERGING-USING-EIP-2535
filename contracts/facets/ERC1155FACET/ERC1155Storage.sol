// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// library libErc1155Storage {
//     bytes32 constant ERC_1155_STORAGE_POSITION =
//         keccak256(
//             // Compatible with pie-smart-pools
//             "PubgItems.storage.location"
//         );

//     struct AppStorage {
//         mapping(uint256 => ERC1155token) balances; // Id to account to balance  // works as double mapping
//         mapping(address => Account) accounts; // address to adress to approval flag
//         uint256 tokenId; // erc1155 tokenId
//     }
//     struct ERC1155token {
//         mapping(address => uint256) accountBalances;
//         uint256 totalSupply;
//     }

//     struct Account {
//         mapping(address => bool) tokensApproved;
//     }

//     function erc1155Storage() internal pure returns (AppStorage storage es) {
//         bytes32 position = ERC_1155_STORAGE_POSITION;
//         assembly {
//             es.slot := position
//         }
//     }
// }
