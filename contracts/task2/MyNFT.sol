// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 private _nextTokenId = 1;
    mapping (uint256 => string) private _tokenURIs;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function mintNFT(address to, string calldata uri) public returns (uint256 tokenId) {
        uint256 newId = _nextTokenId;
        _nextTokenId++;
        _safeMint(to, newId);
        _setTokenURI(newId, uri);
        return newId;
    }

    function _setTokenURI(uint256 tokenId, string calldata _uri) internal virtual {
        _requireOwned(tokenId);
        _tokenURIs[tokenId] = _uri;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);
        string memory uri = _tokenURIs[tokenId];
        if (bytes(uri).length == 0) {
            revert("URI not set for this token");
        }
        return uri;
    }

    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
        address preOwner = super._update(to, tokenId, auth);
        if (to == address(0) && bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
        return preOwner;
    }
}

// json metadata link
// https://gateway.pinata.cloud/ipfs/bafkreid7wlteprmzxkafxdpoptk3kmjc4brb5zn22lygraoqeufl2qptai