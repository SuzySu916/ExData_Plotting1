# Method_1:

data_full <- read.csv("Desktop/household_power_consumption.txt", header=T, sep=';', na.strings="?", 
                      nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
data1 <- subset(data_full, Date %in% c("1/2/2007","2/2/2007"))
data1$Date <- as.Date(data1$Date, format="%d/%m/%Y")
datetime <- paste(as.Date(data1$Date), data1$Time)
data1$Datetime <- as.POSIXct(datetime)

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(data1, {
    plot(Global_active_power ~ Datetime, type = "l",
         ylab="Global Active Power (kilowatts)", xlab="")
    plot(Voltage~Datetime, type = "l",
         ylab="Voltage (volt)", xlab="")
    plot(Sub_metering_1~Datetime, type="l", 
         ylab="Global Active Power (kilowatts)", xlab="")
    lines(Sub_metering_2~Datetime,col='Red')
    lines(Sub_metering_3~Datetime,col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),cex=0.5)
    plot(Global_reactive_power~Datetime, type="l", 
         ylab="Global Rective Power (kilowatts)",xlab="")
})
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()


# Method_2:

library(dplyr)

if(!file.exists("datasets/household_power_consumption.txt")){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    dir.create("datasets")
    download.file(url,"datasets/household_power_consumption.zip",method="curl")
    unzip(zipfile = "datasets/household_power_consumption.zip", exdir = "datasets")
}

png("plot4.png", width = 480, height = 480)

data <- read.table("datasets/household_power_consumption.txt",sep = ";",header = TRUE)

data1 <- data%>%filter(as.Date(data$Date,"%d/%m/%Y") >= as.Date("2007-02-01") & as.Date(data$Date,"%d/%m/%Y") <= as.Date("2007-02-02"))

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 0, 0))

## Plot 1

plot(strptime(paste(data1$Date,data1$Time),"%d/%m/%Y %H:%M:%S"),as.numeric(data1$Global_active_power),type = "l",xlab = "",ylab = "Global Active Power (kilowatts)")

## Plot 2

plot(strptime(paste(data1$Date,data1$Time),"%d/%m/%Y %H:%M:%S"),as.numeric(data1$Voltage),type = "l",xlab = "datetime",ylab = "Voltage")

## Plot 3

plot(strptime(paste(data1$Date,data1$Time),"%d/%m/%Y %H:%M:%S"),as.numeric(data1$Sub_metering_1),type = "l",xlab = "",ylab = "Energy sub metering")

points(strptime(paste(data1$Date,data1$Time),"%d/%m/%Y %H:%M:%S"),as.numeric(data1$Sub_metering_2),col="red",type = "l")

points(strptime(paste(data1$Date,data1$Time),"%d/%m/%Y %H:%M:%S"),as.numeric(data1$Sub_metering_3),col="blue",type = "l")

legend("top",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lwd=2, cex = 0.7, bty = "n")

## Plot 4

plot(strptime(paste(data1$Date,data1$Time),"%d/%m/%Y %H:%M:%S"),as.numeric(data1$Global_reactive_power),type = "l",xlab = "datetime",ylab = "Global_reactive_power")

dev.off()
