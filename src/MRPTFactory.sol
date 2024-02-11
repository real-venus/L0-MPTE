// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console} from "forge-std/console.sol";
import {console2} from "forge-std/console2.sol";

contract MRPTFactory {

    error MRPTFactoryInsufficientBalance(uint256 received, uint256 minimumNeeded);

    error MRPTFactoryEmptyBytecode();

    error MRPTFactoryFailedDeployment();

    function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) external payable returns (address addr) {
        
        if (msg.value < amount) {
            revert MRPTFactoryInsufficientBalance(msg.value, amount);
        }

        if (bytecode.length == 0) {
            revert MRPTFactoryEmptyBytecode();
        }

        console.log("Deploy test");

        assembly {
            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
        }

        console.log("after create");

        console.log("deployed address", addr);

        if (addr == address(0)) {
            revert MRPTFactoryFailedDeployment();
        }
    }

    function computeAddress(bytes32 salt, bytes32 bytecodeHash) external view returns (address addr) {

        address contractAddress = address(this);
        
        assembly {
            let ptr := mload(0x40)

            mstore(add(ptr, 0x40), bytecodeHash)
            mstore(add(ptr, 0x20), salt)
            mstore(ptr, contractAddress)
            let start := add(ptr, 0x0b)
            mstore8(start, 0xff)
            addr := keccak256(start, 85)
        }
    }

}