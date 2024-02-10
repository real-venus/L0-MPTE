// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/access/Ownable.sol";
import "openzeppelin/token/ERC20/IERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

import {console} from "forge-std/console.sol";
import {console2} from "forge-std/console2.sol";

contract MRPTSniperV2 is Ownable {
    address public routerAddress;
    address public wethAddress;
    address public mrptAddress;

    constructor(address _routerAddress, address _wethAddress, address _mrptAddress) {
        routerAddress = _routerAddress;
        wethAddress = _wethAddress;
        mrptAddress = _mrptAddress;
    }

    function buyToken(uint256 amount) external payable {
        // Get the Uniswap router contract
        IUniswapV2Router02 router = IUniswapV2Router02(routerAddress);


        // // Get the weth contract
        // IERC20 weth = IERC20(wethAddress);

        // // Approve the router to spend weth
        // weth.approve(routerAddress, amount);

        // Create the path for the swap
        address[] memory path = new address[](2);
        path[0] = wethAddress;
        path[1] = mrptAddress;

        // Make the swap
        router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(
            0, // Accept any amount of tokens
            path,
            address(this), // Send the tokens to this contract
            block.timestamp + 300 // Set a deadline for the swap
        );
    }

    function withdrawTokens(address tokenAddress) external onlyOwner {
        // Get the ERC20 token contract
        IERC20 token = IERC20(tokenAddress);

        // Get the balance of the token in this contract
        uint256 balance = token.balanceOf(address(this));

        // Transfer the tokens to the owner
        token.transfer(owner(), balance);
    }

    function withdrawETH() external onlyOwner {
        // Get the balance of BNB in this contract
        uint256 balance = address(this).balance;

        // Transfer the BNB to the owner
        payable(owner()).transfer(balance);
    }

    receive() external payable { }
}
