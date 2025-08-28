// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract RomanConverter {

    uint16[] private _values = [
        1000, 900, 500, 400,
        100, 90, 50, 40,
        10, 9, 5, 4,
        1, 0
    ];

    string[] private _symbols = [
        "M", "CM", "D", "CD",
        "C", "XC", "L", "XL",
        "X", "IX", "V", "IV",
        "I", ""
    ];

    function intToRoman(uint16 num) public view returns (string memory) {
        require(num > 0 && num < 4000, "Number must be between 1 and 39990");

        string memory result = "";
        uint16 i = 0;
        while (num > 0) {
            if (_values[i] <= num) {
                result = string.concat(result, _symbols[i]);
                num -= _values[i];
            } else {
                i++;
            }
        }
        return result;
    }

    function romanToInt(string calldata roman) public pure returns (uint16) {
        bytes memory romanBytes = bytes(roman);
        require(romanBytes.length > 0, "Roman numeral cannot be empty");

        uint16 result = 0;
        uint256 length = romanBytes.length;

        for (uint256 i = 0; i < length; i++) {
            uint16 currentValue = _charToValue(romanBytes[i]);

            if (i < length - 1) {
                uint16 nextValue = _charToValue(romanBytes[i + 1]);
                if (currentValue < nextValue) {
                    result -= currentValue;
                } else {
                    result += currentValue;
                }
            } else {
                result += currentValue;
            }
        }
        require(result > 0 && result < 4000, "Invalid Roman numeral");
        return result;
    }

    function _charToValue(bytes1 char) private pure returns (uint16) {
        if (char == 'I') return 1;
        if (char == 'V') return 5;
        if (char == 'X') return 10;
        if (char == 'L') return 50;
        if (char == 'C') return 100;
        if (char == 'D') return 500;
        if (char == 'M') return 1000;

        // 无效字符 revert
        revert("Invalid Roman numeral character");
    }
}