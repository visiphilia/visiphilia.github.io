## load libraries
library(readr)
library(ggplot2)
library(lubridate)
library(ggmap)
library(dplyr)
library(knitr)
library(gridExtra)
library(rvest)

## ----data
pedestrian <- read_csv("data/Pedestrian_Counts.csv",
      col_names=c("DateTime","SensorID","SensorName","Counts"), skip=1)
pedestrian$Date <- as.Date(substr(pedestrian$DateTime, 1, 11), format="%d-%b-%Y")
pedestrian$Year <- year(pedestrian$Date)
pedestrian$Month <- month(pedestrian$Date, label=TRUE, abbr=TRUE)
pedestrian$Day <- wday(pedestrian$Date, label=TRUE) # and re-order days
pedestrian$Day <- factor(pedestrian$Day, levels = levels(pedestrian$Day)[c(2:7, 1)])
pedestrian$Hour <- as.numeric(substr(pedestrian$DateTime, 13, 14))
pedestrian <- pedestrian %>% group_by(SensorID) %>% 
  mutate(Time=as.numeric(Date - min(Date, na.rm=T))*24 + Hour)

## ----trimdata, echo=FALSE, message=FALSE, warning=FALSE, error=FALSE-----
pedestrian <- pedestrian %>% filter(Date >= as.Date("2013-01-01"))

## ---- top of file
head(pedestrian[,c(5,3,4,9)])

## ----locations
sensors <- read_csv("data/Pedestrian_Sensor_Locations.csv")
map <- get_map(location=c(144.955, -37.81), zoom=14, maptype = "roadmap")
ggmap(map) + 
  geom_point(aes(x=Longitude, y=Latitude), data=sensors, size=3, color="darkblue") +
  xlab("") + ylab("") +
  ggtitle("Sensor locations")

## ----timeplots
qplot(factor(Hour), Counts, data=filter(pedestrian, SensorID==1), geom="boxplot") +
  xlab("Hour") + ylab("Count") + theme(aspect.ratio=0.8) +
  ggtitle("Counts by hour")

## ----timeplots-ex1
# Using boxplots
qplot(factor(Hour), Counts, data=filter(pedestrian, SensorID==1), geom="boxplot") +
  xlab("Hour") + ylab("Count") + facet_wrap(~Day, ncol=2) +
  ggtitle("Counts by hour separately day")
# Using line plots - a bit messy
#qplot(Hour, Counts, data=filter(pedestrian, SensorID==1), 
#      group=Date, geom="line") +
#  xlab("Hour") + ylab("Count") + facet_wrap(~Day, ncol=7)

## ----timeplots-ex2
# Using boxplots
#qplot(factor(Hour), Counts, data=filter(pedestrian, SensorID==1), geom="boxplot") +
#  xlab("Hour") + ylab("Count") + facet_grid(Month~Day)
# Using line plots - ideal, I think
qplot(Hour, Counts, data=filter(pedestrian, SensorID==1), 
      group=Date, geom="line") +
  xlab("Hour") + ylab("Count") + facet_grid(Month~Day) +
  ggtitle("Counts by hour separately by month and day")

## ----model1
p.1.2014 <- pedestrian %>% filter(SensorID==1 & Year == 2014)
p.1.f <- lm(Counts~Month+Day+factor(Hour), data=p.1.2014)
summary(p.1.f) 
p.1.1.2016 <- pedestrian %>% filter(SensorID==1 & Month == "Jan" & Year == 2016)
p.1.1.2016$predCounts <- predict(p.1.f, p.1.1.2016)
qplot(Time, Counts, data=p.1.1.2016, geom="line") + 
  geom_line(aes(y=predCounts), color="blue", alpha=0.5) +
  xlab("Time (in Hours since first day)") + 
  ggtitle("Observed and modeled counts")

## ----allsensorsTues
p.all.3.1.2016 <- pedestrian %>% filter(Year == 2016 & Month == "Jan" & Day == "Tues")
qplot(Hour, Counts, data=p.all.3.1.2016, 
      group=Date, geom="line") +
  xlab("Hour") + ylab("Count") + facet_wrap(~SensorName, ncol=6) + 
  ggtitle("All sensors, Tuesdays, Jan 2016")

## ----allsensorsSat
p.all.7.1.2016 <- pedestrian %>% filter(Year == 2016 & Month == "Jan" & Day == "Sat")
qplot(factor(Hour), Counts, data=p.all.7.1.2016, 
      group=Date, geom="line") +
  xlab("Hour") + ylab("Count") + facet_wrap(~SensorName, ncol=6) + 
  ggtitle("All sensors, Saturdays, Jan 2016")

## ----allsensorsTues2
p.all.3.1.2016 <- pedestrian %>% filter(Year == 2016 & Month == "Jan" & Day == "Tues")
qplot(Hour, Counts, data=p.all.3.1.2016, 
      group=Date, geom="line") +
  xlab("Hour") + ylab("Count") + facet_wrap(~SensorName, ncol=6, scales="free_y") + 
  ggtitle("All sensors, Tuesdays, Jan 2016 (individual scales)")

## ----allsensorsSat2
p.all.7.1.2016 <- pedestrian %>% filter(Year == 2016 & Month == "Jan" & Day == "Sat")
qplot(Hour, Counts, data=p.all.7.1.2016, 
      group=Date, geom="line") +
  xlab("Hour") + ylab("Count") + facet_wrap(~SensorName, ncol=6, scales="free_y") + 
  ggtitle("All sensors, Saturdays, Jan 2016 (individual scales)")

## ----student plots
# Team 6
p.3.6.9.13 <- pedestrian %>% filter((SensorID == 3 | SensorID == 6 | SensorID == 9 | SensorID == 13) & Month == "Jan" & Year == 2016)
p.3.6.9.13$weekday <- "weekday"
p.3.6.9.13$weekday[p.3.6.9.13$Day == "Sat" | p.3.6.9.13$Day == "Sun"] <- "weekend"
ggplot(p.3.6.9.13, aes(x=Hour, y=Counts, colour=weekday, group=Date)) + geom_line() +
  +   facet_wrap(~SensorName, ncol=4)

# Team 5
p.26.2014 <- pedestrian %>% filter(SensorID == 26  & Year == 2014)
ggplot(p.26.2014, aes(x=factor(Hour), y=Counts)) + geom_boxplot() +
  facet_wrap(~Day, ncol=2) + xlab("Hour")
p.27.2014 <- pedestrian %>% filter(SensorID == 27  & Year == 2014)
ggplot(p.27.2014, aes(x=factor(Hour), y=Counts)) + geom_boxplot() +
  facet_wrap(~Day, ncol=7) + xlab("Hour")
p.1.2014 <- pedestrian %>% filter(SensorID == 1  & Year == 2014)
ggplot(p.1.2014, aes(x=factor(Hour), y=Counts)) + geom_boxplot() +
  facet_wrap(~Day, ncol=7) + xlab("Hour")

# Team 10
p.Sep.2014 <- pedestrian %>% filter(Month == "Sep"  & Year == 2014 & Day == "Sat")
p.Sep.2014$final <- "normal"
p.Sep.2014$final[p.Sep.2014$Date == as.Date("2014-09-27")] <- "grandfinalday"
p.Sep.2014$final <- factor(p.Sep.2014$final, levels=c("normal", "grandfinalday"))
ggplot(p.Sep.2014, aes(x=Hour, y=Counts, group=Date)) + geom_line(alpha=0.6) +
  facet_wrap(~SensorName, ncol=7) + 
  geom_line(data=filter(p.Sep.2014, final == "grandfinalday"), color="red") 

# Team 11
p.Dec.2013 <- pedestrian %>% filter(SensorID ==1 & Month == "Dec"  & Year == 2013)
ggplot(p.Dec.2013, aes(x=Hour, y=Counts, group=Date, color=Day)) + geom_line() 

