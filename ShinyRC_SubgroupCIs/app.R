# This is a Shiny web application. 

# Libraries
library(shiny)
library(tidyverse)
library(magrittr)
library(here)
library(vroom)
# Install Reverse Correlation package (only development version is currently available)
library(devtools)
if(!require(rcicr)) devtools::install_github("rdotsch/rcicr", force=TRUE)
library(rcicr)

options(shiny.maxRequestSize = 100 * 1024 ^ 2)

# UI
ui <- fluidPage(
  
  # Theme
  theme = bslib::bs_theme(bootswatch = "quartz"),
  
  # App title
  titlePanel("Shiny Reverse Correlation: Sampling for Subgroup CI generation", 
             windowTitle = "ShinyRC: Subgroup CI Sampling"),

  # Side bars
  sidebarLayout(
    sidebarPanel(
      fluidRow( 
        shiny::h4("RC 2IFC task response data"),
        # Upload 2 forced-choice RC task data
        fileInput("responseData", "Upload .csv file",
                  accept = c(".csv", ".tsv"))
      ),
      
      shiny::p("Note: Data must include columns named: 'subject', 'stimulus', and 'response'"),
      
      shiny::h4("Subset size"),
      # Percentage of individual CIs to sample from all CIs for each sub group-CI 
      selectInput("sample_percentage", "Choose % of individual CIs to sample for each subgroup CI.",
                  choices = c("75%" = "0.75",
                              "50%" = "0.50",
                              "25%" = "0.25"),
                  selected = "0.50"),
      
      shiny::h4("How many subgroup CIs do you need?"),
      # How many subgroup CIs?
      numericInput("nr_subgroup_cis", "", value = 2, min = 2),
      
      shiny::h4("Reproducibility"),
      # Input seed for reproducibility of sampling output
      numericInput(inputId = "inputSeed",
                   label = "Seed number",
                   value = 42),
      
      shiny::p("The same seed number generates the same random sampling results.\n
               Use the default '42', or change to any other number you wish."),
      shiny::br(),
      
      # Action button to compute sampling
      actionButton("compute", "Generate sample!"),
      
      shiny::br(),
      shiny::br(),
      
      # Download result
      downloadButton('downloadData',"Download data to generate subgroup CIs")
      
    ),
    
    mainPanel(
      tableOutput("subgroupcitable"),
      shiny::br(),
      shiny::br(),
      shiny::p("Citation:"),
      tags$div(HTML("<p>Oliveira, M. (2023). Shiny Reverse Correlation: Sampling for subgroup CI generation. R Shiny application (Version 0.1), <a href='http://olivethree.shinyapps.io/shinyRC_subgroup_cis'>http://olivethree.shinyapps.io/shinyRC_subgroup_cis</a></p>")),
    )
    
  ))


# SERVER
server <- function(input, output) {
  
  # Setup input seed
  global_seed = reactive(input$inputSeed)
  
  # Compute subgroup CI data
  resultData <- eventReactive(input$compute, {
    
    # set input seed 
    set.seed(global_seed())
    
    # Response data set
    input_data <- vroom::vroom(input$responseData$datapath)
    # Derive total number of participants
    participant_n <- input_data$subject %>% unique %>% length
    # How many possible individual CIs
    total_ind_cis <- participant_n # This step is explicitly added for the sake of clarity
    # Desired number of sub group-CIs
    nr_groupcis <- input$nr_subgroup_cis %>% as.numeric()
    # Fraction of participants (individual CIs) from the full set
    input_fraction <- input$sample_percentage %>% as.numeric()
    # Initialize dataframe to log information about sampled individual CIs
    sampled_cis <- NULL
    # Initialize list to store subgroupci data frames & sampled CI ids
    results <- list(subgroup_ci = NULL, sampled_ind_cis = NULL)
    
    # Initiate sampling
    for(groupci in 1:nr_groupcis) {
      
      # Sampling (without replacement)
      id_sampled_ind_ci <- input_data$subject %>%
        unique() %>%
        sample(size = round(input_fraction * participant_n, 0), replace = FALSE)
      # Filter input response data set to include only subset of participants (individual CIs)
      subgroup_df <-
        input_data %>% 
        filter(subject %in% id_sampled_ind_ci) %>% 
        mutate(subgroup_ci_nr = groupci)
      # Subgroup CI name
      subgroupci_label <- paste0("subgroup_ci_", groupci)
      
      # Add sampled subgroup CI data to list
      results$subgroup_ci[[groupci]] <- subgroup_df
      df_name_str <- paste("subgroupci_", groupci)
      names(results$subgroup_ci)[groupci] <- df_name_str
      
      # Add sampling information to results
      results$sampled_ind_cis[[groupci]] <- rbind(sampled_cis, data.frame(subgroupci_label, id_sampled_ind_ci))
      df_name_str2 <- paste("sampled_indcis_subgci_", groupci)
      names(results$subgroup_ci)[groupci] <- df_name_str2
    }
    results
  })
  
  ciData <- eventReactive(input$compute, {
    results <- resultData()
    output_cidata <- do.call(rbind, results$subgroup_ci)
    output_cidata
  })
  
  sampledData <- eventReactive(input$compute, {
    results <- resultData()
    output_sampled <- do.call(rbind, results$sampled_ind_cis)
    output_sampled
  })
  
  output$subgroupcitable <- renderTable({
    sampledData() %>% 
      mutate(subgroupci_label = gsub("\\D", "", subgroupci_label)) %>% 
      rename(`Subgroup CI number` = subgroupci_label,
             `Sampled Individual CI` = id_sampled_ind_ci) 
  })
  
  output$downloadData <- downloadHandler(
    filename = function(){ paste("subgroupci_data_", Sys.time(), ".csv")}, 
    content = function(fname){
      write.csv(ciData(), fname)
    })
} 

shinyApp(ui = ui, server = server)