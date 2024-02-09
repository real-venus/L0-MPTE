// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.20;

import "src/MRPTToken.sol";

contract MockMRPTToken is MRPTToken {
    constructor(
        uint64 startVestingTimestamp, address ecoSystem, address marketing, address stakingRewards, address team, address advisors, address _lzEndpoint) MRPTToken(startVestingTimestamp, ecoSystem, marketing, stakingRewards, team, advisors, _lzEndpoint) {
        }
}
