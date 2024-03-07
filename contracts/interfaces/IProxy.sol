// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IProxy {
    function addConsumerToAllowlist(address consumer) external;

    function removeConsumerFromAllowlist(address consumer) external;
}
