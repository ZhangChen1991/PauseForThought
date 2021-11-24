# Experiment Documentation


## Study/experiment information

### Research question:

After failing to obtain rewards in risky decision-making, such as when losing money in gambling, people tend to move on to the next decision more quickly. They sometimes also tend to take more risks after a loss. Forcing people to take a short break after a loss has been proposed to reduce the heightened risk-taking tendency, but the empirical evidence for this claim has been lacking. In the current experiment, we will explore the effect of inserting a short pause on subsequent risk-taking.

### Experiment context:

-	Code: PauseForThought
-	Who: Zhang Chen
-	Where: online study via the Sona system of UGent
-	Credit/paid: Credit
-	When: December 2021

### Brief description of method (provide all info required to understand the headers):

In the task, participants alternate between two types of games, the guessing game and the choice game. We consider one pair of a guessing game and a choice game as one 'trial', although from the perspective of the participants, these are two independent games. The task consists of 125 trials, or 250 games, with 125 guessing games and 125 choice games.

Participants first need to press the space bar to initiate a guessing game. The guessing game consists of two types of trials. On the neutral trials, participants see a card that is either completely yellow or completely blue. Their task is to indicate the colour of the presented card, by pressing either F (for blue) or J (for yellow). Participants cannot win or lose points on these trials. These trials thus constitute the neutral outcomes. On the remaining trials, the win/loss trials, participants see a card that is half yellow and half blue. Their task is to guess the colour of the other side, again by pressing either F (for blue) or J (for yellow). If they guess correctly, they win 40 points; if they guess incorrectly, they lose 40 points. Unbeknownst to the participants, the outcomes of the guessing games are all pre-determined, with each outcome (neutral, win, or loss) occurring equally often (1/3 of the time). We thus use the guessing games to expose participants to different outcomes.

Participants then press the space bar to move on to a choice game. Half of the time, the choice game commences immediately after participants press the space bar. The remaining half of the time, however, a wait period of 5 seconds is inserted, with the message "Please wait..." presented in the middle of the screen. Each cell of the 3 (outcome of the guessing game, neutral, win vs. loss) by 2 (pause vs. no pause) design contains 20 trials. Note the 5 catch trials (see below) are not included in this table.

In the choice game, participants are presented with two pie charts, with the amounts of points presented above each pie chart. One pie chart is completely green, and stands for the non-gamble option. If participants choose this option, they receive the guaranteed amount for sure. The other pie chart is partly green and partly red, and stands for the gamble option. The area of the green part indicates the chance of winning. If participants choose the gamble option, there is a chance for them to receive a larger number of points, or nothing. The expected value of the gamble option is the same with the guaranteed amount of the non-gamble option. As an attention check, we include 5 catch games (trial 25, 50, 75, 100, 125), in which the non-gamble option has a larger win amount than the gamble option. Participants again press the F or the J key to make a decision. The left/right position of the two options is randomised across games.

There are 20 different choice trials, with the expected values 20, 30, 40, 50, 60 points and the winning probabilities 2/3, 1/2, 1/3, 1/4. These 16 trials are each presented once in the 'Pause' cells in the table above, and repeated twice for the 'No Pause' cells. In addition to recording the key pressed and the reaction time at each stage, we additionally record responses made with either F, J and the space bar during periods where participants are not supposed to respond, such as the 5-second wait period before starting a choice game.

### Apparatus and calibration:

- Apparatus: PC, jsPsych
- Calibration protocol: None

### Data file information:

File Types: Behavioural data files only (CSV).

### Variable labels (headers) and variable coding:

#### Data from the guessing game (PauseForThought_main_X.csv)

- subject_ID = subject ID of participants.
- age = age of participant.
- gender = gender of participant. Four levels: male, female, non-binary, or I don't want to say
- nationality = self-reported nationality of participant.
- task = task name, guessing.
- trial_number = trial number, from 1 till 125.
- trial_condition = whether the current trial is an 'experimental' trial or a 'catch' trial.
- game1_outcome = the outcome of the guessing game, win, loss, or non-gamble.
- delay = whether there is a delay between the guessing game and the choice game.
- game1_color_front = the colour of the front side of the card presented in the guessing game. On win/loss trials, the front side is mixed (with both yellow and blue); on neutral trials, the front side is either blue or yellow.
- game1_color_back = the colour of the back side of the card after it is flipped in the guessing game, blue or yellow.
- game1_startRT = how quickly participants start a guessing game, in milliseconds.
- game1_respKey = which key participants press to indicate their guess, f or j.
- game1_respRT = how quickly participants respond in the guessing game, in milliseconds.
- premature_game1_start = the number of premature responses (i.e., pressing F or J) before starting the guessing game.
- premature_game1_choice = the number of premature responses (e.g., press the space bar) before making a choice in the guessing game.
- premature_game1_outcome = the number of premature responses during the outcome phase of the guessing game.
- game2_G_amount = the amount of points for the gamble option in the choice game.
- game2_G_prob = the probability of winning for the gamble option in the choice game.
- game2_NG_amount = the amount of points for the non-gamble option in the choice game.
- game2_pos = the left/right position of the gamble and non-gamble options. ng-left-g-right: non-gamble left, gamble right; g-left-ng-right: gamble left, non-gamble right.
- game2_startRT = how quickly participants start the choice game, in milliseconds.
- game2_respKey = which key participants press to indicate their choice in the choice game, f or j.
- game2_respRT = how quickly participants make a choice in the choice game, in milliseconds.
- game2_gambled = whether participants choose to gamble or not in the choice game.
- game2_outcome = the outcome of the choice game, neutral (non-gamble), win or loss.
- game2_outcome_amount = the amount of points participants receive in the choice game.
- prematrue_game2_start = the number of premature responses when starting the choice game.
- prematrue_game2_delay = the number of premature responses during the delay.
- premature_game2_choice = the number of premature responses when making a choice in the choice game.
- premature_game2_outcome = the number of premature responses during the outcome phase of the choice game.
- time_elapsed = time since the start of the experiment, in milliseconds.

#### Data on premature responses (PauseForThought_premature_X.csv)

- subject_ID = subject ID of participants.
- trial_number = trial number in the task.
- phase = during which phase of the task does the response occur? Can be game1_start, game1_choice, game1_outcome, game2_start, game2_start_delay, game2_choice or game2_outcome.
- response_number = in case participants make multiple responses with inactive keys within one phase, the responses are numbered from 1, 2, ... in the order of occurring.
- key = the key pressed.
- rt = when each key is pressed, counting from the start of each phase, in milliseconds.

#### Data from the Problem Gambling Severity Index scale (PauseForThought_PGSI_X.csv)

- subject_ID = subject ID of participants.
- task = task name, PGSI.
-	question_number = number of the question.
- resp = the answer participant gives to a certain item.
- rt = reaction time since the presentation of the item till the submission of a response, in milliseconds.


#### Data from the UPPS-P impulsive behavior questionnaire (PauseForThought_UPPSP_X.csv)

- subject_ID = subject ID of participants.
- task = task name, UPPSP.
-	question_number = number of the question, from 1 till 20.
- reverse = whether the item is reversed coded or not. 1 = yes, 0 = no.
- factor = the factor that a certain item belongs to.
- resp = the answer participant gives to a certain item, after reverse coding if necessary.
- rt = reaction time since the presentation of the item till the submission of a response, in milliseconds.


### Quality control measures
None.

### Additional documents
None.
