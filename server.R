#Load libraries
library(shiny)
library(tidyverse)

#Read in data
adult <- read_csv("adult.csv")
#convert column names to lower case for convenience
names(adult)<-tolower(names(adult))

#Define server logic
shinyServer(function(input, output) {
 
  # Reactive data filtered by country
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
    library(dplyr)
    df_country <- adult %>% 
      mutate(income_group = ifelse(prediction < 50000, "<=50k", ">50k"))
  })
  
  # Continuous variable plot
  output$p1 <- renderPlot({
    if (input$graph_type == "histogram") {
      ggplot(df_country(), aes_string(x=input$continuous_variable)) +
        geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
        labs(x = input$continuous_variable, y = "Count", 
             title = paste("Histogram of", input$continuous_variable)) +
        facet_wrap(~prediction)
    } else {
      ggplot(df_country(), aes_string(y = input$continuous_variable)) +
        geom_boxplot(fill = "skyblue", color = "black") +
        coord_flip() +
        labs(y = input$continuous_variable, 
             title = paste("Boxplot of", input$continuous_variable))+
        facet_wrap(~prediction)
    }
  })
  
  # Categorical variable plot
  output$p2 <- renderPlot({
    p <- ggplot(df_country(), aes_string(x = input$categorical_variable)) +
      labs(x = input$categorical_variable, y = "Count", 
           title = paste("Bar Chart of", input$categorical_variable)) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1),
            legend.position = "bottom")
    
    if (input$is_stacked) {
      p + geom_bar(aes(fill=prediction), color="green", position = "stack")
    } else {
      p + geom_bar(aes(fill = .data[[input$categorical_variable]]),position = "dodge" )+
        facet_wrap(~prediction) 
    }
  })
})