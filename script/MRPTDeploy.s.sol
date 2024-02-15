// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {MRPTFactory} from "src/MRPTFactory.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/MRPTToken.sol";

interface IMRPT {
    function transferOwnership(address) external;
}

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
        address owner = vm.envAddress("TOKEN_OWNER");
        uint256 start_timestamp = vm.envUint("START_TIMESTAMP");

        vm.startBroadcast(deployerPrivateKey);

        factory = new MRPTFactory();
     
        bytes32 salt = keccak256(abi.encode("MRPTToken"));

        bytes memory creationCode = abi.encodePacked(type(MRPTToken).creationCode, abi.encode(uint64(start_timestamp), ecosystem, marketing, stakingreward, team, advisor, lzEndPoint, "Marpto", "MRPT"));

        address computedAddress = factory.computeAddress(salt, keccak256(creationCode));

        console.log("computed MRPT Token Address");
        console.log(computedAddress);

        address deployedAddress = factory.deploy(owner, 0, salt , creationCode);

        console.log("deployed MRPT Token Address");
        console.log(deployedAddress);

        vm.stopBroadcast();
    }

}