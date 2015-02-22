getwd()
setwd("C:/Users/Mark Account/Documents/Software/Coursera/Exploratory Data Analysis/Project2")

#purpose: to plot total emissions from PM2.5 in the United States from 1999 to 2008.

png(file = "plot1.png")

#download raw data files if not already downloaded

if(!file.exists("./Project_2_RawData.zip")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileUrl, destfile = "./Project_2_RawData.zip")
    #unzips file and extracts it in same directory level.
    unzip("./Project_2_RawData.zip")
    
}

#turn raw data files into data frames

mydata <- readRDS("summarySCC_PM25.rds")
description <- readRDS("Source_Classification_Code.rds")

#convert year variable into a categrical factor variable
mydata$year <- as.factor(mydata$year)


library(dplyr)

#group data frame by year

mydata_grouped_year <- group_by(mydata, year)

mydata_year_total <- summarise(mydata_grouped_year, totalEmissions = sum(Emissions, na.rm = T))

#convert ummarized data into a data frame
mydata_year_total2 <- data.frame(mydata_year_total)

#Scaling the y values, Emissions down to millions, for ease of graphing
mydata_year_total2$TotalEmissions <- mydata_year_total2$totalEmissions / 1000000

#create plot using base plot
plot(mydata_year_total2$year, mydata_year_total2$TotalEmissions, type = "l", main = "Total U.S. PM25 Emissions by Year", xlab = "Year", ylab = "Total Emissions (millions of tons)", ylim = c(0, 10))


dev.off()








