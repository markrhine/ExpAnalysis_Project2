getwd()
setwd("C:/Users/Mark Account/Documents/Software/Coursera/Exploratory Data Analysis/Project2")

#purpose: to plot total PM25 emissions in Baltimore from 1999-2008 from each source type

library(dplyr)
library(ggplot2)

png(file = "plot3.png")

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

#subset data to only include Baltimore, code 24510
mydata2 <- mydata[mydata$fips == "24510",]

#group data by type, then year
mydata_grouped_year <- group_by(mydata2, type, year)

#summarize rouped data
mydata_year_total <- summarise(mydata_grouped_year, totalEmissions = sum(Emissions, na.rm = T))

#convert summarized data to a data frame
mydata_year_total2 <- data.frame(mydata_year_total)

#plot
g <- ggplot(mydata_year_total2, aes(year, totalEmissions, group = type))
p <- g + geom_point()
f <- p + facet_grid(.~ type)
n <- f + geom_smooth() + labs(title = "Total Emissions by Source in Baltimore") + labs(y = "Total Emissions (tons)")

m <- n + theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=16))
m

dev.off()
