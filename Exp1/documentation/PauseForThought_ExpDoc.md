# Experiment Documentation

## Study/experiment information

### Research question:

Some previous studies have shown that after losing, people tend to take more risks when making decisions. This experiment examines whether inserting a short break in play would reduce the heightened risk-taking tendencies after losing.

### Experiment context:

-	Code: PauseForThought
-	Who: Zhang Chen
-	Where: online study via Prolific.co
-	Credit/paid: Paid
-	When: November 2022

### Brief description of method (provide all info required to understand the headers):

On each trial, participants first press the space bar to start a guessing game. They then see a wheel divided into 10 parts, with 5 of them colored blue and 5 of them colored yellow. The task for participants is to guess after spinning the wheel, whether a black arrow will point at yellow (press F) or at blue (press J). After participants make their guesses, the program spins the wheel. If they guess the color correctly, they win 40 cents; if they guess incorrectly, they lose 40 cents. The outcomes of the guessing games are pre-determined,

Participants then move on to a choice game. In the no delay condition, the start message of the choice game appears immediately. In the delay condition, a text message "Loading the game..." is presented for 3 seconds, before the start message of the choice game appears. In both cases, participants press the space bar to start once the start message is shown. In the choice game, participants are presented with two wheels, with part of the wheels colored green and part colored gray. The green area shows the probability of winning for each option. Two numbers are presented above the wheels, showing the amount of money participants can win for each option. We use the trials from the Vancouver Gambling task for the choice games (see below). Participants again press the F or the J key to choose wheel they want to play with. The chosen wheel is then spun. If the black arrow ends up pointing at green, they win the presented amount. If the black arrow ends up pointing at gray, participants do not win any money.

Participants start with a practice block for the guessing game (4 trials), followed by a practice block for the choice game (4 trials). They then receive 4 experimental blocks (50 trials per block), in which they alternate between the guessing game and the choice game. The experimental blocks thus in total consists of 100 pairs of guessing + choice games. The 10 choice pairs from the Vancouver Gambling task are each repeated 8 times, once in each cell of the 2 (guessing game outcome, win vs. loss) by 2 (delay, yes vs. no) by 2 (choice game options position, HP-LP vs. LP-HP) design. These 80 pairs consist of the experimental pairs. The remaining 20 pairs are catch pairs, in which one option has a higher probability of winning a larger amount than the other option. The catch pairs always contain no delay. The catch pairs are included to check if participants are paying attention to the information in the choice games. The 100 pairs are divided into 4 blocks, such that each block includes 20 experimental pairs and 5 pairs.

Before starting the experimental blocks, participants are told that at the end of the experiment, the program will random pick 4 guessing games and 4 choice games. The money that they have won or lost will be added up, and paid to them as an extra bonus (maximum 1 British pound). If they end up with 0 or a negative total, they do not receive an extra bonus.

Choice pairs used in the experimental trials

| HP probability | HP amount | LP probability | LP amount |
|----------------|-----------|----------------|-----------|
| 0.6            | 10        | 0.4            | 40        |
| 0.7            | 10        | 0.3            | 50        |
| 0.6            | 20        | 0.4            | 50        |
| 0.7            | 10        | 0.3            | 30        |
| 0.6            | 30        | 0.4            | 50        |
| 0.6            | 40        | 0.4            | 50        |
| 0.7            | 20        | 0.3            | 30        |
| 0.7            | 30        | 0.3            | 40        |
| 0.8            | 10        | 0.2            | 20        |
| 0.8            | 20        | 0.2            | 30        |


Choice pairs used in the catch trials

| HP probability | HP amount | LP probability | LP amount |
|----------------|-----------|----------------|-----------|
| 0.6            | 40        | 0.2            | 10        |
| 0.7            | 30        | 0.4            | 20        |
| 0.8            | 50        | 0.3            | 30        |
| 0.8            | 50        | 0.2            | 20        |
| 0.7            | 40        | 0.4            | 10        |


### Apparatus and calibration:

- Apparatus: PC, jsPsych
- Calibration protocol: None

### Data file information:

File Types: Behavioural data files only (CSV).

### Variable labels (headers) and variable coding:

#### Main data from the task (PauseForThought_main_X.csv)

- subject_ID = Prolific ID of participants, will be replaced by a random subject ID after data collection.
- age = age of participant.
- gender = gender of participant. Four levels: male, female, non-binary, or I don't want to say
- nationality = self-reported nationality of participant.
- exp_part = which part of experiment it is, practice_game1 (practice for the guessing game), practice_game2 (practice for the choice game), or exp (experimental blocks that consist of both games).
- block_number = block number, from 1 till 6.
- trial_number = trial number within each block.
- trial_type = in the first two practice blocks, trial type is always "practice". In the experimental blocks, trial type is either "catch" or "exp".
- delay = whether there is a delay between the guessing game and the choice game or not.
- game1_startRT = how quickly participants start a guessing game, in milliseconds.
- game1_color = the colour of the wheel in the guessing game. Always "mixed".
- game1_respKey = which key participants press to indicate their guess, f or j.
- game1_respRT = how quickly participants respond in the guessing game, in milliseconds.
- game1_outcome = the outcome of the guessing game, win or loss.
- game2_delay_premature = the number of premature key presses during the delay period.
- game2_startRT = how quickly participants start the choice game, in milliseconds.
- game2_HP_prob = the probability of winning for the high-probability option in the choice game.
- game2_HP_amount = the amount of cents for the high-probability option in the choice game.
- game2_LP_prob = the probability of winning for the low-probability option in the choice game.
- game2_LP_amount = the amount of cents for the low-probability option in the choice game.
- game2_pos = the left/right position of the two options. HP-LP: high-probability option on left, and low-probability option on right; LP-HP: low-probability on left, and high-probability option on right.
- game2_respKey = which key participants press to indicate their choice in the choice game, f or j.
- game2_respRT = how quickly participants make a choice in the choice game, in milliseconds.
- game2_outcome = whether participants choose the low-probability option (LP) or the high-probability option (HP).
- game2_outcome = the outcome of the choice game, win or no-win.

#### Data on premature responses (PauseForThought_premature_X.csv)

We register the number of key presses during the delay period. This data file provides more detailed information.

- subject_ID = Prolific ID of participants, will be replaced by a random subject ID after data collection.
- block_number = block number, from 1 till 6.
- trial_number = trial number within each block.
- phase = during which phase of the task does the response occur? In this case, always "delay".
- response_number = in case participants make multiple responses during the delay, the responses are numbered from 1, 2, ... in the order of occurring.
- key = the key pressed.
- rt = when each key is pressed, counting from the start of the delay period, in milliseconds.


### Quality control measures
None.

### Additional documents
None.
