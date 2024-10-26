// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {

    uint256 immutable _SKIP;

    constructor(uint256 skip) {
        _SKIP = skip;
    }

    /** 
     * @notice Returns the sum of the elements of the given array, skipping any SKIP value.
     * @param array The array to sum.
     * @return sum The sum of all the elements of the array excluding SKIP.
     */
    function sumAllExceptSkip(uint256[] calldata array) public view returns (uint256 sum) {
        uint256 skip = _SKIP;

        assembly {
            let end := add(array.offset, mul(array.length, 0x20)) // End pointer of array in calldata
            let ptr := array.offset // Starting pointer of array in calldata

            for { } lt(ptr, end) { ptr := add(ptr, 0x20) } {
                let val := calldataload(ptr) // Loading current array element
                if eq(val, skip) { continue } //skip

                // Perform unchecked addition and update sum
                sum := add(sum, val)
                if lt(sum, val) { revert(0, 0) } // Revert on overflow
            }
        }
    }
}
