# Method_1:
# read the entire csv

data_full <- read.csv("Desktop/household_power_consumption.txt",header = T,
                      sep=";", na.strings = "?",nrows=2075259,check.names = F,
                      stringsAsFactors = F, comment.char = "",quote = '\"')
# extract specific data
                     
data1 <- subset(data_full, Date %in% c("1/2/2007","2/2/2007"))

data1$Date <- as.Date(data1$Date, format = "%d/%m/%Y")

# construct a histogram

hist(data1$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "Red")

# save as a png
png("plot1.png", width=480, height=480)
dev.off()


# Method_2:
# call library dplyr
library(dplyr)

if(!file.exists("datasets/household_power_consumption.txt")){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    dir.create("datasets")
    download.file(url,"datasets/household_power_consumption.zip",method="curl")
    unzip(zipfile = "datasets/household_power_consumption.zip", exdir = "datasets")
}

png("plot1.png", width = 480, height = 480)

data <- read.table("datasets/household_power_consumption.txt",sep = ";",header = TRUE)

hist(as.numeric(unlist(data%>%
                           select(Global_active_power)%>%
                           filter(as.Date(data$Date,"%d/%m/%Y") >= as.Date("2007-02-01") & as.Date(data$Date,"%d/%m/%Y") <= as.Date("2007-02-02")))),
     col = "red",main = "Global Active Power",xlab = "Global Active Power (Kilowatts)")

dev.off()