// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../../interfaces/IERC1155.sol";
import "../../libraries/AppStorage.sol";
// import "./ERC1155Storage.sol";
import "../../libraries/LibStrings.sol";
import "../../libraries/LibDiamond.sol";
import "hardhat/console.sol";

// struct FacetStorage {
//     uint256 _PBG_coin_supply;
//     uint256 _PBG_price;
//     mapping(uint256 => uint256) collectionsMintingFees; // collections to fees in PBG tokens
//     uint256 collectionsCount; //total collections count
//     uint256 tokenCounter;
//     address owner;
// }

contract LIBERC1155FACET is IERC1155 {
    AppStorage internal s;

    constructor() {
        s.owner = msg.sender;
    }

    function mintToCollection(
        address _to,
        uint256 _id,
        uint256 _quantityOfToken
    ) public {
        // require(_id != 1, "You can not mint PGB tokens");
        // require(_id <= s.collectionsCount, "Collection not created YET");
        // require(balanceOf(_to, 1) >= _quantityOfToken * s.collectionsMintingFees[_id - 1], "Need to spend some more PBG tokens");
        safeTransferFrom(_to, s.owner, 1, _quantityOfToken * s.collectionsMintingFees[_id - 1], "");
        // console.log(balanceOf(msg.sender, 1), "haris nabeel");
        _mint(_to, _id, _quantityOfToken);
        setApprovalForAll(_to, true);
    }

    function test() public {
        console.log("This is called");
    }

    function createCollection(uint256 _quantityOfToken, uint256 _collectionMintingFees) public {
        s.collectionsCount++;
        s.tokenCounterPbg++;
        s.collectionsMintingFees[s.collectionsCount] = _collectionMintingFees;
        _mint(msg.sender, s.tokenCounterPbg, _quantityOfToken);
        balanceOf(msg.sender, s.tokenCounterPbg);
        // console.log("Collection Created Successfully Successfully");
        // console.log(s.collectionsMintingFees[s.collectionsCount]);
    }

    function _mint(
        address _to,
        uint256 _tokenId,
        uint256 _amount
    ) internal {
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        // console.log(_to, "This is _to inputted");
        s.balances[_tokenId].accountBalances[_to] += _amount;
        console.log(s.balances[_tokenId].accountBalances[_to], "mint called");
    }

    function balanceOf(address _owner, uint256 _id) public view virtual override returns (uint256 balance_) {
        console.log(_owner, "Id of balance");
        require(_owner != address(0), "ERC1155: address zero is not a valid owner");
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        balance_ = s.balances[_id].accountBalances[_owner];
        console.log(s.balances[_id].accountBalances[_owner]);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes memory _data
    ) public virtual override {
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        require(_to != address(0), "ERC1155Facet: Can't transfer to 0 address");
        // require(_from == msg.sender || s.accounts[_from].tokensApproved[msg.sender], "ERC1155Facet: Not approved to transfer");
        uint256 bal = s.balances[_id].accountBalances[_from];
        require(bal >= _value, "ERC1155Facet: _value greater than balance");
        s.balances[_id].accountBalances[_from] = bal - _value;
        s.balances[_id].accountBalances[_to] += _value;
        console.log("This is Balance");
        console.log(s.balances[_id].accountBalances[_to]);
    }

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) public virtual override {
        require(_to != address(0), "ERC1155Facet: Can't transfer to 0 address");
        require(_ids.length == _values.length, "ERC1155Facet: _ids not the same length as _values");
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        require(_from == msg.sender || s.accounts[_from].tokensApproved[msg.sender], "ERC1155Facet: Not approved to transfer");
        for (uint256 i; i < _ids.length; i++) {
            uint256 id = _ids[i];
            uint256 value = _values[i];
            uint256 bal = s.balances[id].accountBalances[_from];
            require(bal >= value, "ERC1155Facet: _value greater than balance");
            s.balances[id].accountBalances[_from] = bal - value;
            s.balances[id].accountBalances[_to] += value;
        }
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) public view virtual override returns (uint256[] memory balances_) {
        require(_owners.length == _ids.length, "Tickets: _owners not same length as _ids");
        balances_ = new uint256[](_owners.length);
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        for (uint256 i; i < _owners.length; i++) {
            balances_[i] = s.balances[_ids[i]].accountBalances[_owners[i]];
        }
    }

    function setApprovalForAll(address _operator, bool _approved) public virtual override {
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        s.accounts[msg.sender].tokensApproved[_operator] = _approved;
    }

    function isApprovedForAll(address _owner, address _operator) public view virtual override returns (bool) {
        // libErc1155Storage.AppStorage storage s = libErc1155Storage.erc1155Storage();
        return s.accounts[_owner].tokensApproved[_operator];
    }
}
