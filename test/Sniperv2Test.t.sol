// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
// import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import "test/mock/MockSniperV2.sol";
import "test/mock/MockMRPTToken.sol";
import "test/mock/IVestingWallet.sol";
import "test/mock/IWETH.sol";
contract SnperV2Test is Test {
  // the identifiers of the forks
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

  address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address factoryAddress = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

  address pool;

  address _lzEndpoint = 0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675;

  MockSniperV2 sniperV2;
  MockMRPTToken public mrptToken;

  function setUp() public {
      mainnetFork = vm.createFork(vm.envString("MAINNET_RPC_URL"));
      optimismFork = vm.createFork(vm.envString("OPTIMISM_RPC_URL"));

      vm.selectFork(mainnetFork);
      assertEq(vm.activeFork(), mainnetFork);

      vm.rollFork(19_196_173);

      mrptToken = new MockMRPTToken(uint64(block.timestamp), ecoSystem, marketing, stakingRewards, team, advisors, _lzEndpoint);
      sniperV2 = new MockSniperV2(routerAddress, wethAddress, address(mrptToken));
  }

  // demonstrate fork ids are unique
  function test_buyMRPT() public {
      assert(mainnetFork != optimismFork);

      assertEq(mrptToken.balanceOf(address(sniperV2)), 0);

      test_createAndAddLiquidity();

      vm.deal(alice, 2 ether);

      vm.prank(alice);
      (bool success, ) = address(sniperV2).call{value: 1 ether}(abi.encodeWithSignature("buyToken(uint256)", 1 ether));
      if(!success) return;

      assertNotEq(mrptToken.balanceOf(address(sniperV2)), 0);
  }

  function test_WithdrawToken() public {
    assert(mainnetFork != optimismFork);

    test_createAndAddLiquidity();

    vm.deal(alice, 2 ether);

    vm.prank(alice);
    (bool success, ) = address(sniperV2).call{value: 2 ether}(abi.encodeWithSignature("buyToken(uint256)", 1 ether));
    if(!success) return;

    assertNotEq(mrptToken.balanceOf(address(sniperV2)), 0);

    sniperV2.withdrawTokens(address(mrptToken));

    assertEq(mrptToken.balanceOf(address(sniperV2)), 0);
}

  /**
  * @dev Example usage of creating a Uniswap V2 pair and adding liquidity.
  */
  function test_createAndAddLiquidity() public {
      // Create the pair if it hasn't been initialized yet.
      pool = IUniswapV2Factory(factoryAddress).createPair(address(mrptToken), wethAddress);

      vm.deal(alice, 10 ether);
      
      vm.prank(alice);
      (bool success, ) = wethAddress.call{value: 10 ether}(abi.encodeWithSignature("deposit(address,uint256)", alice, 10 ether));
      if(!success) return;

      mrptToken.mint(address(alice), 10 ether);

      vm.startPrank(alice);
      IWETH(wethAddress).approve(address(routerAddress), 10 ether);
      mrptToken.approve(address(routerAddress), 10 ether);
      vm.stopPrank();

      vm.prank(alice);
      // Add liquidity to the Uniswap V2 pair
      IUniswapV2Router02(routerAddress).addLiquidity(
        address(mrptToken),
        wethAddress,
        10 ether,
        10 ether,
        9 ether,
        9 ether,
        alice,
        block.timestamp
      );
  }
}