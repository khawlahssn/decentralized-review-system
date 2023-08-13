// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./interfaces/IRepRegistry.sol";
import "./interfaces/IToken.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract RepRegistry is IRepRegistry, AccessControl {
    using SafeERC20 for IToken;

    IToken private immutable _repToken;
    bytes32 private _schemaUID;
    address private _treasuryWallet;

    mapping(address => BorrowerInfo) private _borrowers;

    constructor(
        address repToken_, 
        address treasuryWallet_
    ) {
        _repToken = IToken(repToken_);
        _treasuryWallet = treasuryWallet_;
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function initSchemaUID(bytes32 uid) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(uid != bytes32(0), "initSchemaUID: invalid schema uid");
        _schemaUID = uid;

        emit SchemaUIDSet(uid);
    }

    function registerBorrower(address wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(wallet != address(0), "registerBorrower: invalid address");
        _borrowers[wallet] = BorrowerInfo(0, 0, 0);

        emit BorrowerRegistered(wallet);
    }

    function addToRepScore(
        bytes32 uid,
        address borrower,
        uint256 weight
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(uid == _schemaUID, "addToRepScore: invalid schema uid");
        require(borrower != address(0), "addToRepScore: invalid address");

        _borrowers[borrower].noOfAttestations++;
        _borrowers[borrower].repScore = _borrowers[borrower].repScore + weight;

        uint256 tokenAmount = weight * (10 ** _repToken.decimals());
        _borrowers[borrower].balance = _borrowers[borrower].balance + tokenAmount;

        _repToken.safeTransferFrom(_treasuryWallet, borrower, tokenAmount);

        emit ScoreAdded(borrower, tokenAmount);
    }

    function getBorrowerInfo(
        address wallet
    ) external view returns (BorrowerInfo memory){
        return _borrowers[wallet];
    }
}