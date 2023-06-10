# Install and load the required packages
install.packages("readxl")
library(readxl)
library(xts)
library(sandwich) # For Newey-West adjustment
library(lmtest)   # For Newey-West adjustment
library(zoo)
install.packages("lmtest")
install.packages("sandwich")

# Read the Shiller E/P data from the Excel file
ep_data <- read_excel("C:\\Users\\Afat\\Documents\\GitHub\\EFI_HW\\ie_data.xlsx", sheet = "Main")
head(ep_data,10)

ep_data$Date <- as.Date(paste(ep_data$Date, "01", sep = "."), format = "%Y.%m.%d")
ep_data <- na.omit(ep_data)
ep_data <- xts(ep_data[, -1], 
             order.by = as.Date(ep_data$Date))

ep_data$Return <- diff.xts(log(ep_data$Price))
head(ep_data,10)

ep_data <- na.omit(ep_data)


data <- ep_data["1900/2015", ]
tail(data)
head(data)

