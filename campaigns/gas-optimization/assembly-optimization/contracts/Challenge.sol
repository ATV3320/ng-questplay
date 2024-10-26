// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Challenge {

    /**
     * @notice Returns a copy of the given array in a gas efficient way.
     * @dev This contract will be called internally.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function copyArray(bytes memory array) 
        internal 
        pure 
        returns (bytes memory copy) 
    {
        assembly {
            let len := mload(array)
            copy := mload(0x40)
            mstore(copy, len)
            
            switch gt(len, 64)
            case 0 {
                // For small arrays (<=64 bytes), unroll the loop
                mstore(add(copy, 32), mload(add(array, 32)))
                mstore(add(copy, 64), mload(add(array, 64)))
                mstore(add(copy, 96), mload(add(array, 96)))
            }
            default {
                // For larger arrays, use a loop
                let src := add(array, 32)
                let dst := add(copy, 32)
                let end := add(src, len)
                
                for {} lt(src, end) {} {
                    mstore(dst, mload(src))
                    src := add(src, 32)
                    dst := add(dst, 32)
                }
            }
            
            // Update the free memory pointer
            mstore(0x40, and(add(add(copy, add(len, 32)), 31), not(31)))
        }
    }
}
