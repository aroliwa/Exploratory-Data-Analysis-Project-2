
source("data.R")

########################################
# Plot 1

# Have total emissions from PM2.5 decreased in the United States 
# from 1999 to 2008? Using the base plotting system, make a plot 
# showing the total PM2.5 emission from all sources for each of 
# the years 1999, 2002, 2005, and 2008.

data1 <- aggregate(formula = Emissions ~ year, data = NEI, FUN = sum)
barplot(data1$Emissions, 
        names.arg = data1$year, 
        col = "lightblue", 
        space = .1, border = "red",
        xlab = "Year", 
        ylab = "Amount of PM2.5 emitted (in tons)", 
        main = "Total emissions of PM2.5")

########################################
# Plot 2

# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base 
# plotting system to make a plot answering this question.

data2 <- aggregate(formula = Emissions ~ year, data = NEI[NEI$fips == '24510', ], FUN = sum)
barplot(data2$Emissions, 
        names.arg = data2$year, 
        col = "lightblue", 
        space = .1, border = "red",
        xlab = "Year", 
        ylab = "Amount of PM2.5 emitted (in tons)", 
        main = "Total emissions of PM2.5 from all Baltimore City sources")
        

########################################
# Plot 3

# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 
# 1999–2008 for Baltimore City? Which have seen increases 
# in emissions from 1999–2008? Use the ggplot2 plotting 
# system to make a plot answer this question.

library(ggplot2)
library(dplyr)

NEI %>%
    filter(fips == "24510") %>%
    ggplot(aes(as.factor(year), Emissions, fill = type)) +
    geom_bar(stat = "identity") +
    facet_grid( . ~ type) +
    xlab(label = "Year") +
    ylab(label = "Amount of PM2.5 emitted (in tons)") +
    labs(title = "Total emissions of PM2.5 in Baltimore City by source type") +
    theme_light()

########################################
# Plot 4

# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999–2008?

data4 <- inner_join(x = NEI, y = SCC, "SCC") %>%
    filter(grepl("coal", Short.Name, ignore.case = TRUE) )

ggplot(data = data4, aes(as.factor(year), Emissions)) +
    geom_bar(stat = "identity", fill = "lightblue") +
    xlab(label = "Year") +
    ylab(label = "Amount of PM2.5 emitted (in tons)") +
    labs(title = "Total emissions of PM2.5 from coal combustion-related sources") +
    theme_light()


########################################
# Plot 5

# How have emissions from motor vehicle sources 
# changed from 1999–2008 in Baltimore City?

library(dplyr)
library(ggplot2)

NEI %>%
  filter(type == "ON-ROAD" & fips == "24510" ) %>%
  ggplot(aes(x = as.factor(year), y = Emissions)) +
    geom_bar(stat = "identity", fill = "lightblue") +
    xlab(label = "Year") +
    ylab(label = "Amount of PM2.5 emitted (in tons)") +
    labs(title = "Motor vehicle source emissions in Baltimore") +
    theme_light()

########################################
# Plot 6
# 
# Compare emissions from motor vehicle sources in Baltimore 
# City with emissions from motor vehicle sources in Los Angeles 
# County, California (fips == "06037"). Which city has seen 
# greater changes over time in motor vehicle emissions?

NEI %>%
  filter(type == "ON-ROAD" & (fips == "24510" | fips == "06037")) %>%
  ggplot(aes(x = as.factor(year), y = Emissions)) +
    geom_bar(stat = "identity", fill = "lightblue3") +
    xlab(label = "Year") +
    facet_grid(. ~ as.factor(fips)) +
    ylab(label = "Amount of PM2.5 emitted (in tons)") +
    labs(title = "Motor vehicle source emissions in Baltimore (24510) and LA (06037)") +
    theme_light()


