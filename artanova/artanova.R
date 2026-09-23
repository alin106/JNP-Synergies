library(ARTool)
library(dplyr)
library(readr)

# Parameters
metrics <- c("cs", "ndiem")
groups  <- c("Severe", "Moderate", "Mild")
tasks   <- c("FlexorSynergy", "ShoulderFlex", "Grasp")

for (task in tasks) {
  cat("====================================\n")
  cat("Task:", task, "\n")
  df_all <- data.frame()
  
  for (metric in metrics) {
    for (group in groups) {
      
      # Load contrast distributions with pair IDs
      file_name <- sprintf("artanova_%s_%s_%s.csv",metric, task, group)
      values <- read_csv(file_name, col_names = FALSE, show_col_types = FALSE, progress = FALSE)
      tmp <- data.frame(similarity = values[[1]], pair = values[[2]],metric = metric,group = group)
      df_all <- bind_rows(df_all, tmp)
    }
  }
  
  df_all$metric <- factor(df_all$metric)
  df_all$group <- factor(df_all$group)
  df_all$pair <- factor(df_all$pair)
  
  # Run art anova
  art_model <- art(similarity ~ metric * group + (1|pair), data = df_all)
  anova_res <- anova(art_model)
  
  print(anova_res)
  cat("\n")
}