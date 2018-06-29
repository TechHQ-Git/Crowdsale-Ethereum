pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Token.sol";

contract TestToken {
  Token token = Token(DeployedAddresses.Token());

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
}
