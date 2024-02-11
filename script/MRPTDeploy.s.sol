// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {MRPTFactory} from "src/MRPTFactory.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/MRPTToken.sol";

contract MRPTDeploy is Script {

    MRPTFactory factory;

    function run() external {

        // Anything within the broadcast cheatcodes is executed on-chain
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address ecosystem = vm.envAddress("ECOSYSTEM");
        address marketing = vm.envAddress("MARTKETING");
        address stakingreward = vm.envAddress("STAKINGREWARD");
        address team = vm.envAddress("TEAM");
        address advisor = vm.envAddress("ADVISOR");
        address lzEndPoint = vm.envAddress("LZENDPOINT");
        vm.startBroadcast(deployerPrivateKey);

        factory = new MRPTFactory();
     
        bytes32 salt = keccak256(abi.encode("MRPTToken", address(this)));

        bytes memory creationCode = abi.encodePacked(type(MRPTToken).creationCode, abi.encode(uint64(0), ecosystem, marketing, stakingreward, team, advisor, lzEndPoint, "Marpto", "MRPT"));

        address computedAddress = factory.computeAddress(salt, keccak256(creationCode));

        console.log("computed MRPT Token Address");
        console.log(computedAddress);

        address deployedAddress = factory.deploy(0, salt , creationCode);

        console.log("deployed MRPT Token Address");
        console.log(deployedAddress);

        vm.stopBroadcast();
    }

}