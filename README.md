# Smart-Contract
# 🧠 BlockQuiz – A Blockchain-Powered Quiz Game

Welcome to **BlockQuiz**, a decentralized quiz game built on the Ethereum blockchain using **Solidity**.  
Players can test their knowledge, answer on-chain questions, and earn rewards — all transparently on the blockchain.

---

## 🚀 Project Description

**BlockQuiz** is an educational and entertaining blockchain application designed for beginners exploring **Solidity** and **smart contract development**.

With BlockQuiz, you can:
- Learn how to write and deploy smart contracts.
- Understand how data (like quiz questions and answers) is stored on-chain.
- Experiment with reward systems, ownership logic, and blockchain transparency.

---

## 💡 What It Does<img width="1920" height="1080" alt="Screenshot 2025-10-29 140612" src="https://github.com/user-attachments/assets/796d7a4d-63d6-4d7a-9e7c-0bd718e66087" />


1. **The Owner (Quiz Creator)** deploys the contract and adds quiz questions with answers and rewards.  
2. **Players** interact with the smart contract by submitting their answers directly through the blockchain.  
3. The contract automatically checks if the answer is correct.  
4. If correct — the player earns points (or ETH if extended).  
5. Every question, answer, and score is recorded on the blockchain — no central database required.

---

## ✨ Features

- 🧩 **On-Chain Questions** – All quiz questions are stored securely on the blockchain.  
- 🏆 **Reward Mechanism** – Players earn points or ETH for correct answers.  
- 🔒 **Owner-Only Controls** – Only the contract owner can add new questions or withdraw funds.  
- 🪶 **Beginner-Friendly Code** – Clean and well-commented Solidity for easy understanding.  
- 🌍 **Transparent & Fair** – Every action is visible and verifiable on the blockchain.  
- ⚙️ **Upgradeable** – Future features like NFTs, token rewards, or leaderboards can be added.

---

## 🔗 Deployed Smart Contract

- **Network:** Sepolia Testnet  
- **Deployment Transaction:** [View on Celoscan](https://sepolia.celoscan.io/tx/0x07af4c1498e00ac6709b5f4419ac3e442a4dfffe68f2948ca03a54ee40b4f0a7)  
- **Smart Contract Address:** `XXX`  
- **View on Etherscan:** [https://etherscan.io/address/XXX](https://etherscan.io/address/XXX)

---

## 🧱 Smart Contract Code

```solidity
//paste // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockQuiz {
    // The owner (quiz creator)
    address public owner;

    // Struct for each question
    struct Question {
        string questionText;
        string correctAnswer;
        uint reward; // in wei (smallest ETH unit)
        bool isActive;
    }

    // Array of questions
    Question[] public questions;

    // Mapping to track player scores
    mapping(address => uint) public scores;

    // Events
    event QuestionAdded(uint questionId, string questionText, uint reward);
    event Answered(address player, uint questionId, bool isCorrect, uint rewardWon);

    // Constructor: sets owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Add a new question (only owner)
    function addQuestion(string memory _questionText, string memory _correctAnswer, uint _reward) public onlyOwner {
        questions.push(Question(_questionText, _correctAnswer, _reward, true));
        emit QuestionAdded(questions.length - 1, _questionText, _reward);
    }

    // Player submits an answer
    function answerQuestion(uint _questionId, string memory _answer) public {
        require(_questionId < questions.length, "Invalid question ID");
        Question storage q = questions[_questionId];
        require(q.isActive, "Question is not active");

        // Compare the answer
        if (keccak256(abi.encodePacked(_answer)) == keccak256(abi.encodePacked(q.correctAnswer))) {
            // Correct answer
            scores[msg.sender] += q.reward;
            q.isActive = false; // disable question after correct answer
            emit Answered(msg.sender, _questionId, true, q.reward);
        } else {
            // Wrong answer
            emit Answered(msg.sender, _questionId, false, 0);
        }
    }

    // Get total number of questions
    function getQuestionCount() public view returns (uint) {
        return questions.length;
    }

    // Get question text (so front-end can display it)
    function getQuestion(uint _id) public view returns (string memory) {
        require(_id < questions.length, "Invalid question ID");
        return questions[_id].questionText;
    }

    // Withdraw any leftover ETH (if used for rewards)
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Allow contract to receive ETH (optional for funding rewards)
    receive() external payable {}
}
your code

