// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

/// @title Gateway contract
/// @author Jidooochan
contract Gateway {
    error Unauthorized();
    error UnauthorizedAddVerifiedRound();

    event ConfigChanged(address indexed manager, address indexed drandContract);

    /// Manager to set the drand address and trusted sources.
    address public manager;

    /// The address of the drand contract.
    address public drandContract;

    /// Addresses which are trusted for providing randomness to the gateway.
    mapping(address => bool) trustedSources;

    constructor(address _manager) {
        manager = _manager;
    }

    function addVerifiedRound(
        uint round,
        bytes32 randomness,
        bool isVerifyingTx
    ) external {
        if (!trustedSources[msg.sender]) revert UnauthorizedAddVerifiedRound();
    }

    function setConfig(address _manager, address _drandContract) external {
        if (msg.sender != manager) revert Unauthorized();
        manager = _manager;
        drandContract = _drandContract;
        emit ConfigChanged(_manager, _drandContract);
    }

    function addToTrustedSource(address[] calldata addList) external {
        if (msg.sender != manager) revert Unauthorized();
        for (uint i = 0; i < addList.length; i++) {
            trustedSources[addList[i]] = true;
        }
    }

    function removeFromTrustedSource(address[] calldata removeList) external {
        if (msg.sender != manager) revert Unauthorized();
        for (uint i = 0; i < removeList.length; i++) {
            trustedSources[removeList[i]] = false;
        }
    }
}
