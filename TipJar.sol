// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title TipJar
contract TipJar is Ownable {
    mapping(address => uint256) public totalTippedMap;

    uint256 public totalReceived;

    event Tipped(address indexed from, uint256 amount, uint256 newTotal);

    constructor() Ownable(msg.sender) {}

    function deposit() public payable {
        require(msg.value > 0, "TipJar: deposit must be > 0");

        totalTippedMap[msg.sender] += msg.value;
        totalReceived += msg.value;

        emit Tipped(msg.sender, msg.value, totalTippedMap[msg.sender]);
    }

    function totalTipped(address tipper) external view returns (uint256) {
        return totalTippedMap[tipper];
    }

    function withdraw() external onlyOwner {
        uint256 bal = address(this).balance;
        require(bal > 0, "TipJar: nothing to withdraw");

        (bool ok, ) = owner().call{value: bal}("");
        require(ok, "TipJar: withdraw transfer failed");
    }

    receive() external payable {
        deposit();
    }
}
