getwd()
setwd("C:/Users/Mark Account/Documents/Software/Coursera/Exploratory Data Analysis/Project2")

library(dplyr)
library(ggplot2)

png(file = "plot4.png")

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


#subset SCC codes, only want those sources that are related to "Combustion" and "Coal"
subdata <- description[grep("Combustion", description$SCC.Level.One), ]
subdata2 <- subdata[grep("Coal", subdata$SCC.Level.Three),]

#merge data sets, using SCC code as primary-foreign key.
mergeddata <- merge(mydata, subdata2, by.x = "SCC", by.y = "SCC", all = F)

#group dataframe by year

mydata_grouped_year <- group_by(mergeddata, year)

#summarize dataframe by year and calculate Total Emissions for each year

mydata_year_total <- summarise(mydata_grouped_year, totalEmissions = sum(Emissions, na.rm = T))

#turns summarised result into a data frame object, so it can be graphed
mydata_year_total2 <- data.frame(mydata_year_total)

#converts the total emissions variable into scale by thousands
mydata_year_total2$TotalEmissions <- mydata_year_total2$totalEmissions / 1000

#creates the plot
plot(mydata_year_total2$year, mydata_year_total2$TotalEmissions, type = "l", main = "Total PM25 Emissions from Coal-Combustion Sources", xlab = "Year", ylab = "Total Emissions (thousands of tons)", ylim = c(0, 800))

dev.off()










