// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "layerzero/token/oft/v1/OFT.sol";
import "openzeppelin/finance/VestingWallet.sol";
import "openzeppelin/token/ERC20/ERC20.sol";
import "openzeppelin/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";
import {console2} from "forge-std/console2.sol";

contract MRPTToken is OFT {
    uint public constant MAX_SUPPLY = 900e24;
    uint public mintable;

    address public ecoSystemAddr;
    address public marketingAddr;
    address public stakingRewardsAddr;
    address public teamAddr;
    address public advisorsAddr;

    event VestingStarted(address beneficiaryAddress, address vestingWallet);

    constructor(
        uint64 startVestingTimestamp,
        address ecoSystem,
        address marketing,
        address stakingRewards,
        address team,
        address advisors,
        address _lzEndpoint
    ) OFT("Marpto", "MRPT", _lzEndpoint) {
        mintable = MAX_SUPPLY;

        // Ecosystem - 20% 9 months cliff and 5% monthly for 20 months
        ecoSystemAddr = _startVesting(
            ecoSystem,
            startVestingTimestamp,
            9 * 30 days,
            20 * 30 days,
            2000
        );

        // Marketing - 18% 5 months cliff and 5% monthly for 20 months
        marketingAddr = _startVesting(
            marketing,
            startVestingTimestamp,
            5 * 30 days,
            20 * 30 days,
            1800
        );

        // Staking Rewards - 21% Linear vesting for 60 Months
        stakingRewardsAddr = _startVesting(
            stakingRewards,
            startVestingTimestamp,
            0,
            60 * 30 days,
            2100
        );

        // Team - 10% 12 months Cliff 5% monthly for 20 Months
        teamAddr = _startVesting(
            team,
            startVestingTimestamp,
            12 * 30 days,
            20 * 30 days,
            1000
        );

        // Advisors - 5% 10 Months cliff and 5% monthly for 20 months
        advisorsAddr = _startVesting(
            advisors,
            startVestingTimestamp,
            10 * 30 days,
            20 * 30 days,
            500
        );
    }

    function _startVesting(
        address beneficiaryAddress,
        uint64 startVestingTimestamp,
        uint64 cliffSeconds,
        uint64 durationSeconds,
        uint64 proportion
    ) internal returns (address) {
        address vestingWallet = address(
            new VestingWallet(
                beneficiaryAddress,
                startVestingTimestamp + cliffSeconds,
                durationSeconds
            )
        );
        uint amount = (MAX_SUPPLY * proportion) / 10000;
        mintable -= amount;
        _mint(vestingWallet, amount);
        emit VestingStarted(beneficiaryAddress, vestingWallet);
        return vestingWallet;
    }

    function mint(address account, uint amount) external onlyOwner {
        mintable -= amount;
        _mint(account, amount);
    }
}
