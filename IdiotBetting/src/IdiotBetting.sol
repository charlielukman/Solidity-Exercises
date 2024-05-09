// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract IdiotBettingGame {
    /*
        This exercise assumes you know how block.timestamp works.
        - Whoever deposits the most ether into a contract wins all the ether if no-one 
          else deposits after an hour.
        1. `bet` function allows users to deposit ether into the contract. 
           If the deposit is higher than the previous highest deposit, the endTime is 
           updated by current time + 1 hour, the highest deposit and winner are updated.
        2. `claimPrize` function can only be called by the winner after the betting 
           period has ended. It transfers the entire balance of the contract to the winner.
    */
    uint256 public highestDeposit = 0;
    address public winner;
    uint256 public endTime;

    function bet() public payable {
        if(msg.value > highestDeposit) {
            highestDeposit = msg.value;
            endTime = block.timestamp + 1 hours;
            winner = msg.sender;
        }
    }

    function claimPrize() public {
        require(block.timestamp >= endTime, "Time not up yet");
        require(msg.sender == winner, "Only winner can claim");

        payable(winner).transfer(address(this).balance);
    }
}
