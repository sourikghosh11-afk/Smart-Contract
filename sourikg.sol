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
