# some functions to make RT plots based on posterior draws from a brms model

# function to compute the RT in each cell of the 2 by 2 design
# as well as the main and the simple effects
compute_RTs <- function(draws){
  
  draws <- draws %>%
    mutate(
      # compute the RT in each cell, transformed back to the original scale
      loss_pause_RT = exp(b_Intercept + 0.5 * b_game1_outcome_num + 0.5 * b_delay_num + 0.5 * 0.5 * `b_game1_outcome_num:delay_num`) - 1,
      win_pause_RT = exp(b_Intercept - 0.5 * b_game1_outcome_num + 0.5 * b_delay_num - 0.5 * 0.5 * `b_game1_outcome_num:delay_num`) - 1,
      loss_nopause_RT = exp(b_Intercept + 0.5 * b_game1_outcome_num - 0.5 * b_delay_num - 0.5 * 0.5 * `b_game1_outcome_num:delay_num`) - 1,
      win_nopause_RT = exp(b_Intercept - 0.5 * b_game1_outcome_num - 0.5 * b_delay_num + (-0.5) * (-0.5) * `b_game1_outcome_num:delay_num`) - 1,
      
      # compute the four simple effects
      pause_loss_win = loss_pause_RT - win_pause_RT, 
      nopause_loss_win = loss_nopause_RT - win_nopause_RT,
      win_pause_nopause = win_pause_RT - win_nopause_RT,
      loss_pause_nopause = loss_pause_RT - loss_nopause_RT,
      
      # compute the interaction effect
      inter = (loss_pause_RT - win_pause_RT) - (loss_nopause_RT - win_nopause_RT),
      
      # compute the main effects of pause and previous outcome
      pause_RT = exp(b_Intercept + 0.5 * b_delay_num) - 1,
      nopause_RT = exp(b_Intercept - 0.5 * b_delay_num) - 1,
      diff_p_np = pause_RT - nopause_RT,
      
      loss_RT = exp(b_Intercept + 0.5 * b_game1_outcome_num) - 1,
      win_RT = exp(b_Intercept - 0.5 * b_game1_outcome_num) - 1,
      diff_loss_win = loss_RT - win_RT
    )
  
  return(draws)
  
}

# function to draw RT in each cell in a 2 by 2 design
plot_RTs <- function(draws){
  
  # get the RT in each cell, and do some formatting
  RT_plot_data <- draws %>%
    select(loss_pause_RT, win_pause_RT, loss_nopause_RT, win_nopause_RT) %>%
    pivot_longer(
      cols = loss_pause_RT:win_nopause_RT, 
      names_to = "pause", 
      values_to = "RT"
    ) %>%
    mutate(
      prev_outcome = ifelse(str_detect(pause, "win"), "win", "loss"),
      pause = ifelse(str_detect(pause, "nopause"), "no", "yes")
    )
  
  # plot the RT in each cell
  RT_full_plot <- RT_plot_data %>%
    ggplot(aes(x = prev_outcome, y = RT, color = pause, fill = pause)) +
    stat_halfeye(point_interval = "mean_qi", slab_alpha = 0.5,
                 position = position_dodge(width = 0.6)) +
    geom_line(aes(group = pause), stat = "summary", fun = median, 
              linetype = "dashed",
              position = position_dodge(width = 0.6))+
    labs(x = "Previous outcome", color = "Pause", fill = "Pause") +
    theme(axis.text = element_text(size = 10, color = "black"),
          axis.title = element_text(size = 11))
  
  return(RT_full_plot)
}

# function to draw all RT effects
plot_RT_effs <- function(draws){
  
  # get all the effects, and do some formatting
  RT_plot_data <- draws %>%
    select(diff_p_np, diff_loss_win, pause_loss_win, nopause_loss_win, 
           win_pause_nopause, loss_pause_nopause, inter) %>%
    pivot_longer(
      cols = diff_p_np:inter, 
      names_to = "effect", 
      values_to = "diff"
    ) %>%
    mutate(
      effect = factor(effect, 
                      levels = c("diff_p_np", "diff_loss_win", "inter",
                                 "pause_loss_win", "nopause_loss_win",
                                 "win_pause_nopause", "loss_pause_nopause"),
                      labels = c("Pause vs. No-Pause", 
                                 "Loss vs. Win",
                                 "(Loss Pause - Win Pause) vs.\n(Loss No-Pause - Win No-Pause)",
                                 "Loss Pause vs. Win Pause",
                                 "Loss No-Pause vs. Win No-Pause",
                                 "Win Pause vs. Win No-Pause",
                                 "Loss Pause vs. Loss No-Pause"))
    )
  
  # compute the mean and 95% credible interval for each simple effect
  # these will be added to the plot as texts
  RT_summary <- RT_plot_data %>%
    group_by(effect) %>%
    summarize(
      mean = round(mean(diff), 1),
      lowerCI = round(quantile(diff, probs = 0.025), 1),
      upperCI = round(quantile(diff, probs = 1-0.025), 1)
    ) %>%
    # create a text summary, to be added to the plot
    mutate(
      # keep trailing zeros for a bit nicer formatting,
      # see https://stackoverflow.com/questions/5458729/keeping-trailing-zeros
      mean_txt = sprintf("%.1f", mean),
      lowerCI_txt = sprintf("%.1f", lowerCI),
      upperCI_txt = sprintf("%.1f", upperCI),
      summary = paste0(mean_txt, " [", lowerCI_txt, ", ", upperCI_txt, "]")
    )
  
  # plot all the effects
  RT_effs_plot <- RT_plot_data %>%
    ggplot(aes(x = diff, y = effect)) +
    # plot the posterior distributions
    stat_halfeye(point_interval = "mean_qi") +
    # add a vertical line at 0
    geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
    # add the text summary to the plot
    geom_text(data = RT_summary,
              aes(x = mean, y = effect, label = summary),
              nudge_y = -0.25) +
    labs(x = "Difference in reaction time (milliseconds)", y = "") +
    scale_y_discrete(limits=rev) +
    theme(axis.text = element_text(size = 9, color = "black"),
          axis.title = element_text(size = 11))
  
  return(RT_effs_plot)
}