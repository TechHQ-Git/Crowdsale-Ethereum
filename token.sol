// To be compiled with compiler versions 0.4 <= v < 0.5
pragma solidity ^0.4.0;

contract Token {
    /* Public variables of the token.*/
    address owner = msg.sender;
    string public name;
    string public symbol;
    uint8 public decimals;
    bool initialized;
    
    /* This creates an array with all balances.*/
    mapping(address => uint256) balances;
    
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
    constructor (
                uint256 _initialSupply,
                string _name,
                string _symbol,
                uint8 _decimals
            ) public {
        assert(initialized != true);
        require(owner == msg.sender);
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
    function transfer (
                address _to, 
                uint256 _amount
            ) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;  // Use SafeMath
        balances[_to] = balances[_to] + _amount;  // Use SafeMath
        emit TokenTransfer(msg.sender, _to, _amount);
    }
}