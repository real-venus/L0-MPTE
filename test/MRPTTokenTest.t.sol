// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "test/mock/MockMRPTToken.sol";

contract MRPTTokenTest is Test {
    MockMRPTToken public mrptToken;

    uint256 mainnetFork;
    uint256 optimismFork;

    uint64 startVestingTimestamp = uint64(block.timestamp);
    address ecoSystem = address(1);
    address marketing = address(2);
    address stakingRewards = address(3);
    address team = address(4);
    address advisors = address(5);
    address _lzEndpoint = address(6);

    function setUp() public {

        mainnetFork = vm.createFork(vm.envString("MAINNET_RPC_URL"));
        optimismFork = vm.createFork(vm.envString("OPTIMISM_RPC_URL"));

        mrptToken = new MockMRPTToken(startVestingTimestamp, ecoSystem, marketing, stakingRewards, team, advisors, _lzEndpoint);
    }

    function test_transferFromFee() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        // mrptToken()
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
