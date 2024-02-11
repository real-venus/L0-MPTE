// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import "src/SniperV3.sol";

contract MockSniperV3 is MRPTSniperV3 {
  constructor(ISwapRouter _swapRouter, address _wethAddress, address _mrptAddress, uint24 _poolFee) MRPTSniperV3(_swapRouter, _wethAddress, _mrptAddress, _poolFee) {}
}
