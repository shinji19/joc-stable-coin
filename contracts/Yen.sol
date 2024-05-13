pragma solidity >=0.7.0 <0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @dev Yen token.
 */
contract Yen is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 private _nextTokenId;
    mapping(address => bool) public _activeAccounts;

    /**
     * @dev Emitted when `account` activated.
     *
     * Note that `value` may be zero.
     */
    event Activate(address indexed account);

    /**
     * @dev Initializes the contract ERC721 and Ownable.
     */
    constructor(address defaultAdmin) ERC20("Japanese yen", "YEN") {
        _setupRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
    }
    
    /**
    * @dev Throws if account has not role.
    */
    modifier _hasRole(bytes32 role, address account) {
        require(hasRole(role, account), "account has not role.");
        _;
    }

    /**
    * @dev Throws if account not activated.
    */
    modifier activated(address account) {
        require(_activeAccounts[account], "account not activated.");
        _;
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     */
    function mint(address account, uint256 value) public
        _hasRole(MINTER_ROLE, msg.sender)
        activated(account)
    {
        _mint(account, value);
    }

    /**
     * @dev Activate account to receive and transfer token.
     */
    function activate() public {
        _activeAccounts[msg.sender] = true;
        emit Activate(msg.sender);
    }

    /**
     * @dev Transfer token.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal override activated(recipient) {
        super._transfer(sender, recipient, amount);
    }
}
