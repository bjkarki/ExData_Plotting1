
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

# Loading the plot.
png("plot1.png",width = 480, height = 480, units = "px", bg = "transparent")
hist(requiredData$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()