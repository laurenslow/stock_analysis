# stock_analysis

The Stock Price Viewer and Predictor is a R web app created with the Shiny package and can be used to view prices of any single stock through user chosen start and end dates.  The app also allows users to acquire predicted stock prices for the following four years

## Installation

R and RStudio must be downloaded and installed before opening the file.  Also be sure to install and library [tidyverse](https://www.tidyverse.org/), [Shiny](https://shiny.rstudio.com/), and [quatmod](https://www.quantmod.com/), before running the user interface and server.

```r
install.packages("tidyverse")
install.packages("shiny")
install.packages("quantmod")

library(tidyverse)
library(shiny)
library(quantmod)

```

## Structure

There are two major components that interact within a Shiny app: the user interface and the server. 

#### User Interface

The user interface is a chunk of code that allows users to directly interact with the contents and code of the website, without needing any coding skills.  This interface is displayed as a web application with a few of text, number and date inputs.  The structure of the user interface in this application is as follows:

```r
ui <- fluidPage(
  titlePanel(# title goes here),
  sidebarLayout(# defines structure of the page)
    sidebarPanel(# defines area for side panel)
      helpText(# comments or notes about the project go here), 
      textInput(# symbol input goes here),
      dateRangeInput(# date inputs go here),
    
     mainPanel(# plot goes here)
    )
  )
)
```


#### Server

When the user changes inputs, the server code acts a set of instructions for the computer.  The user interface and server are connected in that the inputs the user changes within the user interface or modified in the server to create an output.  The server code in this application follows this structure:

```r
server <- shinyServer(function(input, output) {
  output$current_plot <- # use quantmod package to create first plot based on input dates and tock symbol

  output$predict_plot <- # based on data from stock prices, use a random walk model to create one prediction of stock prices of two years
  
  output$predictions_plot <- # based on data from stock prices, use a monte carlo model to create n predictions of stock prices of two years
})
```

## Usage
To manually run this web application, R and RStudio must be downloaded and installed.  Once both programs are available on your device, the application can be run by either copying and pasting the entire code chunk from the comined.Rmd file into the console on the bottom of the window or by clicking the green arrow near the top right corner of the chunk.  The web application will take a minute to gather data and run simulations.  

In the first tab of the web application, titled "Current Stock Chart", users can view the price and volume data for any given stock between two dates.  Price indicates the adjusted monetary value of the stock on any given day while volume indicates the amount of stock sold on any given day.  A green volume bar represents an up-day, where the opening price of the stock is lower than the closing price while an orange volume bar represents a down-day, where the opening price of the stock is higher than the closing price.  

The second tab of the web application, titled "One Prediction" gives a single 2 year prediction of the price of a chosen stock.  The prediction is based on a random walk model, which develops a prediction based on stock price data from the given input dates.  

The third tab of the web application, titled "Iterated Predictions" gives n 2 year predictions of the price of a chosen stock.  The user can input the number of simulated predictions they would like and the model will graph all of the predictions in one plot.  The more predictions the user requests in the "Set iterations"  bar, the greater the likelihood the model outputs an accurate prediction, however, 2 < n < 1000, based on the way the model is constructed.  

## Authors and Acknowledgement
Tool developed by Lauren Low with help from Cody Murphey.
