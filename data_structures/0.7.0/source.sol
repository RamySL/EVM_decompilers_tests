// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract ComplexDataStructures {
    struct Container {
        uint256[] numbers;
        mapping(address => uint256) balances;
    }

    mapping(uint256 => Container) private containers;
    mapping(address => mapping(uint256 => bool)) private flags;
    mapping(address => bytes) private blobs;

    function addNumber(uint256 id, uint256 value) external {
        containers[id].numbers.push(value);
    }

    function getNumber(uint256 id, uint256 index) external view returns (uint256) {
        return containers[id].numbers[index];
    }

    function incrementBalance(uint256 id) external {
        containers[id].balances[msg.sender]++;
    }

    function getBalance(uint256 id, address user) external view returns (uint256) {
        return containers[id].balances[user];
    }

    function setFlag(uint256 id) external {
        flags[msg.sender][id] = true;
    }

    function getFlag(uint256 id, address user) external view returns (bool) {
        return flags[user][id];
    }

    function setBlob(bytes calldata data) external {
        blobs[msg.sender] = data;
    }

    function getBlob(address user) external view returns (bytes memory) {
        return blobs[user];
    }
}
