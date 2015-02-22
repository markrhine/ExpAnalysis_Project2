getwd()
setwd("C:/Users/Mark Account/Documents/Software/Coursera/Exploratory Data Analysis/Project2")

#purpose: to plot the total PM25 emissions in Baltimore City from 199-2008

library(dplyr)

png(file = "plot2.png")

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

#convert year variable to a catgorical vector
mydata$year <- as.factor(mydata$year)

#subset data to only include Baltimore, code 24510
mydata2 <- mydata[mydata$fips == "24510",]

#group data by year
mydata_grouped_year <- group_by(mydata2, year)

#total Emissions by year
mydata_year_total <- summarise(mydata_grouped_year, totalEmissions = sum(Emissions, na.rm = T))

#convert summarized data into a data frame
mydata_year_total2 <- data.frame(mydata_year_total)

mydata_year_total2$TotalEmissions <- mydata_year_total2$totalEmissions 

#plot
plot(mydata_year_total2$year, mydata_year_total2$TotalEmissions, type = "l", main = "Total PM25 Emissions in Baltimore City by Year", xlab = "Year", ylab = "Total Emissions (tons)", ylim = c(0, 5000))

dev.off()

