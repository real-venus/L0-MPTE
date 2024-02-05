// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./lib/layerzero/contracts/token/oft/v1/OFT.sol";

contract MRPTToken is OFT {
    uint public constant MAX_SUPPLY = 900e24;

    constructor(address _lzEndpoint) OFT("Marpto", "MRPT", _lzEndpoint) { }
}