//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";

contract BasicNFTTest is Test {
    BasicNFT public basicNFT;
    DeployBasicNFT public deployer;

    address private user1 = makeAddr("user1");
    address private user2 = makeAddr("user2");
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";


    function setUp()public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);

    }

    function testNameIsCorrect() public {
        string memory expectedName = "Doggie";
        string memory actualName = basicNFT.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(user1);
        basicNFT.mintNft(PUG);
        assert(basicNFT.balanceOf(user1)==1);
        assert(keccak256(abi.encodePacked(PUG))==keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
    }
    
}

