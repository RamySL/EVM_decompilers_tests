// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssemblyYulTest {
    uint256 private stored;

    constructor(uint256 init) {
        assembly { sstore(stored.slot, init) }
    }

    function addNumbers(uint256 x, uint256 y) external pure returns (uint256 result) {
        assembly {
            result := add(x, y)
        }
    }

    function multiplyAndStore(uint256 a, uint256 b) external {
        assembly {
            let prod := mul(a, b)
            sstore(stored.slot, prod)
        }
    }

    function getStored() external view returns (uint256 result) {
        assembly {
            result := sload(stored.slot)
        }
    }

    function sumDynamicArray(uint256[] memory arr) external pure returns (uint256 total) {
        assembly {
            let len := mload(arr)
            let ptr := add(arr, 0x20)
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let val := mload(add(ptr, mul(i, 0x20)))
                total := add(total, val)
            }
        }
    }

    function shaAndRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) external view returns (address recovered) {
        assembly {
            let mptr := mload(0x40)
            mstore(mptr, hash)
            mstore(add(mptr, 0x20), v)
            mstore(add(mptr, 0x40), r)
            mstore(add(mptr, 0x60), s)
            let success := staticcall(gas(), 1, mptr, 0x80, mptr, 0x20)
            recovered := mload(mptr)
        }
    }

    function incrementYul(uint256 value) external pure returns (uint256 result) {
        assembly {
            function inc(y) -> z { z := add(y, 1) }
            result := inc(value)
        }
    }
}
