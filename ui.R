---
title: "ui"
output: html_document
---

library(tidyverse)
library(shiny)
library(quantmod)

fluidPage(
  titlePanel("Stock Price Chart and Sales Volume"),
  sidebarLayout(
    sidebarPanel(
      helpText("Source: Yahoo Finance"),
      textInput("symb", "Symbol", "AAPL"),
      numericInput("seed", "Set iterartions", 100, min = 1, max = 1000),
      dateRangeInput("dates", "Date range", start = "2020-01-01", end = Sys.Date()),
      br(),
      br()
      ),
    
    mainPanel(tabsetPanel(type = "tabs", 
                          tabPanel("Current Stock Chart" , plotOutput("current_plot")),
                          tabPanel("One Prediction" , plotOutput("predict_plot")),
                          tabPanel("Iterated Predictions" , plotOutput("predictions_plot")))
    )
  )
)