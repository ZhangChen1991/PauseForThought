library(tidyverse)
library(ggpubr)

# set the theme for all ggplot2 figures
theme_set(theme_classic() +
            theme(legend.position = "top",
                  legend.direction = "horizontal"))


# Choices in Exp1 and 2 ---------------------------------------------------

# load the figure from Experiment 1
# where the p(choose the HP option) is shown
# as a function of EV ratio and pause
EV_pause_Exp1_plot <- readRDS("../../Exp1/code/analysis/data-analysis/plots/EV_delay_plot.rds")
# add experiment number
EV_pause_Exp1_plot <- EV_pause_Exp1_plot +
  labs(title = "Experiment 1")

# load the same figure from Experiment 2
EV_pause_Exp2_plot <- readRDS("../../Exp2/code/analysis/data-analysis/plots/EV_delay_plot.rds")
# add experiment number
EV_pause_Exp2_plot <- EV_pause_Exp2_plot +
  labs(title = "Experiment 2")

# combine the two figures
EV_pause_Exp12_plot <- 
  ggarrange(EV_pause_Exp1_plot, EV_pause_Exp2_plot, 
            ncol=2, nrow=1, 
            common.legend = TRUE, legend="bottom")

# save as a png file
ggsave("EV_pause_Exp12.png", EV_pause_Exp12_plot, width = 8, height = 4)


# RTs in Exp 1 and 2 ------------------------------------------------------

# load the RT figure from Experiment 1 and 2
RTs_Exp1 <- readRDS("../../Exp1/code/analysis/data-analysis/plots/RTs_Exp1.rds")
RTs_Exp2 <- readRDS("../../Exp2/code/analysis/data-analysis/plots/RTs_Exp2.rds")

# add experiment name
RTs_Exp1 <- RTs_Exp1 + labs(title = "Experiment 1")
RTs_Exp2 <- RTs_Exp2 + labs(title = "Experiment 2")

# combine the two figures
RTs_Exp12 <- 
  ggarrange(RTs_Exp1, RTs_Exp2, 
            ncol=2, nrow=1, 
            common.legend = TRUE, legend="bottom")

# save as a png file
ggsave("RTs_Exp12.png", RTs_Exp12, width = 8, height = 4)
