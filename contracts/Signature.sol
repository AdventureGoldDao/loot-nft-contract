pragma solidity ^0.6.0;


import "@openzeppelin/contracts/utils/Strings.sol";

contract Signature {
    using Strings for bool;
    using Strings for uint;
    using Strings for address;
    using Strings for string;

    function verify(
        address _to,
        uint _nonce,
        address contractAddress,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 messageHash = keccak256(abi.encodePacked(_to, _nonce, contractAddress));
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);
        return ecrecover(messageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

    }
}
