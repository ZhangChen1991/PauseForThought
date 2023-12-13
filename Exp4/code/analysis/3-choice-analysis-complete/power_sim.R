library(tidyverse)
library(lme4)
library(lmerTest)
library(mixedpower)

# load the cleaned data
df_main <- read_csv("../../../data/processed/df_main_exp4_complete.csv")

df_exp <- df_main %>% filter(trial_type == "exp")

m_choice <- glmer(
  game2_choose_HP ~ EV_ratio * game1_outcome_num * delay_num +
    (EV_ratio * game1_outcome_num * delay_num|subject_ID),
  data = df_exp,
  family = binomial,
  control = glmerControl(
    optimizer = "bobyqa", 
    calc.derivs = FALSE,
    optCtrl=list(maxfun=1e6)
  )
)

m_choice2 <- glmer(
  game2_choose_HP ~ EV_ratio * delay_num +
    (EV_ratio * delay_num|subject_ID),
  data = df_exp,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

power_choice <- mixedpower(
  model = m_choice,
  data = df_exp,
  fixed_effects = c("EV_ratio", "game1_outcome_num", "delay_num"),
  simvar = "subject_ID",
  critical_value = 2,
  steps = c(200, 250, 300),
  n_sim = 100
)