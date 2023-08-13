// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Interface of the ERC20 standard
 */
interface IToken is IERC20 {
    function decimals() external view returns (uint8);
}