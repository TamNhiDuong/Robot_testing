*** Settings ***
Library    SeleniumLibrary
Resource   helpers.robot

*** Variables ***
${URL}  http://127.0.0.1:5000

*** Test Cases ***
Invalid Name Input
    [Documentation]  Test invalid player name inputs and verify the game handles them correctly.
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    Log    Opened Browser for Invalid Name Input Test

    # Stimulus 1: Start game with a invalid player name
    Start Game    ${EMPTY}    Name cannot be empty. Please enter a valid name.
    
    Close Browser

Invalid Difficulty Selection
    [Documentation]  Test invalid difficulty selection and verify the game displays an error.
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    Log    Opened Browser for Invalid Difficulty Selection Test

    # Stimulus 1: Start the game with a valid name
    Start Game    MonMon    Choose Difficulty

    # Stimulus 2: Select invalid difficulty
    Proceed Without Difficulty Selection

    Close Browser

Invalid Bet Input
    [Documentation]  Test invalid bet inputs and verify the game displays appropriate error messages.
    Open Browser    ${URL}    Chrome
    Maximize Browser Window

    # Stimulus 1: Start game with a valid player name
    Start Game    MonMon    Choose Difficulty

    # Stimulus 2: Select a difficulty level
    Select Difficulty    easy    Place Your Bet

    # Check if the page loaded correctly and the bet input is visible
    Wait Until Element Is Visible    id=bet    10 seconds
    Log    The bet input element is visible.

    # Stimulus 3: Place invalid bets
    # Try a negative bet amount
    Place Bet    -10    Invalid bet amount. Enter a value between 1 and 100.

    # Try a zero bet amount
    Place Bet    0    Invalid bet amount. Enter a value between 1 and 100.

    # Try a bet amount bigger than upper boundary
    Place Bet    1000    Invalid bet amount. Enter a value between 1 and 100.

    Close Browser

Invalid Guess Input
    [Documentation]  Test invalid guess inputs and verify the game handles them correctly.
    Open Browser    ${URL}    Chrome
    Maximize Browser Window

    # Stimulus 1: Start game with a valid player name
    Start Game    MonMon    Choose Difficulty

    # Stimulus 2: Select a difficulty level
    Select Difficulty    easy    Place Your Bet

    # Stimulus 3: Enter a valid bet amount
    Place Bet    10    Guess the Number

    # Check if the guess input element is visible
    Wait Until Element Is Visible    id=guess    10 seconds
    Log    The guess input element is visible.

    # Try a guess bigger than upper boundary
    Place Guess    105    Invalid guess. Please guess a number between 1 and 100.

    # Try a guess lower than bottom boundary
    Place Guess    -105    Invalid guess. Please guess a number between 1 and 100.

    # Try a non-numeric guess
    Place Guess    one    Invalid guess. Please guess a number between 1 and 100.

    Close Browser

*** Keywords ***
Start Game
    [Arguments]    ${player_name}    ${expected_message}
    Input Text    id=name    ${player_name}
    Click Button    xpath=//button[text()='Start']
    Page Should Contain    ${expected_message}

Select Difficulty
    [Arguments]    ${difficulty}    ${expected_message}
    Click Element    id=${difficulty}
    Click Button    xpath=//button[text()='Submit']
    Page Should Contain    ${expected_message}

Proceed Without Difficulty Selection
    Click Button    xpath=//button[text()='Submit']
    Page Should Contain    Please select a difficulty level.

Place Bet 
    [Arguments]    ${bet_amount}    ${expected_message}
    Input Text    id=bet    ${bet_amount}
    Click Button    xpath=//button[text()='Place Bet']
    Page Should Contain    ${expected_message}

Place Guess 
    [Arguments]    ${guess_amount}    ${expected_message}
    Input Text    id=guess    ${guess_amount}
    Click Button    xpath=//button[text()='Submit Guess']
    Page Should Contain    ${expected_message}

    