getwd()
setwd("C:/Users/Mark Account/Documents/Software/Coursera/Exploratory Data Analysis/Project2")

#purpose: to plot PM25 emission from motor vehicles in Baltimore from 1999-2008

library(dplyr)
library(ggplot2)

png(file = "plot5.png")

#download raw data from internet, if not already done.

if(!file.exists("./Project_2_RawData.zip")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileUrl, destfile = "./Project_2_RawData.zip")
    #unzips file and extracts it in same directory level.
    unzip("./Project_2_RawData.zip")
    
}

#create data frames out of the two data table files
mydata <- readRDS("summarySCC_PM25.rds")
description <- readRDS("Source_Classification_Code.rds")

#convert year & type variables to categorical vectors
mydata$year <- as.factor(mydata$year)
mydata$type <- as.factor(mydata$type)


#subset SCC codes, only want those sources that are related to "Mobile" and "Vehicle"

subdata <- description[grep("Mobile", description$SCC.Level.One), ]
subdata2 <- subdata[grep("Vehicle", subdata$SCC.Level.Two),]

#subset mydata to only include 24510 Batimore City
mydata2 <- mydata[mydata$fips == "24510",]

#merge data sets, using SCC code as primary-foreign key.
mergeddata <- merge(mydata2, subdata2, by.x = "SCC", by.y = "SCC", all = F)


#group data by year, total emissions by year
grouped_data <- group_by(mergeddata, year)
summarized_grouped <- summarise(grouped_data, TotalEmissions = sum(Emissions))

#convert summarized data as a data frame, finaldata

finaldata <- data.frame(summarized_grouped)

#plot with ggplot2

p <- ggplot(finaldata, aes(year, TotalEmissions, group = 1))

p2 <- p + geom_point() + geom_smooth()

p2 <- p2 + labs(title = "Total Motor Vehicle Emissions in Baltimore from 1999-2008")
p2 <- p2 + labs(y = "Total Emissions (tons)")
p2

dev.off()
