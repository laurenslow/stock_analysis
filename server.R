---
title: "server"
output: html_document
---

library(tidyverse)
library(shiny)
library(quantmod)

server <- shinyServer(function(input, output) {
  output$current_plot <- renderPlot({
    current_stock_data <- getSymbols(input$symb, src = "yahoo", from = input$dates[1], to = input$dates[2], auto.assign = FALSE)
    chartSeries(current_stock_data, type = "line")
  })

  
  output$predict_plot <- renderPlot({
    predict_stock_data <- getSymbols(input$symb, src = "yahoo", from = input$dates[1], to = input$dates[2], auto.assign = FALSE)
                          
    log_returns <- predict_stock_data %>%
      Ad() %>%
        dailyReturn(type = 'log')
    
    newsymb <- as.name(paste(input$symb, ".Adjusted", sep = ""))
    mean_log_returns <- mean(log_returns)
    sd_log_returns <- sd(log_returns)
    price <- rep(predict_stock_data[[1, newsymb]], 504)
  
    for(i in 2:length(price)){
      price[i] <- price[i - 1] * exp(rnorm(1, mean_log_returns, sd_log_returns))
    }
    
    random_data <- cbind(1:(504), price)
    colnames(random_data) <- c("day", "price")
    random_data <- as.data.frame(random_data)

    ggplot(random_data, aes(x = day, y = price)) +
    geom_line() +
    labs(title = "One Price Simulation for a Prediction Period of 2 Years")   
  })
  
  
  output$predictions_plot <- renderPlot({
    predictions_stock_data <- getSymbols(input$symb, src = "yahoo", from = input$dates[1], to = input$dates[2], auto.assign = FALSE)
                          
    log_returns <- predictions_stock_data %>%
      Ad() %>%
        dailyReturn(type = 'log')
    
    newsymb <- as.name(paste(input$symb, ".Adjusted", sep = ""))
    mean_log_returns <- mean(log_returns)
    sd_log_returns <- sd(log_returns)
    price <- rep(predictions_stock_data[[1, newsymb]], 504)
  
    seed <- input$seed
    mc_matrix <- matrix(nrow = 252 * 2, ncol = seed)
    
    for(j in 0:ncol(mc_matrix)){
      mc_matrix[1, j] <- as.numeric(predictions_stock_data[[1, newsymb]][length(predictions_stock_data[[1, newsymb]])])
    for(i in 2:nrow(mc_matrix)){
      mc_matrix[i, j] <- mc_matrix[i - 1, j] * exp(rnorm(1, mean_log_returns, sd_log_returns))
    }
    }
    
    name <- str_c("sim", seq(1, seed))
    name <- c("day", name)
    final_mat <- as.tibble(cbind(1:(252 * 2), mc_matrix))
    colnames(final_mat) <- name
    
    final_mat %>%
      gather("simulation", "price", 2:seed) %>%
      ggplot(aes(x = day, y = price, Group = simulation)) +
                    geom_line(alpha = 0.15) +
                    labs(title = "N Price Simulations for a Prediction Period of 2 Years") 
  })
})