# Shiny Reverse Correlation: Sampling for Subgroup CIs

**Shiny app**: <https://olivethree.shinyapps.io/shinyRC_subgroup_cis/>

**Citation:**

-   Oliveira, M. (2023). Shiny Reverse Correlation: Sampling for subgroup CI generation. R Shiny application (Version 0.1), <http://olivethree.shinyapps.io/shinyRC_subgroup_cis>

## Overview

This app facilitates the creation of random subsets of individual classification image ids to generate subgroup classification images.

## How to use

1.  Upload CSV file containing your RC task response data. This file must have three columns:

    1.  Column 'subject': contains the unique identifier for the participant (e.g. 1, 2, 3, etc.)

    2.  Column 'stimulus': contains information about which trial the response corresponds to

    3.  Column 'response': contains responses in each trial

2.  Select the size of the subset of individual CIs to generate each subgroup CI in terms of % of the total amount of participants / individual CIs. There are three options: 25%, 50%, or 75% of all individual CIs. **Note**: 100% is not included, as that would simply be the group CI using all of individual CIs.

3.  Select how many subgroup CIs you intend to generate. **Important note:** the theoretical maximum of subgroup CIs equals: Total number of participants - 1. Also consider that all subgroup CIs become individual CIs if you set the Total number of participants to be equal to the number of intended subgroup CIs.

4.  Set a seed for reproducibility of sampling results. The default seed is set to 42. You can use the default, or change to any other number you wish. It does not matter what exact number you use. All you need to know is that the same seed number will generate the same (pseudo-)random sampling process, meaning that any other person using the same seed number you used will obtain the same results as you did.

5.  Click 'Generate sample' to get your results.

6.  The action above also generates a file similar to the one you uploaded, that you can use to generate the subgroup CIs using the rcicr package. Click on the 'Download data to generate subgroup CIs' button to get this file.

7.  You may now read this file in a R script and use it to generate the subgroup CIs. Feel free to use the suggested code below :)

```{r}
# # Libraries
# library(vroom)
# library(here)
# library(devtools)
# # Install Reverse Correlation package if needed; otherwise load it
# if(!require(rcicr)) devtools::install_github("rdotsch/rcicr", force=TRUE)
# library(rcicr)


## Read data
## e.g. vroom::vroom("subgroupci_data_ 2023-04-16 20_22_48 .csv) assuming file is in root directory of R project (where .Rproj file is)

# response_data <- vroom::vroom(<insert filename here>)

## Set path to where the rdata file created at stimulus generation is located in your project
## e.g. using here package path_to_rdata <- here::here("stimuli", rdata_file_stimulus_generation)

# path_to_rdata <- <insert_path_to_rdata_file_here> 

## Set base image name as defined at stimulus generation step

# baseimage_name <- <insert string of base image name here> # e.g. "base_face"

## Generate subgroup CI
# batchGenerateCI2IFC(
#   response_data,
#   by = "subgroup_ci_nr",
#   stimuli = "stimulus",
#   responses = "resp",
#   baseimage = baseimage_name,
#   rdata = path_to_rdata_file,
#   save_as_png = TRUE,
#   targetpath = "./subgroup_cis",
#   antiCI = FALSE,
#   scaling = "autoscale",
#   constant = 0.1,
#   label = subgroupci_label)
```

# Motivation behind this app

A currently recommended practice in psychological research involving a two-phase variant of the psychophysical reverse correlation method (e.g. [Dotsch & Todorov, 2012](https://journals.sagepub.com/doi/abs/10.1177/1948550611430272)), is to use the data collected in the first phase to generate multiple group-level classification images (CIs) for the second phase, instead of a single group CI (see [Cone et al., 2021](https://journals.sagepub.com/doi/10.1177/1948550620938616)).

These are the steps typically involved in a two-phase reverse correlation methodology in the domain of social psychological research.

**Phase One**

-   Reverse Correlation task where each participant completes a number of trials where they have to make a decision

-   In each trial a pair (or more) images that correspond to the combination of a base image (e.g. face, household object, etc.) with visual noise distorting the original image in random regions. Across all trial;s the base image is the same, but the superimposed noise introduces slight random variations across all images, which can be compared to many parallel universe versions of the same image.

-   The task given to the participant in each trial is to pick from a pair (or more) of noisy images, the one that most approximates a given concept/category in their mind. For instance, picking from a pair of faces, the one that looks the most angry.

-   Using the participants responses in this first phase, the researcher takes the noise patches of the images selected by the participant during the task, averages them, and superimposes them again on the original base image. The result is an individual-level CI, or more simply an 'individual CI'.

-   The typical next step could bve to average all the individual CIs of the group of participants who performed the same RC task (e.g. who were asked the same question, such as 'Pick the face that looks most angry'). The result is what is known as a group-level CI, or more simply 'group CI'.

**Phase Two**

The second-phase typically involves asking a different group of participants to rate the resulting group CI (or as many group CIs there are) on the extent to which they signal the very same concept/category that was used to generate them in the first-phase task. For example, if a group CI was generated for the concept of 'angry' face, then in this phase the new group of participants would evaluate how angry this group CI face looks to them.

**Anything wrong with that?**

However, Cone and colleagues called attention to the fact that evaluating a single group CI is not ideal, as it does not reflect all the individual variation that there was in people's results in the first phase.

**Introducing Shiny RC: Sampling Subgroup CIs**

An approach to overcome this limitation in phase two is to generate, not one, but multiple 'subgroup CIs' from all the individual CIs of the same condition (i.e. created for the same concept). To do so, one needs to randomly sample subsets of individual CIs to generate these 'sub' group CIs. This is where this app come in handy, it allows you to quickly sample random subsets of individual CIs, and generates a file that you can easily use to generate the subgroup CIs using the R package rcicr (Dotch, 2016).

# References

-   Cone, J., Brown-Iannuzzi, J. L., Lei, R., & Dotsch, R. (2021). Type I Error Is Inflated in the Two-Phase Reverse Correlation Procedure. Social Psychological and Personality Science, 12(5), 760--768. <https://doi.org/10.1177/1948550620938616>

-   Dotsch R. (2016). Rcicr: Reverse-correlation image-classification toolbox. *R package (Version 0.3)*, 4. <https://cran.r-project.org/web/packages/rcicr/index.html>

-   Dotsch, R., & Todorov, A. (2012). Reverse Correlating Social Face Perception. Social Psychological and Personality Science, 3(5), 562--571. <https://doi.org/10.1177/1948550611430272>
