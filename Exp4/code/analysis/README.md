### Content of sub-folders:


0. `0-check-data` contains the R code used to check the test data while programming and testing the experiment.
0.  `0-power-simulation` contains the R code for power simulation before running the experiment.
1.  `1-remove-IDs` contains the R code used to compute the bonus for each participant, and remove their prolific IDs from the raw data files. The raw data files are saved in the `data/raw` folder.
2.  `2-preprocessing` contains the R code used to load the individual raw data files, clean and combine them into one cleaned file. The clean data is saved in the `data/processed` folder.
3.  `3-choice-analysis-complete` contains the R code to analyze the choices in the Vancouver Gambling task, with the complete dataset.
3.  `3-choice-analysis-first` contains the R code to analyze the choices in the Vancouver Gambling task, with data from the first phase only.
4.  `4-RT-analysis-complete` contains the R code to analyze the RT data, more specifically the RT of starting game 2 and the RT of making a choice in game 2, in the complete dataset.
4.  `4-RT-analysis-first` contains the R code to analyze the RT data, more specifically the RT of starting game 2 and the RT of making a choice in game 2, with data in the first phase only.
5.  `plots` stores some key figures generated in the previous analyses.
