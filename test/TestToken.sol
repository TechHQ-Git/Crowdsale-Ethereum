pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Token.sol";

/**
 * @dev Proxy contract for testing throws
 * @author https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
 */
contract ThrowProxy {
  address public target;
  bytes data;

  constructor() public {}

  // Prime the data using the fallback function.
  // Remember to set the target first with setTarget().
  function() public {
    data = msg.data;
  }

  // Set the target contract to test throws from
  function setTarget(address _target) public {
    target = _target;
  }

  function execute() public returns (bool) {
    return target.call(data);
  }
}

contract TestToken {
  Token token = Token(DeployedAddresses.Token());

  // Testing the constructor() function
  function testConstructor() public {
    address expected = msg.sender;
    address returnedOwner = token.contractOwner();
    Assert.equal(
    	expected,
    	returnedOwner,
    	"A contract should be owned by its creator"
  	   );
  }

  // Testing the initial supply through initialize() function
  function testInitialize() public {
      uint expectedInitialSupply = 100;
      uint8 expectedDecimals = 16;
      // Strings are arrays and therefore storage by default, I think.
      string memory expectedName = "TestToken";
      string memory expectedSymbol = "TTK";

    token.initialize(
      expectedInitialSupply,
      expectedName,
      expectedSymbol,
      expectedDecimals
      );

    Assert.equal(
      expectedInitialSupply,
      uint256(token.getBalanceOf(this)), // Truffle needs to be told the type
      "The owner of the contract should have 100 TTK."
      );

    Assert.equal(
      uint256(expectedDecimals), // TRUFFLE CAN'T TEST UINT8!!!
      uint256(token.decimals()),
      "The TestToken should have support for 16 decimals."
      );

    Assert.equal(
      expectedName,
      string(token.name()),
      "The name of the token should be \"TestToken\"."
      );

    Assert.equal(
      expectedSymbol,
      string(token.symbol()),
      "The symbol of the token should be \"TTK\"."
      );
  }

  // Use the ThrowProxy to test that token.initialize reverts if the token has
  // already been initialized.
  function testInitializeOnlyOnce() public {
    uint expectedInitialSupply = 200;
    uint8 expectedDecimals = 32;
    string memory expectedName = "BrokenToken";
    string memory expectedSymbol = "BTK";

    ThrowProxy throwProxy = new ThrowProxy();
    // Set token as the contract to forward requests to.
    throwProxy.setTarget(address(token));
    // Prime the proxy.
    Token(address(throwProxy)).initialize(
      expectedInitialSupply,
      expectedName,
      expectedSymbol,
      expectedDecimals
      );
    bool result = throwProxy.execute.gas(800000)();

    Assert.isFalse(result, "Should be false, as it should throw.");
  }

  // Testing the transfer of tokens from the owner to a random address.
  // The address receiving the accounts is generated with ganache-cli using the
  // seed "hello". Be careful of not testing this where you would burn the tokens
  // Public: 0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1
  // Truffle requires addresses to be checksummed with mixed upper/lowercase
  // https://github.com/ethereum/EIPs/issues/55
  function testTransfer() public {
    address to = 0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1;
    uint256 expectedBalance = 1;
    token.transfer(to,1);
    Assert.equal(
      expectedBalance,
      uint256(token.getBalanceOf(to)),
      "The balance of 0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1 should be 1."
      );
  }
}
