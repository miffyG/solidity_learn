// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 反转字符串
contract Reverse {
    function reverseString(string calldata input) public pure returns (string memory result) {
        bytes memory bytesInput = bytes(input);
        if (bytesInput.length <= 1) {
            result = input;
        }

        bytes memory reversedBytes = new bytes(bytesInput.length);

        for (uint i = 0; i < bytesInput.length; i++) {
            reversedBytes[i] = bytesInput[bytesInput.length - 1 - i];
        }
        result = string(reversedBytes);
    }
}