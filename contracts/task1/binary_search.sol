// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BinarySearch {
    // 二分查找 在一个有序数组中查找目标值
    function binarySearch(uint256[] calldata arr, uint256 target) public pure returns (bool found, uint256 index) {
        if (arr.length == 0) {
            return (false, 0);
        }
        int256 l = 0;
        int256 r = int256(arr.length) - 1;
        while (l <= r) {
            int256 m = l + (r - l) / 2;
            uint256 um = uint256(m);
            if (arr[um] == target) {
                return (true, um);
            } else if (arr[um] < target) {
                l = m + 1;
            } else {
                r = m - 1;
            }
        }
        return (false, 0);
    }
}