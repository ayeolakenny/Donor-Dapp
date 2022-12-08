// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Donors {
    mapping(address => uint) public paymentsOf;
    mapping(address => uint) public donationsBy;

    address payable public owner;
    uint public balance;
    uint public withdrawn;
    uint public totalDonations;
    uint public totalWithdrawals;

    event Donation(uint id, address indexed from, uint amount, uint timestamp);

    event Withdrawal(uint id, address indexed to, uint amount, uint timestamp);

    constructor() {
        owner = payable(msg.sender);
    }

    function donate() public payable {
        require(msg.value > 0, "Insufficient amount");

        paymentsOf[msg.sender] += msg.value;
        donationsBy[msg.sender] += 1;
        balance += msg.value;
        totalDonations++;

        emit Donation(totalDonations, msg.sender, msg.value, block.timestamp);
    }

    function withdraw(uint amount) public returns (bool) {
        require(msg.sender == owner, "Unauthorized personnel");
        require(balance >= amount, "Insufficient balance");

        balance -= amount;
        withdrawn += amount;
        totalWithdrawals++;
        owner.transfer(amount);

        emit Withdrawal(totalWithdrawals, msg.sender, amount, block.timestamp);

        return true;
    }
}
