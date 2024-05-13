pragma solidity >=0.7.0 <0.8.0;

import "./interfaces/IERC20MintableBurnable.sol";
import "./interfaces/IERC721WithValueMintableBurnable.sol";

contract Converter {
    address _ft;
    address _nft;

    /**
     * @dev Initializes the contract address.
     */
    constructor(address ft, address nft) {
        _ft = ft;
        _nft = nft;
    }

    /**
     * @dev burn ft and mint nft
     */
    function ft2nft(uint256 value) public {
        IERC20MinableBurnable(_ft).burnFrom(msg.sender, value);
        IERC721WithValueMintableBurnable(_nft).mint(msg.sender, value);
    }

    /**
     * @dev burn nft and mint ft
     */
    function nft2ft(uint256 tokenId) public {
        uint256 tokenValue = IERC721WithValueMintableBurnable(_nft).getValue(tokenId);
        IERC721WithValueMintableBurnable(_nft).burn(tokenId);
        IERC20MinableBurnable(_ft).mint(msg.sender, tokenValue);
    }
}
