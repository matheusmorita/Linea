// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BetPlatform {
    address public owner;
    uint256 public winningNumber;
    mapping(address => uint256) public userBets;

    event BetPlaced(address indexed user, uint256 number);
    event Winner(address indexed user, uint256 winningNumber);

    constructor() {
        owner = msg.sender;
        winningNumber = 0; // Initialize the winning number
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function placeBet(uint256 number) external payable {
        require(number >= 1 && number <= 10, "Number must be between 1 and 10");
        require(msg.value > 0, "Bet amount must be greater than 0");

        userBets[msg.sender] = number;
        emit BetPlaced(msg.sender, number);
    }

    function setWinningNumber(uint256 number) external onlyOwner {
        require(number >= 1 && number <= 10, "Winning number must be between 1 and 10");

        winningNumber = number;
    }

    function declareWinner() external onlyOwner {
        require(winningNumber != 0, "Winning number has not been set yet");

        if (userBets[msg.sender] == winningNumber) {
            payable(msg.sender).transfer(address(this).balance);
            emit Winner(msg.sender, winningNumber);
        }
    }
}
