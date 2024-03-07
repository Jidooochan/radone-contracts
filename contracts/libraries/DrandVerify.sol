// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library DrandVerifyLib {
    function deriveRandomness(
        bytes memory signature
    ) internal pure returns (bytes32) {
        return sha256(signature);
    }
}
