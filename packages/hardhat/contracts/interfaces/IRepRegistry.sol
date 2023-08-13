// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IRepRegistry {
    /**
     * @notice A struct representing borrowers
     * @param noOfAttestations, the number of attested services provided by borrower 
     * @param repScore, the number representing the borrower's reputation score
     * @param balance, the borrower's wallet address  
     */
    struct BorrowerInfo {
        uint256 noOfAttestations;
        uint256 repScore;
        uint256 balance;
    }

    /**
     * @notice Emitted when a schema UID is set using Ethereum Attestation Service
     * @param uid, the schema uid used in Ethereum Attestation Service 
     */
    event SchemaUIDSet(bytes32 uid);

    /**
     * @notice Emitted when a borrower is registered
     * @param borrower, the wallet address of the borrower 
     */
    event BorrowerRegistered(address borrower);

    /**
     * @notice Emitted when a weight is added to the borrower's reputation score
     * @param borrower, the wallet address of the borrower
     * @param repScore, the borrower's current reputation score
     */
    event ScoreAdded(address borrower, uint256 repScore);

    /**
     * @notice initalizes the attestation schema 
     * @dev can only be called by the admin
     * @param uid, the schema uid used in Ethereum Attestation Service
     */
    function initSchemaUID(bytes32 uid) external;

    /**
     * @notice registers a borrower
     * @dev can only be called by the admin
     * @param wallet, the wallet address of the borrower 
     */
    function registerBorrower(address wallet) external;

    /**
     * @notice adds to the borrower's reputation score
     * @dev can only be called by the admin
     * @dev schemaUID should match the schema UID stored in the contract
     * @param uid, the schema UID used by the borrower to attest
     * @param borrower, the borrower's wallet address
     * @param weight, the weight assigned to the score (0-50)
     */
    function addToRepScore(
        bytes32 uid,
        address borrower,
        uint256 weight
    ) external;

    /**
     * @notice returns the borrower's info (wallet, reputation score, ...etc)
     * @param wallet, the borrower's wallet address
     * @return BorrowerInfo struct
     */
    function getBorrowerInfo(
        address wallet
    ) external view returns (BorrowerInfo memory);
}