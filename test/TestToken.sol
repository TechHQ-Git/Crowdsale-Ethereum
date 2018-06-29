pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Token.sol";

contract TestToken {
  Token token = Token(DeployedAddresses.Token());

  uint expectedInitialSupply = 100;
  uint8 expectedDecimals = 16;
  // Arrays (including strings) and structs are implicit "storage", it seems.
  string expectedName = "TestToken";
  string expectedSymbol = "TTK";


  // Testing the constructor() function
  function testConstructor() public {
    address expected = msg.sender;
    address returnedOwner = token.owner();
    Assert.equal(
    	expected,
    	returnedOwner,
    	"A contract should be owned by its creator"
  	   );
  }

  // Testing the initial supply through initialize() function
  function testInitializeSupply() public {
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
  }

  // Testing the decimals through initialize() function
  function testInitializeDecimals() public {
    Assert.equal(
      uint256(expectedDecimals), // TRUFFLE CAN'T TEST UINT8!!!
      uint256(token.decimals()),
      "The TestToken should have support for 16 decimals."
      );
  }

  // Testing the name through initialize() function
  function testInitializeName() public {
    Assert.equal(
      expectedName,
      string(token.name()),
      "The name of the token should be \"TestToken\"."
      );
  }

  // Testing the symbol through initialize() function
  function testInitializeSymbol() public {
    Assert.equal(
      expectedSymbol,
      string(token.symbol()),
      "The symbol of the token should be \"TTK\"."
      );
  }
}
