//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {

    /**Errors */
    error MoodNFT__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_happySVGImageURI;
    string private s_sadSVGImageURI;
    enum Mood {
        HAPPY,
        SAD
    }
    mapping(uint256 => Mood) private s_tokenToMood;

    constructor (string memory sadSVGImageUri, string memory happySVGImageUri) ERC721("Mood NFT", "MN") {
        s_happySVGImageURI = happySVGImageUri;
        s_sadSVGImageURI = sadSVGImageUri;
    }

    function flipMood(uint256 tokenId) public {
        if(_ownerOf( tokenId) != msg.sender){
            revert MoodNFT__CantFlipMoodIfNotOwner();
        }
        if(s_tokenToMood[tokenId] == Mood.HAPPY){
            s_tokenToMood[tokenId] = Mood.SAD;
        }else 
        {
            s_tokenToMood[tokenId] = Mood.HAPPY;
        }
    }

    function mintNFT()  public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

     function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        string memory imageURI;
        if(s_tokenToMood[tokenId] == Mood.HAPPY){
            imageURI = s_happySVGImageURI;
        }else {
            imageURI = s_sadSVGImageURI;

        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
