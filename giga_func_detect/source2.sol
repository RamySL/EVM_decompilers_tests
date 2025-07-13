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

    function add2(uint256 a, uint256 b, bool c) external pure returns (bool) {
        uint256 res = _addInternal(a, b);
        res++;
        return c;
    }


    function getState() external view returns (uint256) {
        return _stateValue;
    }

    // === Fonctions internes ===


    function _addInternal(uint256 x, uint256 y) internal pure returns (uint256) {
        return x + y;
    }


}
