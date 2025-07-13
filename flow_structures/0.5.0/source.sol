pragma solidity ^0.5.0;

contract ControlFlowTest {
    function ifElse(uint x) external pure returns (uint) {
        if (x < 10) {
            return 1;
        } else if (x < 20) {
            return 2;
        } else {
            return 3;
        }
    }

    function nested(uint x, uint y) external pure returns (uint) {
        if (x > 0) {
            if (y > 0) {
                return x + y;
            } else {
                return x;
            }
        } else {
            return y;
        }
    }

    function forLoop(uint n) external pure returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < n; i++) {
            sum += i;
        }
        return sum;
    }

    function whileLoop(uint n) external pure returns (uint) {
        uint count = 0;
        uint _n = n;
        while (n > 0) {
            _n--;
            count++;
        }
        return count;
    }

    function doWhile(uint n) external pure returns (uint) {
        uint cnt = 0;
         uint _n = n;
        do {
            cnt++;
            _n--;
        } while (n > 0);
        return cnt;
    }

    function breakContinue(uint n) external pure returns (uint) {
        uint acc = 0;
        for (uint i = 0; i < n; i++) {
            if (i % 2 == 0) {
                continue;
            }
            if (i > 10) {
                break;
            }
            acc += i;
        }
        return acc;
    }
}
