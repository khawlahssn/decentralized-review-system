// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title ILending
 * @notice An interface for a simple lending contract with no interest involved
 */
interface ILending {
    // Deposit tokens into the lending protocol
    function deposit(uint256 amount) external;

    // Withdraw tokens from the lending protocol
    function withdraw(uint256 amount) external;

    // Borrow tokens from the lending protocol
    function borrow(uint256 amount) external;

    // Repay borrowed tokens to the lending protocol
    function repay(uint256 amount) external;

    // Get the user's token balance in the lending protocol
    function getBalance(address user) external view returns (uint256);

    // Get the user's borrowed amount in the lending protocol
    function getBorrowedAmount(address user) external view returns (uint256);

    // Get the total supply of tokens in the lending protocol
    function getTotalSupply() external view returns (uint256);

    // Get the total borrowed amount in the lending protocol
    function getTotalBorrowed() external view returns (uint256);
}
