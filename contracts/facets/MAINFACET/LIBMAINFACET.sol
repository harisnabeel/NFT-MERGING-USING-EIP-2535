// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

// import "../../interfaces/IERC721.sol";
// import "../../libraries/AppStorage.sol";
// import "./MAINFACETStorage.sol";
import "../../libraries/AppStorage.sol";
import "../ERC721FACET/LIBERC721FACET.sol";
import "../ERC1155FACET/LIBERC1155FACET.sol";
import "../../libraries/LibStrings.sol";
import "../../libraries/LibDiamond.sol";
import "hardhat/console.sol";

contract LIBMAINFACET {
    AppStorage internal s;

    constructor() {
        // AppStorage storage s;
        // // TokenDetails storage s = td;
        // s.diamondAddress = _diamondAddress;
        // require(_LandContract != address(0), "Invalid Address!");
        // require(_PubgItemsContract != address(0), "Invalid Address!");
        // s._LandContractAddress = _LandContract;
        // s._PubgItemsContractAddress = _PubgItemsContract;
    }

    function mint(uint256 _quantity, uint256 _fees) public payable {
        // s.diamondAddress = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
        s.tokenCounter++;
        // s.TInfo[s.tokenCounter].holder = _to;
        s.TInfo[s.tokenCounter].isFungible = _quantity > 1 ? true : false;
        s.TInfo[s.tokenCounter]._quantity = _quantity;
        if (s.TInfo[s.tokenCounter].isFungible) {
            LIBERC1155FACET(s.PubgItemsContractAddress).createCollection(_quantity, _fees);
            console.log("ERC1155 created");
        } else {
            // LIBERC721FACET(s.LandContractAddress).mint(_to);
            // console.log("ERC721 created");
        }
        // console.log(s.diamondAddress);
        // (bool success, bytes memory result) = s.diamondAddress.delegatecall(abi.encodeWithSignature("test()"));
        // console.log(success);
        // console.logBytes(result);
        // console.log("PAKISTAN ZINDABAD");
    }

    function initializer(address _diamondAddress, address _PubgItemsContractAddress) public {
        s.diamondAddress = _diamondAddress;
        s.PubgItemsContractAddress = _PubgItemsContractAddress;
        // s.LandContractAddress = _LandContractAddress;
        console.log(s.diamondAddress);
        console.log(s.PubgItemsContractAddress);
        console.log(s.LandContractAddress);
    }

    // function setDiamond(address _diamond) public {
    //     libMainStorage.TokenDetails storage s = libMainStorage.mainStorage();
    //     s.
    // }
}
