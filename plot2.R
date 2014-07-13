# This is the second part of project 1.

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
plotSelect <- (!is.na(convData[,"Global_active_power"]))
plotData <- convData[plotSelect,c("Global_active_power", "DateTime")]

# impure open PNG output
png(file = "plot2.png",
    width = 480,
    height = 480
    )

# For no reason, there will be no title.  (also no xlab)
#
plot(plotData[,"DateTime"], plotData[,"Global_active_power"],
     type = "l",
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     main = ""
     )

# close png graphics driver
dev.off()
