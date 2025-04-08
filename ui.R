# Load libraries
library(shiny)
library(tidyverse)

# Application Layout
shinyUI(
  fluidPage(
    br(),
    titlePanel("Income Level Explorer"),
    p("Explore the difference between people who earn less than 50K and more than 50K. You can filter the data by country, then explore various demographic information."),
    
    fluidRow(
      column(width=12, 
             wellPanel(
               selectInput("country", "Select Country:", 
                           choices = c("United States","Canada","Mexico","Germany","Philippines")
               )
             )
      )
    ),
    fluidRow(
      column(width=3, 
             wellPanel(
               p("Select a continuous variable and graph type (histogram or boxplot) to view on the right."),
               radioButtons("continuous_variable","Continous Variable",
                            choices = c("age","hours_per_week"), 
                            selected = "age"),
               radioButtons("graph_type", "Chart Type", 
                            choices = c("histogram","boxplot"))
             )
      ),
      column(width = 9, plotOutput("p1"))  # Continuous variable plot
    ),
    fluidRow(
      column(width=3, 
             wellPanel(
               p("Select a categorical variable to view bar chart on the right. Use the check box to view a stacked bar chart to combine the income levels into one graph."),
               radioButtons("categorical_variable", "Categorical Variable", 
                            choices = c("workclass", "education","sex"), 
                            selected = "sex"),
               checkboxInput("is_stacked", "Stacked Bar Chart", value = FALSE)
             )
      ),
      column(width = 9, plotOutput("p2"))  # Categorical variable plot
    )
  )
)

