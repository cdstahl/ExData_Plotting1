# This is the fourth part of project 1.

data <- read.csv("household_power_consumption.txt", 
                 sep=";", 
                 stringsAsFactors=TRUE, 
                 header=TRUE, 
                 na.strings="?"
)

# date in format "dd/mm/yyyy", or in this case d/m/yyyy.
dateSelect <- (data[,"Date"] == "1/2/2007") | (data[,"Date"] == "2/2/2007")
febData <- data[dateSelect,]

# Here is the converted data.  In this case, the transform function will
# add a new column called DateTime.  This column is defined by the
# conversion of the concatenation of Date + " " + Time with a format
# defined by "%d/%m/%Y %H:%M:%S".  Note that %m isn't the same as %M.
#
# I'm not 100% on the best style for lambdas, but this isn't the worst.
convData <- transform(febData, 
                      DateTime = strptime(paste(Date,
                                                Time, 
                                                sep = " "
                      ), 
                      format = "%d/%m/%Y %H:%M:%S"
                      )
)

# Upper Left
plotULSelect <- (!is.na(convData[,"Global_active_power"]))
plotULData <- convData[plotULSelect,c("Global_active_power", "DateTime")]

# Upper Right
plotURSelect <- (!is.na(convData[,"Voltage"]))
plotURData <- convData[plotURSelect,c("Voltage", "DateTime")]

# Lower Left
plotLLBlackSelect <- (!is.na(convData[,"Sub_metering_1"]))
plotLLBlackData   <- convData[plotLLBlackSelect,c("Sub_metering_1", "DateTime")]

plotLLRedSelect   <- (!is.na(convData[,"Sub_metering_2"]))
plotLLRedData     <- convData[plotLLRedSelect,c("Sub_metering_2", "DateTime")]

plotLLBlueSelect  <- (!is.na(convData[,"Sub_metering_3"]))
plotLLBlueData    <- convData[plotLLBlueSelect,c("Sub_metering_3", "DateTime")]

# Lower Right
plotLRSelect <- (!is.na(convData[,"Global_reactive_power"]))
plotLRData <- convData[plotLRSelect,c("Global_reactive_power", "DateTime")]

# impure open PNG output
png(file = "plot4.png",
    width = 480,
    height = 480
    )

# Set subplot arrangement
par(mfrow = c(2,2))

# Upper Left
# notice that the units are not present, unlike in Plot2.
plot(plotULData[,"DateTime"], plotULData[,"Global_active_power"],
     type = "l",
     col = "black",
     ylab = "Global Active Power",
     xlab = "",
     main = ""
     )

# Upper Right
# agin, no units.  the xlabel will also be called "datetime"
plot(plotURData[,"DateTime"], plotURData[,"Voltage"],
     type = "l",
     col = "black",
     ylab = "Voltage",
     xlab = "datetime",
     main = ""
     )

# Lower Left
# notice the lack of a box around the legend
plot(plotLLBlackData[,"DateTime"], plotLLBlackData[,"Sub_metering_1"],
     type = "l",
     col = "black",
     ylab = "Energy sub metering",
     xlab = "",
     main = ""
     )

# plot is an impure function
lines(plotLLRedData[,"DateTime"], plotLLRedData[,"Sub_metering_2"],
      col = "red"
      )

# plot is still an impure function (if you look closely, blue is preferred
# over red, and red over black)
lines(plotLLBlueData[,"DateTime"], plotLLBlueData[,"Sub_metering_3"],
      col = "blue",
      )

# legend
legend("topright",
       col    = c("black",          "red",            "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = 'n',
       lty = 1,
       cex = 0.75
       )

# Lower Right
# Again, no units, no nice name for either axis.
plot(plotLRData[,"DateTime"], plotLRData[,"Global_reactive_power"],
     type = "l",
     col = "black",
     ylab = "Global_reactive_power",
     xlab = "datetime",
     main = ""
     )

# close png graphics driver
dev.off()
