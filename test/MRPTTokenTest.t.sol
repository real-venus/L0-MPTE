// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "test/mock/MockMRPTToken.sol";
import "test/mock/IVestingWallet.sol";

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
    address alice = address(6);
    address bob = address(7);
    address _lzEndpoint = 0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675;

    function setUp() public {
        mainnetFork = vm.createFork(vm.envString("MAINNET_RPC_URL"));
        optimismFork = vm.createFork(vm.envString("OPTIMISM_RPC_URL"));
    }

    // function test_transferFromFee() public {
    //     vm.selectFork(mainnetFork);
    //     assertEq(vm.activeFork(), mainnetFork);

    //     vm.rollFork(19_196_173);
    //     // mrptToken()
    //     mrptToken.transfer()
    // }

    // function test_transferFromFee() public {
    //     vm.selectFork(mainnetFork);
    //     assertEq(vm.activeFork(), mainnetFork);

    //     vm.rollFork(19_196_173);
    //     // mrptToken()
    //     // mrptToken.transfer()
    // }

    function test_vest_peoriod() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        vm.rollFork(19_196_173);

        // vm.startPrank(ecoSystem);
        // console.log("----start----");
        // console.log(IVestingWallet(mrptToken.marketingAddr()).start());
        // console.log("----released----");
        // console.log(IVestingWallet(mrptToken.marketingAddr()).released(address(mrptToken)));
        // console.log("----releasable----");
        // console.log(IVestingWallet(mrptToken.marketingAddr()).releasable(address(mrptToken)));
        // console.log("----beneficiary----");
        // console.log(IVestingWallet(mrptToken.advisorsAddr()).beneficiary());
        // console.log("----duration----");
        // console.log(IVestingWallet(mrptToken.advisorsAddr()).duration());
        // console.log("----vestedAmount----");
        // console.log(IVestingWallet(mrptToken.advisorsAddr()).vestedAmount(address(mrptToken), uint64(block.timestamp)));

        uint256 start_timestamp = vm.envUint("START_TIMESTAMP");

        mrptToken = new MockMRPTToken(
            uint64(start_timestamp),
            ecoSystem,
            marketing,
            stakingRewards,
            team,
            advisors,
            _lzEndpoint
        );

        assertEq(
            IVestingWallet(mrptToken.ecoSystemAddr()).beneficiary(),
            ecoSystem
        );
        assertEq(
            IVestingWallet(mrptToken.ecoSystemAddr()).duration(),
            20 * 30 days
        );
        assertEq(mrptToken.balanceOf(mrptToken.ecoSystemAddr()), 900e24 * 0.2);

        assertEq(
            IVestingWallet(mrptToken.marketingAddr()).beneficiary(),
            marketing
        );
        assertEq(
            IVestingWallet(mrptToken.marketingAddr()).duration(),
            20 * 30 days
        );
        assertEq(mrptToken.balanceOf(mrptToken.marketingAddr()), 900e24 * 0.18);

        assertEq(
            IVestingWallet(mrptToken.stakingRewardsAddr()).beneficiary(),
            stakingRewards
        );
        assertEq(
            IVestingWallet(mrptToken.stakingRewardsAddr()).duration(),
            60 * 30 days
        );
        assertEq(
            mrptToken.balanceOf(mrptToken.stakingRewardsAddr()),
            900e24 * 0.21
        );

        assertEq(IVestingWallet(mrptToken.teamAddr()).beneficiary(), team);
        assertEq(IVestingWallet(mrptToken.teamAddr()).duration(), 20 * 30 days);
        assertEq(mrptToken.balanceOf(mrptToken.teamAddr()), 900e24 * 0.1);

        assertEq(
            IVestingWallet(mrptToken.advisorsAddr()).beneficiary(),
            advisors
        );
        assertEq(
            IVestingWallet(mrptToken.advisorsAddr()).duration(),
            20 * 30 days
        );
        assertEq(mrptToken.balanceOf(mrptToken.advisorsAddr()), 900e24 * 0.05);

        IVestingWallet(mrptToken.ecoSystemAddr()).release(address(mrptToken));

        assertEq(mrptToken.balanceOf(ecoSystem), 0);

        vm.warp(start_timestamp + 9 * 30 days + 1 * 30 days);
        // console.log(IVestingWallet(mrptToken.ecoSystemAddr()).vestedAmount(address(mrptToken), uint64(start_timestamp + 9 * 30 days + 1 * 30 days)));
        // after vesting period, 20% can be released
        IVestingWallet(mrptToken.ecoSystemAddr()).release(address(mrptToken));

        assertEq(mrptToken.balanceOf(ecoSystem), (900e24 * 0.2) / 20);
    }

    function test_transferFee() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        vm.rollFork(19_196_173);

        mrptToken = new MockMRPTToken(
            uint64(block.timestamp),
            ecoSystem,
            marketing,
            stakingRewards,
            team,
            advisors,
            _lzEndpoint
        );

        mrptToken.mint(address(alice), 10 ether);

        // transferFrom test
        vm.prank(alice);
        mrptToken.approve(address(this), 1 ether);
        mrptToken.transferFrom(alice, bob, 1 ether);

        // 0.5% fee
        // assertEq(mrptToken.balanceOf(mrptToken.FEE_RECEIVER()), 5e15);
        assertEq(mrptToken.balanceOf(bob), 1 ether);

        vm.prank(alice);
        mrptToken.transfer(bob, 1 ether);

        // 0.5% fee
        // assertEq(mrptToken.balanceOf(mrptToken.FEE_RECEIVER()), 1e16);
        assertEq(mrptToken.balanceOf(bob), 2 ether);
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
