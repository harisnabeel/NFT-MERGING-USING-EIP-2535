// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

struct TokenInfo {
    // for MAINFACETSTORAGE
    address holder;
    bool isFungible;
    uint256 _quantity;
}

// struct TokenDetails {
//     //for MAINFACETSTORAGE
//     mapping(uint256 => TokenInfo) TInfo;
//     address diamondAddress;
//     uint256 tokenCounter;
// }

// ERC1155 STORAGE
// struct ERC1155STORAGE {
//     // mapping(uint256 => ERC1155token) balances; // Id to account to balance  // works as double mapping
//     // mapping(address => Account) accounts; // address to adress to approval flag
//     // uint256 tokenId; // erc1155 tokenId
// }
struct ERC1155token {
    mapping(address => uint256) accountBalances;
    uint256 totalSupply;
}

struct Account {
    mapping(address => bool) tokensApproved;
}

// ERC721 STORAGE

// struct ERC721TOKEN {
//     mapping(address => uint256) _balances;
//     mapping(uint256 => address) _owners;
//     mapping(uint256 => address) _tokenApprovals;
//     mapping(address => mapping(address => bool)) _operatorApprovals;
//     uint256 tokenId;
//     uint256 totalSupply;
//     string name;
//     string symbol;
// }

// main app storage to access

struct AppStorage {
    address PubgItemsContractAddress;
    address LandContractAddress;
    // mapping(uint256 => TokenDetails) tokenDetails;
    // mapping(uint256 => ERC1155STORAGE) erc1155Storage;
    // mapping(uint256 => ERC721TOKEN) erc721Storage;
    mapping(uint256 => ERC1155token) balances; // Id to account to balance  // works as double mapping
    mapping(address => Account) accounts; // address to adress to approval flag
    uint256 tokenId1155; // erc1155 tokenId
    //erc721 token
    mapping(address => uint256) _balances;
    mapping(uint256 => address) _owners;
    mapping(uint256 => address) _tokenApprovals;
    mapping(address => mapping(address => bool)) _operatorApprovals;
    uint256 tokenId721;
    uint256 totalSupply;
    string name;
    string symbol;
    //for MAINFACETSTORAGE
    mapping(uint256 => TokenInfo) TInfo;
    address diamondAddress;
    uint256 tokenCounter;
    // pbg contract variables
    uint256 _PBG_coin_supply;
    uint256 _PBG_price;
    mapping(uint256 => uint256) collectionsMintingFees; // collections to fees in PBG tokens
    uint256 collectionsCount; //total collections count
    uint256 tokenCounterPbg;
    address owner;
}
