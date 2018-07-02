pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Crowdsale.sol";

contract TestCrowdsale {

  Crowdsale crowdsale = Crowdsale(DeployedAddresses.Crowdsale());

  // Testing the constructor() function
  function testConstructor() public {
    address expected = msg.sender;
    address returnedOwner = crowdsale.owner();

    Assert.equal(
    	expected,
    	returnedOwner,
    	"A contract should be owned by its creator"
  	   );
  }
}
