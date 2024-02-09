// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "openzeppelin/access/Ownable.sol";
// import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MRPTSniperV3 is Ownable {
    // For the scope of these swap examples,
    // we will detail the design considerations when using
    // `exactInput`, `exactInputSingle`, `exactOutput`, and  `exactOutputSingle`.

    // It should be noted that for the sake of these examples, we purposefully pass in the swap router instead of
    // inherit the swap router for simplicity.
    // More advanced example contracts will detail how to inherit the swap router safely.
    ISwapRouter public immutable swapRouter;

    address public wethAddress;
    address public mrptAddress;

    // For this example, we will set the pool fee to 0.3%.
    uint24 public poolFee;

    constructor(ISwapRouter _swapRouter, address _wethAddress, address _mrptAddress, uint24 _poolFee) {
        swapRouter = _swapRouter;
        wethAddress = _wethAddress;
        mrptAddress = _mrptAddress;
        poolFee = _poolFee;
    }

    /// @notice buyToken swaps a fixed amount of WETH9 for a maximum possible amount of MRPT
    /// @dev The calling address must approve this contract to spend at least `amountIn` worth of its WETH9 for this
    /// function to succeed.
    /// @param amountIn The exact amount of WETH9 that will be swapped for MRPT.
    /// @return amountOut The amount of MRPT received.
    function buyToken(uint256 amountIn) external onlyOwner returns (uint256 amountOut) {
        // msg.sender must approve this contract
        address tokenIn = wethAddress;
        address tokenOut = mrptAddress;

        // Transfer the specified amount of _ to this contract.
        // note: this contract must first be approved by msg.sender
        // token, from, to, value
        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);

        // // similar code using barebones ERC20 token -- TransferHelper uses low-level call()
        // uint balance = IERC20(tokenIn).balanceOf(msg.sender);
        // bool succ = IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        // console.log(succ);

        // Approve the router to spend
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountIn);

        // create params of swap
        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value
        // for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            fee: poolFee,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // The call to `exactInputSingle` executes the swap given the route.
        amountOut = swapRouter.exactInputSingle(params);
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
