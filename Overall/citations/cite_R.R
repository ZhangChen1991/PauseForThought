# code that takes a list of R package names
# and then return the citations for the R packages

# a list of all packages used
pack_names <- c("tidyverse",
                "brms",
                "cmdstanr",
                "knitr",
                "MASS",
                "Rmisc",
                "ggpubr",
                "loo",
                "bayesplot",
                "bayestestR",
                "tidybayes",
                "sjPlot",
                "afex",
                "kableExtra")

# sort all packages alphabetically
pack_names <- sort(pack_names)

# write all the bibtex info into a bib file, cite R as well
knitr::write_bib(c("base", pack_names), "packages.bib")
  
# generate a string that can be copied and pasted
# into a latex document directly without (too many) further changes
latex_string <- paste0("We conducted all analyses in R ",
                       "\\parencite[version ",
                       R.Version()$major,
                       ".",
                       R.Version()$minor,
                       ";][]{",
                       "R-base}.\n\n")

latex_string <- paste0(latex_string,
                       "Furthermore, we used the following R packages: ")

for (one_package in pack_names) {
  # get the version number of the package used
  package_version <- packageVersion(one_package)
  
  # add this information to the latex string
  # if the package is not the last one in the list
  if (one_package != pack_names[length(pack_names)]){
    latex_string <- paste0(latex_string, 
                           one_package, 
                           " \\parencite[version ",
                           packageVersion(one_package),
                           ";][]{R-",
                           one_package,
                           "}, ")
  } else{ # if the package is the last one in the list
    latex_string <- paste0(latex_string, 
                           "and ",
                           one_package, 
                           " \\parencite[version ",
                           packageVersion(one_package),
                           ";][]{R-",
                           one_package,
                           "}.") # period instead of comma
  }
}

# write the string to a text file
sink("latex.txt")
cat(latex_string)
sink()
