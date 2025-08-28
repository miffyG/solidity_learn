// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ArrayMerger {
    // 将两个有序数组合并为一个有序数组
    function mergeSortedArrays(uint256[] calldata arr1, uint256[] calldata arr2) public pure returns (uint256[] memory mergedArr) {
        uint256 len1 = arr1.length;
        uint256 len2 = arr2.length;
        uint256 mergedLen = len1 + len2;
        mergedArr = new uint256[](mergedLen);
        uint256 i = 0;
        uint256 j = 0;
        uint256 k = 0;

        while(i < len1 && j < len2) {
            if (arr1[i] <= arr2[j]) {
                mergedArr[k] = arr1[i];
                i++;
            } else {
                mergedArr[k] = arr2[j];
                j++;
            }
            k++;
        }
        while (i < len1) {
            mergedArr[k] = arr1[i];
            i++;
            k++;
        }
        while (j < len2) {
            mergedArr[k] = arr2[j];
            j++;
            k++;
        }
    }
}