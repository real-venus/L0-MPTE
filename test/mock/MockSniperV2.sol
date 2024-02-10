// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import "src/SniperV2.sol";

contract MockSniperV2 is MRPTSniperV2 {
  constructor(address _routerAddress, address _wethAddress, address _mrptAddress) MRPTSniperV2(_routerAddress, _wethAddress, _mrptAddress) {}
}
