// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library libMainStorage {
    bytes32 constant MAIN_STORAGE =
        keccak256(
            // Compatible with pie-smart-pools
            "PubgItems.MainStorage.storage.location"
        );

    bytes32 constant TOKEN_STORAGE =
        keccak256(
            // Compatible with pie-smart-pools
            "PubgItems.Token_Storage..storage.location"
        );

    struct TokenInfo {
        address holder;
        bool isFungible;
        uint256 _quantity;
    }

    struct TokenDetails {
        mapping(uint256 => TokenInfo) TInfo;
        address diamondAddress;
        uint256 tokenCounter;
    }

    function mainStorage() internal pure returns (TokenDetails storage es) {
        bytes32 position = MAIN_STORAGE;
        assembly {
            es.slot := position
        }
    }

    function tokenStorage() internal pure returns (TokenInfo storage es) {
        bytes32 position = TOKEN_STORAGE;
        assembly {
            es.slot := position
        }
    }
}
