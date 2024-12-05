// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SuperwineNFT.sol";

contract NFTFactory is Ownable {
    address feeCollector;
    constructor(address _feeCollector) Ownable(msg.sender) {
        feeCollector = _feeCollector;
    }
    
    struct Collection {
        address contractAddress;
        string name;
        string description;
        string category;
        string creator;
        string[] tags;
        uint256 royalty;
    }

    mapping(uint256 => Collection) public collections;
    uint256 public collectionCount;
    mapping(address => bool) public isCollection;

    event CollectionCreated(address indexed creator, address contractAddress, string name, uint256 collectionId);

    function createCollection(
        string memory _name,
        string memory _description,
        string memory _symbol,
        string memory _category,
        string memory _creator,
        string[] memory _tags,
        string memory _baseURI,
        uint96 _royalty
    ) external returns(uint256) {
        
        SuperwineNFT collection = new SuperwineNFT(_name, _symbol, _baseURI, feeCollector, _royalty);
        collections[collectionCount++] = Collection({
            contractAddress: address(collection),
            name: _name,
            description: _description,
            category: _category,
            creator: _creator,
            tags: _tags,
            royalty: _royalty
        });

        isCollection[address(collection)] = true;

        emit CollectionCreated(msg.sender, address(collection), _name, collectionCount);


        return collectionCount;

    }

    function mintNFTs(uint256 collectionId, uint256 _supply) external {
        SuperwineNFT collection = SuperwineNFT(collections[collectionId].contractAddress);
        collection.mint(msg.sender, _supply);
    }

    
}


