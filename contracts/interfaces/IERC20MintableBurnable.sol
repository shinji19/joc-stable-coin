pragma solidity >=0.7.0 <0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20MinableBurnable is IERC20 {
    function mint(address account, uint256 value) external;
    function burnFrom(address account, uint256 amount) external;
}
