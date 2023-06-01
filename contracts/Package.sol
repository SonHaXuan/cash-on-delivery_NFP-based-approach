// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Package is Ownable, ERC721URIStorage {
    IERC20 _token;
    address public _owner;
    mapping(uint256 => bool) public sold;
    mapping(uint256 => uint256) public price;
    event Purchase(address owner, uint256 price, uint256 id);

    constructor() ERC721("NFT PACKAGE", "PACKAGE") {
        _owner = msg.sender;
        _token = IERC20(_owner);
    }

    function mint(uint256 _tokenId, string memory metadataURI)
        external
        onlyOwner
    {
        // sold[_tokenId] = true;
        // price[_tokenId] = _price;

        super._safeMint(_owner, _tokenId);
        super._setTokenURI(_tokenId, metadataURI);
    }

    function transfer(address _to, uint256 _tokenId) external payable {
        _validate(_tokenId);

        // emit Purchase(address(this), price[_tokenId], _tokenId);
        emit Purchase(address(this), 1, _tokenId);
        super._transfer(address(this), _to, _tokenId);

        // get owner of the token
        address payable sendTo = payable(ownerOf(_tokenId));
        sendTo.transfer(msg.value);
    }

    function _validate(uint256 _id) internal view {
        require(_exists(_id), "Error, wrong Token id");
        require(sold[_id], "Error, Token is sold");

        // require(msg.value >= price[_id], "Error, Token costs more");
    }
}
