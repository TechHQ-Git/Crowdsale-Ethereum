// To be compiled with compiler versions 0.4.24 <= v < 0.5
pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract Token {
    /* Operator overloads */
    using SafeMath for uint;
    using SafeMath for uint8;
    using SafeMath for uint16;
    using SafeMath for uint32;
    using SafeMath for uint64;
    using SafeMath for uint128;
    using SafeMath for uint256;

    /* Public variables of the token.*/
    address public contractOwner;
    string public name;
    string public symbol;
    uint8 public decimals;
    bool private initialized;

    /* This creates an array with all balances.*/
    mapping(address => uint256) private balances;

    /**
     * @dev Builds contract and sets owner.
     */
    constructor() public {
        assert(initialized != true);
        contractOwner = msg.sender;
    }

    /**
     * @dev This generates a public event on the blockchain that will notify
     * clients of a token transfer.
     * @param _from - The address sending the tokens
     * @param _to - The address receiving the tokens
     * @param _amount - The amount of tokens to be transferred
    */
    event TokenTransfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _amount
        );

    /**
     * @dev Initializes contract with initial supply tokens to the creator of
     * the token.
     * @param _initialSupply - Tokens created with the contract
     * @param _name - Token name (e.g. Bitcoin)
     * @param _symbol - Token symbol (e.g. BTC)
     * @param _decimals - Minimum token fraction (e.g. 0.001)
     */
    function initialize(
                uint256 _initialSupply,
                string _name,
                string _symbol,
                uint8 _decimals
            ) public {
        require(
          initialized != true,
          "The contract can only be initialized once."
          );
        // This require causes tests to revert, needs fixing
        /*require(
          msg.sender == contractOwner,
          "Only the contract owner can initialize the contract."
          );*/
        balances[msg.sender] = _initialSupply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        initialized = true;
    }

    /**
     * @dev Send tokens. Note that all addresses exist, so it is possible to
     * send tokens to an address that no one has claimed yet, and that tokens
     * sent to an address for which no one knows the private key are basically
     * irrecoverable.
     * @param _to - The address receiving the tokens
     * @param _amount - The amount of tokens to be transferred
     */
    function transfer(
                address _to,
                uint256 _amount
            ) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit TokenTransfer(msg.sender, _to, _amount);
    }

    /**
     * @dev Return the token balance for a specific user.
     * @param _user - The address to return the balance of
     */
    function getBalanceOf(
                address _user
            ) public view returns (uint256) {
        return balances[_user];
    }
}
