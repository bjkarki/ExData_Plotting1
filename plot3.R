
## Downloading required file if not available in the working directory
if (!file.exists("household_power_consumption.txt")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        zipFile <- "household_power_consumption_zipfile.zip"
        download.file(fileUrl, zipFile, method = "curl")
        unzip(zipFile)
        unlink(zipFile, recursive = TRUE)
        rm(zipFile, fileUrl)
}

## Installing & loading required library
if(!require("dplyr")) {
        install.packages("dplyr")
}
library(dplyr)

# Loading data as table
epcFile <- "household_power_consumption.txt"
rawData <- read.table(epcFile, header = TRUE, sep = ";", stringsAsFactors = FALSE, na.strings = "?")
rm(epcFile)

# Loading required Data
requiredData <- rawData %>% tbl_df %>% filter(Date %in% c("1/2/2007","2/2/2007"))
rm(rawData)

# Turning date & time data into right class
dateTime <- requiredData %>% select(Date, Time)
dateTime <- strptime(paste(dateTime$Date,dateTime$Time), format = "%d/%m/%Y %H:%M:%S")

# Plotting

## Assigning graphing device and its properties
png("plot3.png",width = 480, height = 480, units = "px", bg = "transparent")

## Actual plots
plot(dateTime, requiredData$Sub_metering_1, 
     col = "black", type = "l",
     xlab = "",ylab = "Energy sub metering")
lines(dateTime, requiredData$Sub_metering_2, 
     col = "red", type = "l")
lines(dateTime, requiredData$Sub_metering_3, 
      col = "blue", type = "l")

## Legend
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"), lty = 1)

# Closing off
dev.off()