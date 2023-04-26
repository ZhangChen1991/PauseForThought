# some functions to make RT plots based on posterior draws from a brms model
# note these functions are slightly different from the ones for each individual experiment,
# as the functions here make facets for different experiments.


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

# function to draw the posterior distributions of the parameters,
# note the dependent variable here is the log-transformed RT.
plot_RT_params <- function(draws){
  
  # get the draws for each parameter in the brms model
  # for this plot, I ignore the intercept parameter
  param_plot_data <- draws %>%
    select(
      b_game1_outcome_num, b_delay_num, `b_game1_outcome_num:delay_num`,
      Exp, var
    ) %>%
    pivot_longer(
      cols = b_game1_outcome_num:`b_game1_outcome_num:delay_num`,
      names_to = "parameter",
      values_to = "estimate"
    ) %>%
    # do some formatting
    mutate(
      parameter = recode(
        parameter,
        "b_game1_outcome_num" = "Prev outcome (loss vs. win)",
        "b_delay_num" = "Pause (long vs. short)",
        "b_game1_outcome_num:delay_num" = "Prev outcome * Pause"
      ),
      parameter = factor(
        parameter,
        levels = c("Prev outcome (loss vs. win)",
                   "Pause (long vs. short)",
                   "Prev outcome * Pause")),
      var = factor(var, levels = c("Start RT", "Choice RT"))
    )
  
  # plot the posterior distributions
  RT_param_plot <- param_plot_data %>%
    ggplot(aes(x = estimate, y = parameter)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
    stat_halfeye(point_interval = "mean_qi") +
    labs(x = "Posterior estimate (on log RT)",
         y = "") +
    theme(axis.text = element_text(size = 10, color = "black"),
          axis.title = element_text(size = 11)) +
    scale_y_discrete(limits = rev) +
    facet_grid(Exp ~ var, scales = "free")
  
  # a second version, in which I use different colors to show different experiments,
  # rather than using separate facets - this may make between-experiment comparisons easier
  # the default behavior of position_dodge (at least in stat_pointinterval, see below)
  # is to list the groups from bottom to top. Here I reverse the levels for the factor Exp,
  # so that the experiments will be plotted from top to bottom in order
  Exp_levels <- sort(unique(param_plot_data$Exp), decreasing = TRUE)
  
  param_plot_data <- param_plot_data %>%
    mutate(Exp = factor(Exp, levels = Exp_levels))
  
  RT_param_plot2 <- param_plot_data %>%
    ggplot(aes(x = estimate, y = parameter, color = Exp, fill = Exp)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
    stat_slab(alpha = 0.5) +
    stat_pointinterval(point_interval = "mean_qi",
                       position = position_dodge(width = .7, 
                                                 preserve = "single")) +
    labs(x = "Posterior estimate (on log RT)",
         y = "",
         color = "Experiment", fill = "Experiment") +
    theme(axis.text = element_text(size = 12, color = "black"),
          axis.title = element_text(size = 13)) +
    scale_y_discrete(limits = rev) +
    facet_grid( ~ var, scales = "free") +
    # then reverse the legend again, so it starts with Experiment 1
    guides(fill = guide_legend(reverse = TRUE),
           color = guide_legend(reverse = TRUE))
  
  return(list(p1 = RT_param_plot, p2 = RT_param_plot2))
}



# function to draw RT in each cell in a 2 by 2 design
plot_RTs <- function(draws){
  
  # get the RT in each cell, and do some formatting
  RT_plot_data <- draws %>%
    select(loss_pause_RT, win_pause_RT, loss_nopause_RT, win_nopause_RT, Exp, var) %>%
    pivot_longer(
      cols = loss_pause_RT:win_nopause_RT, 
      names_to = "pause", 
      values_to = "RT"
    ) %>%
    mutate(
      prev_outcome = ifelse(str_detect(pause, "win"), "Win", "Loss"),
      pause = ifelse(str_detect(pause, "nopause"), "Short (0 or 300 ms)", "Long (3000 ms)"),
      pause = factor(pause, levels = c("Short (0 or 300 ms)", "Long (3000 ms)")),
      var = factor(var, levels = c("Choice RT", "Start RT")),
    )
  
  # plot the RT in each cell
  RT_full_plot <- RT_plot_data %>%
    ggplot(aes(x = prev_outcome, y = RT, color = pause, fill = pause)) +
    stat_halfeye(point_interval = "mean_qi", slab_alpha = 0.5,
                 position = position_dodge(width = 0.6)) +
    geom_line(aes(group = pause), stat = "summary", fun = median, 
              linetype = "dashed",
              position = position_dodge(width = 0.6))+
    labs(x = "Previous outcome", color = "Pause", fill = "Pause",
         y = "Estimated reaction time (milliseconds)") +
    theme(axis.text = element_text(size = 10, color = "black"),
          axis.title = element_text(size = 11)) +
    facet_grid(var ~ Exp, scales = "free")
  
  return(RT_full_plot)
}

# function to draw all RT effects
plot_RT_effs <- function(draws){
  
  # get all the effects, and do some formatting
  RT_plot_data <- draws %>%
    select(diff_p_np, diff_loss_win, pause_loss_win, nopause_loss_win, 
           win_pause_nopause, loss_pause_nopause, inter, Exp, var) %>%
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
                                 "Loss Pause vs. Loss No-Pause")),
      var = factor(var, levels = c("Start RT", "Choice RT"))
    )
  
  # compute the mean and 95% credible interval for each simple effect
  # these will be added to the plot as texts
  RT_summary <- RT_plot_data %>%
    group_by(effect, Exp, var) %>%
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
    # add a vertical line at 0
    geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
    # plot the posterior distributions
    stat_halfeye(point_interval = "mean_qi") +
    # add the text summary to the plot
    geom_text(data = RT_summary,
              aes(x = mean, y = effect, label = summary),
              nudge_y = -0.25, color = "darkgray", size = 3) +
    labs(x = "Difference in reaction time (milliseconds)", y = "") +
    scale_y_discrete(limits=rev) +
    theme(axis.text = element_text(size = 10, color = "black"),
          axis.title = element_text(size = 11)) +
    facet_grid(Exp ~ var, scales = "free")
  
  # make another plot, in which I use Experiment as a color, rather than a facet
  # the default behavior of position_dodge (at least in stat_pointinterval, see below)
  # is to list the groups from bottom to top. Here I reverse the levels for the factor Exp,
  # so that the experiments will be plotted from top to bottom in order
  Exp_levels <- sort(unique(RT_plot_data$Exp), decreasing = TRUE)
  
  RT_plot_data <- RT_plot_data %>%
    mutate(Exp = factor(Exp, levels = Exp_levels))
  
  RT_effs_plot2 <- RT_plot_data %>%
    ggplot(aes(x = diff, y = effect, color = Exp, fill = Exp)) +
    # add a vertical line at 0
    geom_vline(xintercept = 0, linetype = "dashed", color = "darkgray") +
    stat_slab(alpha = 0.5) +
    stat_pointinterval(point_interval = "mean_qi",
                       position = position_dodge(width = .7, 
                                                 preserve = "single")) +
    labs(x = "Difference in reaction time (milliseconds)", y = "",
         color = "Experiment", fill = "Experiment") +
    scale_y_discrete(limits=rev) +
    theme(axis.text = element_text(size = 12, color = "black"),
          axis.title = element_text(size = 13)) +
    facet_grid(~ var, scales = "free") +
    # then reverse the legend again, so it starts with Experiment 1
    guides(fill = guide_legend(reverse = TRUE),
           color = guide_legend(reverse = TRUE))
  
  return(list(p1 = RT_effs_plot, p2 = RT_effs_plot2))
}


# compute choice RTs predicted by the model,
# taking into account the EV ratios
compute_RTs_EV <- function(draws){
  
  # a data frame that contains all possible levels in the factors
  df_design <- list(
    EV_ratio_c = seq(-0.45, 0.45, 0.05),
    game1_outcome_num = c(-0.5, 0.5),
    delay_num = c(-0.5, 0.5)
    ) %>%
    cross_df()
  
  draws_overall <- tibble() # an empty data frame to save the results
  
  for (row in 1:nrow(df_design)){
    
    # get the factor level for the current row
    EV_ratio_tmp <- df_design[row, ]$EV_ratio_c
    outcome_tmp <- df_design[row, ]$game1_outcome_num
    delay_tmp <- df_design[row, ]$delay_num
    
    # compute the predicted probability of choosing HP for each draw
    draws_tmp <- draws %>%
      mutate(
        RT = exp(
          b_Intercept + b_game1_outcome_num * outcome_tmp +
            b_delay_num * delay_tmp + b_EV_ratio_c * EV_ratio_tmp +
            `b_game1_outcome_num:delay_num` * outcome_tmp * delay_tmp +
            `b_game1_outcome_num:EV_ratio_c` * outcome_tmp * EV_ratio_tmp +
            `b_delay_num:EV_ratio_c` * delay_tmp * EV_ratio_tmp +
            `b_game1_outcome_num:delay_num:EV_ratio_c` * outcome_tmp * delay_tmp * EV_ratio_tmp
        ),
        # add the factor levels for the current row
        EV_ratio_c = EV_ratio_tmp,
        delay_num = delay_tmp,
        prev_outcome_num = outcome_tmp
      )
    
    # add the results of the current row to the overall data frame
    draws_overall <- bind_rows(draws_overall, draws_tmp)
  }
  
  return(draws_overall)
}

