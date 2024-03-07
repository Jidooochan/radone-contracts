// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {IProxy} from "./interfaces/IProxy.sol";

contract Proxy is IProxy {
    address public manager;

    constructor(address _manager) {
        manager = _manager;
    }

    function addConsumerToAllowlist(address consumer) external {}

    function removeConsumerFromAllowlist(address consumer) external {}
}
