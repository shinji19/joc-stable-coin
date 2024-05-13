pragma solidity >=0.7.0 <0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @dev Yen NFT.
 */
contract YenNotesAndCoins is ERC721, ERC721Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 private _nextTokenId;
    uint256[] public _valueKinds;
    mapping(uint256 => uint256) public _values;

    /**
     * @dev Initializes the contract ERC721 and Ownable.
     */
    constructor(address defaultAdmin) ERC721("Japanese yen notes and coins", "YENNC"){
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
    * @dev Throws if value is not mintable.
    */
    modifier isMintableValue(uint256 value) {
        bool mintable = false;
        for(uint256 i = 0; i < _valueKinds.length; i++) {
            if (_valueKinds[i] == value) {
                mintable = true;
                break;
            }
        }
        require(mintable, "value is not mintable.");
        _;
    }

    /**
     * @dev Update mintable value.
     *
     * Requirements:
     *
     * - `value` must exist.
     */
    function updateValueKinds(uint256[] memory value) public _hasRole(DEFAULT_ADMIN_ROLE, msg.sender) {
        _valueKinds = value;
    }

    /**
     * @dev Mint and transfer.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address. If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     * - `value` is FT amount.
     */
    function mint(address to, uint256 value) public
        _hasRole(MINTER_ROLE, msg.sender)
        isMintableValue(value)
    {
        _safeMint(to, _nextTokenId);
        _values[_nextTokenId] = value;
        _nextTokenId++;
    }

    /**
     * @dev Get value.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getValue(uint256 tokenId) public view returns(uint256) {
        return _values[tokenId];
    }
}
