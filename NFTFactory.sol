// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SuperwineNFT.sol";

contract NFTFactory is Ownable {
    constructor() Ownable(msg.sender) {}
    
    struct Collection {
        address contractAddress;
        string name;
        string description;
        string category;
        string creator;
        string[] tags;
        uint256 royalty;
    }

    Collection[] public collections;
    mapping(address => bool) public isCollection;

    event CollectionCreated(address indexed creator, address contractAddress, string name);

    function createCollection(
        string memory _name,
        string memory _description,
        string memory _symbol,
        string memory _category,
        string memory _creator,
        string[] memory _tags,
        string memory _baseURI,
        uint256 _supply,
        uint256 _royalty
    ) external onlyOwner {
        SuperwineNFT collection = new SuperwineNFT(_name, _symbol, _baseURI);
        collections.push(Collection({
            contractAddress: address(collection),
            name: _name,
            description: _description,
            category: _category,
            creator: _creator,
            tags: _tags,
            royalty: _royalty
        }));

        isCollection[address(collection)] = true;

        emit CollectionCreated(msg.sender, address(collection), _name);

        collection.mint(msg.sender, _supply);
    }

    function getCollections() external view returns (Collection[] memory) {
        return collections;
    }
}


