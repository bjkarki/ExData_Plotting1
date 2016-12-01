
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
datetime <- requiredData %>% select(Date, Time)
datetime <- strptime(paste(datetime$Date,datetime$Time), format = "%d/%m/%Y %H:%M:%S")

# Plotting

## Assigning graphing device and its properties

png("plot4.png",width = 480, height = 480, units = "px", bg = "transparent")
par(mfrow = c(2,2), cex = 0.8)

## (1,1)
plot(datetime, requiredData$Global_active_power, type = "l",
     xlab = "", ylab = "Global Active Power")

##(1,2)
plot(datetime, requiredData$Voltage, type = "l", ylab = "Voltage")

##(2,1)
plot(datetime, requiredData$Sub_metering_1, 
     col = "black", type = "l",
     xlab = "",ylab = "Energy sub metering")
lines(datetime, requiredData$Sub_metering_2, 
      col = "red", type = "l")
lines(datetime, requiredData$Sub_metering_3, 
      col = "blue", type = "l")
###legend
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"), lty = 1, 
       bty = "n")

##(2,2)
plot(datetime, requiredData$Global_reactive_power, type = "l", ylab = "Global_reactive_power")

# Closing off
dev.off()