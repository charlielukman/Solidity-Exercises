// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TimelockEscrow {
    address public seller;

    struct Escrow {
        uint256 amount;
        uint256 endTime;
    }

    mapping(address => Escrow) public escrows;
    /**
     * The goal of this exercise is to create a Time lock escrow.
     * A buyer deposits ether into a contract, and the seller cannot withdraw it until 3 days passes. Before that, the buyer can take it back
     * Assume the owner is the seller
     */

    constructor() {
        seller = msg.sender;
    }

    // creates a buy order between msg.sender and seller
    /**
     * escrows msg.value for 3 days which buyer can withdraw at anytime before 3 days but afterwhich only seller can withdraw
     * should revert if an active escrow still exist or last escrow hasn't been withdrawn
     */
    function createBuyOrder() external payable {
        require(escrows[msg.sender].amount == 0, "Active escrow still exists");

        escrows[msg.sender] = Escrow(msg.value, block.timestamp + 3 days);
    }

    /**
     * allows seller to withdraw after 3 days of the escrow with @param buyer has passed
     */
    function sellerWithdraw(address buyer) external {
        require(msg.sender == seller, "Only the seller can withdraw");
        require(block.timestamp >= escrows[buyer].endTime, "not yet 3 day passed");

        uint256 amount = escrows[buyer].amount;
        escrows[buyer].amount = 0;
        payable(seller).transfer(amount);
    }

    /**
     * allowa buyer to withdraw at anytime before the end of the escrow (3 days)
     */
    function buyerWithdraw() external {
        require(block.timestamp < escrows[msg.sender].endTime, "3 days already passed, cannot withdraw");

        uint256 amount = escrows[msg.sender].amount;
        escrows[msg.sender].amount = 0;
        payable(msg.sender).transfer(amount);
    }

    // returns the escrowed amount of @param buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        return escrows[buyer].amount;
    }
}
