// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Le but du contrat est de tester la capacité des décompilateur à retrouver les fonctions internes

contract DecompilationTest {

    uint256 private _stateValue;

    constructor(uint256 initialValue) {
        _stateValue = initialValue;
    }

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 res = _addInternal(a, b);
        return res;
    }

    function multiplyAndAddState(uint256 a, uint256 b) external view returns (uint256) {
        uint256 prod = _multiplyInternal(a, b);
        uint256 total = _addInternal(prod, _stateValue);
        return total;
    }

    function incrementState(uint256 delta) external {
        uint256 newVal = _addInternal(_stateValue, delta);
        _updateStateInternal(newVal);
    }

    function concatAndProcess(string calldata s1, string calldata s2) external pure returns (string memory) {
        string memory joined = string(abi.encodePacked(s1, s2));
        string memory processed = _processStringInternal(joined);
        return processed;
    }

    function getState() external view returns (uint256) {
        return _stateValue;
    }

    // === Fonctions internes ===


    function _addInternal(uint256 x, uint256 y) internal pure returns (uint256) {
        return x + y;
    }

    function _multiplyInternal(uint256 x, uint256 y) internal pure returns (uint256) {
        return x * y;
    }

    function _updateStateInternal(uint256 newValue) internal {
        _stateValue = newValue;
    }

    //Transforme une chaîne en majuscules 
    function _processStringInternal(string memory str) internal pure returns (string memory) {
        bytes memory bStr = bytes(str);
        for (uint i = 0; i < bStr.length; i++) {
            // if lowercase ascii a–z, convert to A–Z
            if (bStr[i] >= 0x61 && bStr[i] <= 0x7A) {
                bStr[i] = bytes1(uint8(bStr[i]) - 32);
            }
        }
        return string(bStr);
    }
}
