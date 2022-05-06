// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// library libErc721Storage {
//     bytes32 constant ERC_721_STORAGE_POSITION = keccak256("PubgItems.Erc721.storage.location");

//     struct ERC721TOKEN {
//         mapping(address => uint256) _balances;
//         mapping(uint256 => address) _owners;
//         mapping(uint256 => address) _tokenApprovals;
//         mapping(address => mapping(address => bool)) _operatorApprovals;
//         uint256 tokenId;
//         uint256 totalSupply;
//         string name;
//         string symbol;
//     }

//     function erc721Storage() internal pure returns (ERC721TOKEN storage es) {
//         bytes32 position = ERC_721_STORAGE_POSITION;
//         assembly {
//             es.slot := position
//         }
//     }
// }
