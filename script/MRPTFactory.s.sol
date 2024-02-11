// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {MRPTFactory} from "src/MRPTFactory.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";


contract MRPTFactoryDeploy is Script {

    MRPTFactory factory;

    function run() external {

        // Anything within the broadcast cheatcodes is executed on-chain
        vm.startBroadcast();

        // Deploy the MRPT contract
        factory = new MRPTFactory();

        bytes32 salt = "12345";
        bytes memory bytecode = abi.encodePacked(vm.getCode("Create2.sol:Create2"));

        address deployedAddress = factory.deploy(0, salt , bytecode);
        console2.log("Address of Create2Factory: %s", deployedAddress);

        vm.stopBroadcast();
    }

}