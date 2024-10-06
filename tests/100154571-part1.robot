*** Settings ***
Library    SeleniumLibrary
Resource   helpers.robot

*** Variables ***
${URL}  http://127.0.0.1:5000

*** Test Cases ***
Normal Game Playthrough
    [Documentation]  Test a normal game playthrough in which users make valid bet.
    # Stimulus: The user opens the game in a browser.
    Open Browser    ${URL}    Chrome
    Maximize Browser Window

    # Stimulus: The user enters a valid player name and starts the game.
    Start Game    MonMon

    # Stimulus: The user selects a valid difficulty level.
    Select Difficulty    easy

    # Stimulus: The user places a valid bet.
    Place Bet    10

    # Stimulus: The user makes valid guesses to find the correct number efficiently.
    Binary Guess Number

    # Stimulus: The user chooses to take the award without doubling.
    Click Element    id=no
    Click Button    xpath=//button[text()='Submit']
    Page Should Contain    You chose not to double

    # Stimulus: The user decides to finish the game.
    Click Element    xpath=//a[text()='Finish and Save Score']
    Page Should Contain    Congratulations MonMon! You've completed the game with 110 bet points.

    Close Browser

Repetitive Incorrect Guesses Leading to Loss
    [Documentation]  Test repetitive incorrect guesses leading to loss.
    # Stimulus: The user opens the game in a browser
    Open Browser    ${URL}    Chrome
    Maximize Browser Window

    # Stimulus: The user enters a valid player name and starts the game.
    Start Game    LosingMeoMeo

    # Stimulus: The user selects a valid difficulty level.
    Select Difficulty    easy

    # Stimulus: The user places all of their bets.
    Place Bet    100

    # Stimulus: The user repeatedly enters the same incorrect number until guesses run out.
    FOR    ${i}    IN RANGE    1    11
        Input Text    id=guess    50
        Click Button    xpath=//button[text()='Submit Guess']
    END
    Wait Until Page Contains    You've run out of guesses.

    # Stimulus: The user doesn’t attempt to save the bet.
    Click Element    id=no
    Click Button    xpath=//button[text()='Submit']

    # Response: The game updates the bet points accordingly, and shows a “Game Over” message.
    Page Should Contain    Start New Game

    Close Browser

*** Keywords ***
Start Game
    [Arguments]    ${player_name}
    Input Text    id=name    ${player_name}
    Click Button    xpath=//button[text()='Start']
    Page Should Contain    Choose Difficulty

Select Difficulty
    [Arguments]    ${difficulty}
    Click Element    id=${difficulty}
    Click Button    xpath=//button[text()='Submit']
    Page Should Contain    Place Your Bet

Place Bet
    [Arguments]    ${bet_amount}
    Input Text    id=bet    ${bet_amount}
    Click Button    xpath=//button[text()='Place Bet']
    Page Should Contain    Guess the Number

