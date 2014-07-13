# This is the first part of project 1.

data <- read.csv("household_power_consumption.txt", 
                 sep=";", 
                 stringsAsFactors=TRUE, 
                 header=TRUE, 
                 na.strings="?"
                 )

# date in format "dd/mm/yyyy", or in this case d/m/yyyy.
dateSelect <- (data[,"Date"] == "1/2/2007") | (data[,"Date"] == "2/2/2007")
febData <- data[dateSelect,]

# pedantic
plotSelect <- (!is.na(febData[,"Global_active_power"]))
plotData <- febData[plotSelect,"Global_active_power"]

# impure open PNG output
png(file = "plot1.png",
    width = 480,
    height = 480
    )

# the plotting command, histogram in red, for Global Active Power
# "Frequency" is the default y-label.
# As an electrical engineer, I would find "Frequency" confusing here
# as it is also a term used in power measurements.
hist(plotData, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power"
     )

# close png graphics driver
dev.off()
