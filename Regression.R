# Install and load the required packages
install.packages("readxl")
library(readxl)
library(xts)
library(sandwich) # For Newey-West adjustment
library(lmtest)   # For Newey-West adjustment
library(zoo)

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


# Assuming you have a dataframe named 'data' containing CAPE and returns data

# Calculate the correlation
correlation <- cor(data$CAPE, data$Return)

# Print the correlation coefficient
print(correlation)


###########################
# Subset for in-sample period
ep_sub <- subset(ep_data, ep_data$Date >= 1900 & ep_data$Date <= 2015, select=c(CAPE, Return))

# Subset for next 1 year period
ep_next_year <- subset(ep_data, ep_data$Date >= as.Date("2015-01-01") & ep_data$Date < as.Date("2016-01-01"), select=c(CAPE, Return))

# Fit an OLS regression model
ols_fit1 <- lm(Return ~ CAPE, data = ep_sub)

# Predict next 1 year period returns
predict(ols_fit1, newdata = ep_next_year)

###############
# Fit a linear regression model
ols_fit10 <- lm(Return ~ CAPE, data = ep_sub)

# Predict future returns for next 10 years
newdata <- data.frame(CAPE = rep(mean(ep_sub$CAPE), 10))
tenyear <- predict(ols_fit10, newdata)

# Extract regression coefficients
beta1 <- coefficients(ols_fit1)[2]
# Calculate t-statistic and p-value
summary(tenyear)

# Calculate R-squared
r_squared_1year <- summary(ols_fit1)$r.squared
r_squared_11year <- summary(ols_fit10)$r.squared



