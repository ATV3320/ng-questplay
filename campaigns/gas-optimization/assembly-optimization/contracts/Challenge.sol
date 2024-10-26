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
            mstore(0x40, add(copy, and(add(add(len, 0x20), 0x1f), not(0x1f))))
            mstore(copy, len)
            
            // Copy word-sized chunks
            let src := add(array, 0x20)
            let dst := add(copy, 0x20)
            let end := add(src, len)
            
            for {} lt(src, end) {} {
                mstore(dst, mload(src))
                src := add(src, 0x20)
                dst := add(dst, 0x20)
            }
        }
    }
}
