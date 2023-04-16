# Shiny Reverse Correlation: 

# Sampling for Subgroup CIs

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

I**ntroducing...Shiny RC: Sampling Subgroup CIs!**

An approach to overcome this limitation in phase two is to generate, not one, but multiple 'subgroup CIs' from all the individual CIs of the same condition (i.e. created for the same concept). To do so, one needs to randomly sample subsets of individual CIs to generate these 'sub' group CIs. This is where this app come in handy, it allows you to quickly sample random subsets of individual CIs, and generates a file that you can easil;y use to generate the subgroup CIs using the R package rcicr (Dotch, 2016).

This app facilitates the creation of random subsets of individual classification image ids to generate subgroup classification images.

# References

-   Cone, J., Brown-Iannuzzi, J. L., Lei, R., & Dotsch, R. (2021). Type I Error Is Inflated in the Two-Phase Reverse Correlation Procedure. Social Psychological and Personality Science, 12(5), 760--768. <https://doi.org/10.1177/1948550620938616>

-   Dotsch R. (2016). Rcicr: Reverse-correlation image-classification toolbox. *R package (Version 0.3)*, 4. <https://cran.r-project.org/web/packages/rcicr/index.html>

-   Dotsch, R., & Todorov, A. (2012). Reverse Correlating Social Face Perception. Social Psychological and Personality Science, 3(5), 562--571. <https://doi.org/10.1177/1948550611430272>
