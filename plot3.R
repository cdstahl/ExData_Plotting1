# This is the third part of project 1.

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

# pedantic
plotBlackSelect <- (!is.na(convData[,"Sub_metering_1"]))
plotBlackData   <- convData[plotBlackSelect,c("Sub_metering_1", "DateTime")]

plotRedSelect   <- (!is.na(convData[,"Sub_metering_2"]))
plotRedData     <- convData[plotRedSelect,c("Sub_metering_2", "DateTime")]

plotBlueSelect  <- (!is.na(convData[,"Sub_metering_3"]))
plotBlueData    <- convData[plotBlueSelect,c("Sub_metering_3", "DateTime")]

# impure open PNG output
png(file = "plot3.png",
    width = 480,
    height = 480
    )

# For no reason, there will be no title.  (also no xlab)
#
plot(plotBlackData[,"DateTime"], plotBlackData[,"Sub_metering_1"],
     type = "l",
     col = "black",
     ylab = "Energy sub metering",
     xlab = "",
     main = ""
     )

# plot is an impure function
lines(plotRedData[,"DateTime"], plotRedData[,"Sub_metering_2"],
     col = "red"
     )

# plot is still an impure function (if you look closely, blue is preferred
# over red, and red over black)
lines(plotBlueData[,"DateTime"], plotBlueData[,"Sub_metering_3"],
      col = "blue",
      )

# legend
legend("topright",
       col    = c("black",          "red",            "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1,
       cex = 0.75
       )

# close png graphics driver
dev.off()

# I'm not sure what this plot intends to show.  The units on the y-axis are
# in energy (kWh is power*time), the x-axis is in time.  The area under the
# curves would be in energy*time.  
#
# As a plot of energy over time, the interpretation becomes humorous.  Notice
# that the plot is not monotonic.  This implies the house regularly produces
# power to exactly offset what it just used.

