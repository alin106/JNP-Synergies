library(vegan)
library(ggplot2)

# Parameters
tasks <- c("FlexorSynergy", "ShoulderFlex", "Grasp")
metrics <- c("cs")

for(metric in metrics){
  for(task in tasks){
    
    cat("====================================\n")
    cat(paste("Metric:", metric, ", Task:", task, "\n"))
    
    # Load dissimilarity matrix and grouping
    matrix_file <- paste0("permanova_matrix_", metric, "_", task, ".csv")
    group_file <- paste0("permanova_subjs_", task, ".csv")
    
    dissim_matrix <- as.matrix(read.csv(matrix_file, row.names = 1))
    dist_obj <- as.dist(dissim_matrix)
    groups <- read.csv(group_file)
    
    # Homogeneity of dispersions
    # Tests whether the dispersions between the populations being compared are homogeneous
    # For permanova, dispersions should be homogeneous (non-significant result)
    cat("Homogeneity of Dispersions Test (betadisper):\n")
    disp <- betadisper(dist_obj, groups$group)
    print(permutest(disp, permutations = 999))
    print(anova(disp))
    cat("\n")
    
    # Run permanova
    results <- adonis2(dist_obj ~ group, data = groups, permutations = 999)
    print(results)
    cat("\n")
    
  }
}