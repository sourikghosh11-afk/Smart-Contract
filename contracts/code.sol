// SPDX-License-Identifier: MIT
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
