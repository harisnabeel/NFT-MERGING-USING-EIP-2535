// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../../interfaces/IERC721.sol";
import "../../libraries/AppStorage.sol";
// import "./ERC721Storage.sol";
import "../../libraries/LibStrings.sol";
import "../../libraries/LibDiamond.sol";
import "hardhat/console.sol";

contract LIBERC721FACET is IERC721 {
    AppStorage internal s;

    function mint(address _to) public payable {
        require(msg.value >= 1, "Send more ethers: 1 ether is required");
        require(balanceOf(_to) == 0, "You can not have more than 1 Land");
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        s.tokenId721++;
        _mint(_to, s.tokenId721);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        s._balances[to] += 1;
        s._owners[tokenId] = to;
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return s._balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        address owner = s._owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = LIBERC721FACET.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all");

        _approve(to, tokenId);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        return s._operatorApprovals[owner][operator];
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        s._tokenApprovals[tokenId] = to;
        emit Approval(LIBERC721FACET.ownerOf(tokenId), to, tokenId);
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        require(owner != operator, "ERC721: approve to caller");
        s._operatorApprovals[owner][operator] = approved;
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(LIBERC721FACET.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        s._balances[from] -= 1;
        s._balances[to] += 1;
        s._owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();

        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return s._tokenApprovals[tokenId];
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        // libErc721Storage.ERC721TOKEN storage s = libErc721Storage.erc721Storage();
        return s._owners[tokenId] != address(0);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = LIBERC721FACET.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }
}
