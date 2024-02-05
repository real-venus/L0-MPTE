// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./lib/layerzero/contracts/token/oft/v1/OFT.sol";
import "./lib/openzeppelin/contracts/finance/VestingWallet.sol";

contract MRPTToken is OFT {
    uint public constant MAX_SUPPLY = 900e24;
    uint public mintable;

    event VestingStarted(address beneficiaryAddress, address vestingWallet);

    constructor(
        uint64 startVestingTimestamp,
        address ecoSystem,
        address marketing,
        address stakingRewards,
        address team,
        address advisors,
        address _lzEndpoint) OFT("Marpto", "MRPT", _lzEndpoint) {
            mintable = MAX_SUPPLY;

            // Ecosystem - 20% 9 months cliff and 5% monthly for 20 months
            _startVesting(ecoSystem, startVestingTimestamp, 9 * 30 days, 20 * 30 days, 2000);

            // Marketing - 18% 5 months cliff and 5% monthly for 20 months
            _startVesting(marketing, startVestingTimestamp, 5 * 30 days, 20 * 30 days, 1800);

            // Staking Rewards - 21% Linear vesting for 60 Months
            _startVesting(stakingRewards, startVestingTimestamp, 0, 60 * 30 days, 2100);

            // Team - 10% 12 months Cliff 5% monthly for 20 Months
            _startVesting(team, startVestingTimestamp, 12 * 30 days, 20 * 30 days, 1000);

            // Advisors - 5% 10 Months cliff and 5% monthly for 20 months
            _startVesting(advisors, startVestingTimestamp, 10 * 30 days, 20 * 30 days, 500);
        }

    function _startVesting(address beneficiaryAddress, uint64 startVestingTimestamp, uint64 cliffSeconds, uint64 durationSeconds, uint64 proportion) internal {
        address vestingWallet = address(new VestingWallet(beneficiaryAddress, startVestingTimestamp + cliffSeconds, durationSeconds));
        uint amount = MAX_SUPPLY * proportion / 10000;
        mintable -= amount;
        _mint(vestingWallet, amount);
        emit VestingStarted(beneficiaryAddress, vestingWallet);
    }

    function mint(address account, uint amount) external onlyOwner {
        mintable -= amount;
        _mint(account, amount);
    }
}