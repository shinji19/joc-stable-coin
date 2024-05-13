pragma solidity >=0.7.0 <0.8.0;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721WithValueMintableBurnable is IERC721 {
    function mint(address account, uint256 value) external;
    function burn(uint256 tokenId) external;
    function getValue(uint256 tokenId) external view returns(uint256);
}
