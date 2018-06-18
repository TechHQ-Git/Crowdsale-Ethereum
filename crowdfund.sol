// To be compiled with compiler versions 0.4 <= v < 0.5
pragma solidity ^0.4.0;

// Interface to the token transfer function.
interface Token {
    function transfer(
            address _to, 
            uint256 _amount
        ) external;

}

/**
 * @dev Contract with a beneficiary to receive the funds raised, a funding goal, a 
 * deadline, a token to use, a token price in ether and a ledger for the token 
 * balances of all investors.
 */
contract Crowdsale {
    // Crowdsale parameters
    address beneficiary;
    uint256 fundingGoal;
    uint256 fundsRaised;
    uint256 deadline;
    address tokenReward;
    uint256 tokenPrice;
    mapping(address => uint256) balanceOf;

    // Control variables
    bool crowdsaleClosed;
    bool goalAchieved;

    // Event to notify the outcome of the crowdsale
    event crowdsaleOutcome(
        bool _goalReached, 
        address _beneficiary, 
        uint256 _amount
        );
    // Event to notify that funds have been transferred (Redundant).
    event fundsTransferred(
        address _to, 
        uint256 _amount,
        bool isContribution
        );
    
    /**
     * @dev Constructor function, which sets up the crowdsale variables. The 
     * user creating the crowdsale must deposit in the contract the tokens to 
     * sell to investors. 
     * @param _beneficiary Address to receive the funds raised if the crowdsale
     * is successful.
     * @param _fundingGoal Ether amount to reach in the crowdsale.
     * @param _deadline Time in minutes to reach the funding goal.
     * @param _tokenReward Address for the token to use in the crowdsale to 
     * track the amounts invested by each participant.
     * @param _tokenPrice Ether amount required to buy each crowdsale token from
     * the crowdsale contract.
     */
    constructor (
            address _beneficiary,
            uint256 _fundingGoal, 
            uint256 _deadline, 
            address _tokenReward, 
            uint256 _tokenPrice
        ) public {
        beneficiary = _beneficiary;
        fundingGoal = _fundingGoal;
        deadline = _deadline;
        tokenReward = Token(_tokenReward); 
        tokenPrice = _tokenPrice;
    }
    
    
    /**
     * @dev Fallback function - The function without name is the default 
     * function that is executed when someone sends funds to a contract.
     */
    function () payable external {
        require(!crowdsaleClosed);
        balanceOf[msg.sender] = msg.value;
        fundsRaised += msg.value;
        // The transfer function doesn't seem to be imported through the 
        // interface with the right number of arguments.
        //tokenReward.transfer(msg.sender, msg.value / tokenPrice);
        emit fundsTransferred(msg.sender, msg.value / tokenPrice, true);
    } 
    
    /**
     * @dev Modifier that checks that a function is being called after the 
     * deadline.
     */
    modifier afterDeadline() {
        require (now >= deadline);
        _;
    }
    
    /**
     * @dev Function that checks if the goal or time limit has been reached and 
     * emits the appropriate event.
     */
    function closeCrowdsale() afterDeadline public {
        if (fundsRaised >= fundingGoal) goalAchieved = true;
        emit crowdsaleOutcome(goalAchieved, beneficiary, fundsRaised);
        crowdsaleClosed = true;
    }
    
    /**
     * @dev Function that allows the investors to recover their funding if the 
     * deadline was passed without reaching the funding goal. Alternatively it 
     * allows the beneficiary to retrieve the funds if the deadline was passed 
     * and the funding goal achieved.
     */ 
    function safeWithdrawal() external {
        require (crowdsaleClosed == true);
        if (
            msg.sender == beneficiary && 
            goalAchieved == true
            ) {
            if (msg.sender.send(fundsRaised)) {
                emit fundsTransferred(beneficiary, fundsRaised, false);
            }
        }
        if (
            msg.sender != beneficiary && 
            goalAchieved != true
            ) {
            // The condition below is unsafe, it should be atomic
            if (msg.sender.send(balanceOf[msg.sender])) {
                balanceOf[msg.sender] = 0;
                emit fundsTransferred(msg.sender, balanceOf[msg.sender], false);
            }
        }
    }
}