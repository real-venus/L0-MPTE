// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MRPTFactory} from "src/MRPTFactory.sol";
import "src/MRPTToken1.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

contract MRPTFactoryTest is Test {

    MRPTFactory internal factory;

    uint256 internal mainnetFork;
    string internal MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    uint256 internal optimsmFork;
    string internal OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    uint256 internal sepoliaFork;
    string internal SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");

    address alice = address(1);

    function setUp() public {
    
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        optimsmFork = vm.createFork(OPTIMISM_RPC_URL);
        sepoliaFork = vm.createFork(SEPOLIA_RPC_URL);
    }

    function testSepoliaDeploy() public {

        vm.selectFork(sepoliaFork);
        assertEq(vm.activeFork(), sepoliaFork);

        factory = new MRPTFactory();

        vm.deal(address(alice), 100 ether);
        vm.startPrank(address(alice));
        
        // bytes32 salt = "12310809342894758923697913";
        bytes32 salt = keccak256(abi.encode("MRPTToken", address(this)));

        // bytes memory bytecode = abi.encodePacked(vm.getCode("MRPTToken1.sol:MRPTToken"));
        bytes memory creationCode = abi.encodePacked(type(MRPTToken).creationCode, abi.encode(uint64(0), 0x5f56eEBF7b6cC82750d41aC85376c9b2491e2F2e,0x5f56eEBF7b6cC82750d41aC85376c9b2491e2F2e, 0x5f56eEBF7b6cC82750d41aC85376c9b2491e2F2e, 0x5f56eEBF7b6cC82750d41aC85376c9b2491e2F2e, 0x5f56eEBF7b6cC82750d41aC85376c9b2491e2F2e, 0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675, "Marpto", "MRPT"));

        address computedAddress = factory.computeAddress(salt, keccak256(creationCode));
        console.log("computedAddress");
        console.log(computedAddress);
        // (bool success, ) = address(factory).call{value: 10 ether}(abi.encodeWithSignature("deploy(uint256 amount, bytes32 salt, bytes memory bytecode)", 0, salt , creationCode));

        // console.log("after create");

        // console.log("deployed address", addr);

        address deployedAddress = factory.deploy(0, salt , creationCode);
        vm.stopPrank();

        // assertEq(computedAddress, deployedAddress);
        // console.log("sepolia address");
        // console.log(deployedAddress);    
    }

    function testOptimismDeploy() public {

        vm.selectFork(optimsmFork);
        assertEq(vm.activeFork(), optimsmFork);

        factory = new MRPTFactory();

        vm.deal(address(alice), 100 ether);
        vm.startPrank(address(alice));
        
        bytes32 salt = "12345";
        bytes memory bytecode = abi.encodePacked(vm.getCode("MRPTToken.sol:MRPTToken"));

        address computedAddress = factory.computeAddress(salt, keccak256(bytecode));
        address deployedAddress = factory.deploy(0, salt , bytecode);
        vm.stopPrank();

        assertEq(computedAddress, deployedAddress);
        console.log("sepolia address");
        console.log(deployedAddress);    
    }

    function testMainnetDeploy() public {

        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        factory = new MRPTFactory();

        vm.deal(address(alice), 100 ether);
        vm.startPrank(address(alice));
        
        bytes32 salt = "12345";
        bytes memory bytecode = abi.encodePacked(vm.getCode("MRPTToken.sol:MRPTToken"));

        address computedAddress = factory.computeAddress(salt, keccak256(bytecode));
        address deployedAddress = factory.deploy(0, salt , bytecode);
        vm.stopPrank();

        assertEq(computedAddress, deployedAddress);
        console.log("sepolia address");
        console.log(deployedAddress);    
    }
}