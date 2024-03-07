// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library BotLib {
    error MonikerEmpty();
    error MonikerTooLong();

    uint public constant MAX_MONIKER_LEN = 20;
    enum Group {
        A,
        B
    }

    function validateMoniker(string memory moniker) internal pure returns (bool) {
        bytes memory b = bytes(moniker);
        if (b.length == 0) revert MonikerEmpty();
        if (b.length > MAX_MONIKER_LEN) revert MonikerTooLong();
        return true;
    }

    function group(address addr) internal pure returns (Group) {
        bytes32 h = sha256(abi.encodePacked(addr));
        if (uint8(h[0]) % 2 == 0) return Group.A;
        return Group.B;
    }
}
