# some functions to make choice plots based on posterior draws from a brms model

# plot the posterior distributions of the parameters in the choice model
plot_choice_params <- function(draws){
  
  # select variables of interest and do some formatting
  choice_plot_data <- draws %>%
    select(b_EV_ratio:`b_EV_ratio:game1_outcome_num:delay_num`) %>%
    pivot_longer(
      cols = b_EV_ratio:`b_EV_ratio:game1_outcome_num:delay_num`,
      names_to = "parameter",
      values_to = "estimate"
    ) %>%
    mutate(
      parameter = factor(
        parameter,
        levels = c("b_EV_ratio",
                   "b_game1_outcome_num",
                   "b_delay_num",
                   "b_EV_ratio:game1_outcome_num",
                   "b_EV_ratio:delay_num",
                   "b_game1_outcome_num:delay_num",
                   "b_EV_ratio:game1_outcome_num:delay_num"),
        labels = c("EV ratio",
                   "Prev outcome (loss vs. win)",
                   "Pause (yes vs. no)",
                   "EV ratio * Prev outcome",
                   "EV ratio * Pause",
                   "Prev outcome * Pause",
                   "EV ratio * Prev outcome * Pause"))
    )
  
  # compute the mean and 95% credible interval for each parameter
  # these will be added to the plot as texts
  choice_summary <- choice_plot_data %>%
    group_by(parameter) %>%
    summarize(
      mean = round(mean(estimate), 2),
      lowerCI = round(quantile(estimate, probs = 0.025), 2),
      upperCI = round(quantile(estimate, probs = 1-0.025), 2)
    ) %>%
    # create a text summary, to be added to the plot
    mutate(
      # keep trailing zeros for a bit nicer formatting,
      # see https://stackoverflow.com/questions/5458729/keeping-trailing-zeros
      mean_txt = sprintf("%.2f", mean),
      lowerCI_txt = sprintf("%.2f", lowerCI),
      upperCI_txt = sprintf("%.2f", upperCI),
      summary = paste0(mean_txt, " [", lowerCI_txt, ", ", upperCI_txt, "]")
    )
  
  # plot all the parameters
  choice_param_plot <- choice_plot_data %>%
    ggplot(aes(x = estimate, y = parameter)) +
    # add a vertical line at 0
    geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
    # plot the posterior distributions
    stat_halfeye(point_interval = "mean_qi") +
    # add the text summary to the plot
    geom_text(data = choice_summary,
              aes(x = mean, y = parameter, label = summary),
              nudge_y = -0.25) +
    labs(x = "Posterior estimate (log odds-ratio)", y = "") +
    scale_y_discrete(limits=rev) +
    theme(axis.text = element_text(size = 9, color = "black"),
          axis.title = element_text(size = 11))
}


# plot the predicted probabilities of choosing the HP option,
# as a function of all design factors (previous outcome, pause and EV ratio)
plot_choice <- function(draws){
  
  # a data frame that contains all possible levels in the factors
  df_design <- list(
    EV_ratio = c(-0.9090909, -0.7272727, -0.5000000, -0.2500000, -0.1052632,
                 0.1818182, 0.4347826, 0.5454545, 0.6666667, 0.9090909),
    # include 0 as that allows us to see the main effect of the other variable
    game1_outcome_num = c(-0.5, 0, 0.5),
    delay_num = c(-0.5, 0, 0.5)
  ) %>%
    cross_df()
  
  # compute the predicted probability of choosing the HP option,
  # given each level of previous outcome, pause and EV ratio
  draws_overall <- tibble() # an empty data frame to save the results
  
  # iterate through the rows of the design data frame
  # and compute the predicted probability for each posterior draw
  for (row in 1:nrow(df_design)){
    
    # get the factor level for the current row
    EV_ratio_tmp <- df_design[row, ]$EV_ratio
    outcome_tmp <- df_design[row, ]$game1_outcome_num
    delay_tmp <- df_design[row, ]$delay_num
    
    # compute the predicted probability of choosing HP for each draw
    draws_tmp <- draws %>%
      mutate(
        # compute the log odds-ratio
        log_OR = b_Intercept + 
                 b_EV_ratio * EV_ratio_tmp +
                 b_game1_outcome_num * outcome_tmp +
                 b_delay_num * delay_tmp +
                 `b_EV_ratio:game1_outcome_num` * EV_ratio_tmp * outcome_tmp +
                 `b_EV_ratio:delay_num` * EV_ratio_tmp * delay_tmp +
                 `b_game1_outcome_num:delay_num` * outcome_tmp * delay_tmp +
                 `b_EV_ratio:game1_outcome_num:delay_num` * EV_ratio_tmp * outcome_tmp * delay_tmp,
        # convert log odds-ratio into probability
        prob = exp(log_OR)/(1 + exp(log_OR)),
        # add the factor levels for the current row
        EV_ratio = EV_ratio_tmp,
        # recode numeric variables into different levels
        Pause = ifelse(delay_tmp == 0.5, "yes",
                       ifelse(delay_tmp == -0.5, "no", "combined")),
        Prev_outcome = ifelse(outcome_tmp == 0.5, "loss",
                              ifelse(outcome_tmp == -0.5, "win", "combined"))
      )
    
    # add the results of the current row to the overall data frame
    draws_overall <- bind_rows(draws_overall, draws_tmp)
  }
  
  
  # compute the mean probability in each cell, plus the 95% CI
  choice_summary <- draws_overall %>%
    group_by(Prev_outcome, Pause, EV_ratio) %>%
    summarize(
      mean = mean(prob),
      lowerCI = quantile(prob, probs = 0.025),
      upperCI = quantile(prob, probs = 1-0.025)
    ) %>%
    # add a little bit jitter to the horizontal location,
    # depending on the condition of pause
    mutate(
      cond = paste(Prev_outcome, Pause, sep = "_"),
      adj = recode(Pause, "no" = -0.025, "yes" = 0.025, "combined" = 0),
      EV_ratio_adj = EV_ratio + adj
    )
  
  choice_plot <- choice_summary %>%
    filter(Pause != "combined", Prev_outcome != "combined") %>%
    ggplot(aes(EV_ratio_adj, mean, color = Pause)) +
    geom_point() +
    geom_errorbar(aes(ymin = lowerCI, ymax = upperCI), width = 0.04) +
    geom_line(aes(group = Pause), alpha = 0.5) +
    labs(x = "Expected value ratio", y = "P(Choose the HP)", color = "Pause") +
    scale_y_continuous(labels = scales::percent) +
    facet_wrap(~Prev_outcome, ncol = 2)
  
  # turn the overall draws data frame into a wide format,
  # for plotting differences between conditions later on
  draws_overall_wide <- draws_overall %>%
    pivot_wider(
      id_cols = c(.chain, .draw, EV_ratio),
      names_from = c(Prev_outcome, Pause),
      values_from = prob
    ) %>%
    # compute some simple effects
    mutate(
      win_pause_nopause = win_yes - win_no,
      loss_pause_nopause = loss_yes - loss_no,
      pause_loss_win = loss_yes - win_yes,
      nopause_loss_win = loss_no - win_no
    )
  
  # compute summaries of the simple effects
  effs_summary <- draws_overall_wide %>%
    select(EV_ratio, win_pause_nopause:nopause_loss_win) %>%
    pivot_longer(
      cols = win_pause_nopause:nopause_loss_win,
      names_to = "effect",
      values_to = "diff"
    ) %>%
    # compute the mean and 95%CI in each cell
    group_by(EV_ratio, effect) %>%
    summarize(
      mean = mean(diff),
      lowerCI = quantile(diff, probs = 0.025),
      upperCI = quantile(diff, probs = 1 - 0.025)
    )
  
  # plot the difference between pause versus no pause,
  # for after a loss and after a win separately.
  simple_pause_plot <- effs_summary %>%
    filter(effect %in% c("win_pause_nopause", "loss_pause_nopause")) %>%
    mutate(
      Prev_outcome = factor(effect, 
                            levels = c("loss_pause_nopause", "win_pause_nopause"),
                            labels = c("Loss", "Win")),
      # add a little bit horizontal jitter, for the plotting
      adj = ifelse(Prev_outcome == "Loss", -0.018, 0.018),
      EV_ratio_adj = EV_ratio + adj
    ) %>%
    ggplot(aes(x = EV_ratio_adj, y = mean, color = Prev_outcome)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
    geom_line(aes(group = Prev_outcome), alpha = 0.5) +
    geom_point() +
    geom_errorbar(aes(y = mean, ymin = lowerCI, ymax = upperCI),
                  width = 0) +
    labs(x = "Expected value ratio", y = "Pause - No Pause", color = "Previous outcome") +
    scale_y_continuous(labels = scales::percent)
  
  # plot the difference between loss versus win,
  # for after a pause and after no pause separately.
  simple_outcome_plot <- effs_summary %>%
    filter(effect %in% c("pause_loss_win", "nopause_loss_win")) %>%
    mutate(
      Pause = factor(effect, 
                     levels = c("pause_loss_win", "nopause_loss_win"),
                     labels = c("Yes", "No")),
      # add a little bit horizontal jitter, for the plotting
      adj = ifelse(Pause == "Yes", -0.018, 0.018),
      EV_ratio_adj = EV_ratio + adj
    ) %>%
    ggplot(aes(x = EV_ratio_adj, y = mean, color = Pause)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "darkgray") +
    geom_line(aes(group = Pause), alpha = 0.5) +
    geom_point() +
    geom_errorbar(aes(y = mean, ymin = lowerCI, ymax = upperCI),
                  width = 0) +
    labs(x = "Expected value ratio", y = "Loss - Win", color = "Pause") +
    scale_y_continuous(labels = scales::percent)
  
  return(list(p1 = choice_plot, p2 = simple_pause_plot,
              p3 = simple_outcome_plot))
    
}