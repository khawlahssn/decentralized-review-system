// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract REPToken is ERC20 {
    constructor(
        uint256 totalSupply_, 
        address receiver_
    ) ERC20("Reputation", "REP") {
        _mint(receiver_, totalSupply_ * (10 ** decimals()));
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }
}