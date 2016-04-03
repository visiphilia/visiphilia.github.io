---
layout: post
title: "Pedestrian patterns in Melbourne CBD"
author: visnut
tags: [education,statistics,EDA,data mining,R,statistical computing,statistical graphics,data wrangling]
---
{% include JB/setup %}

Thursday was a challenging day. I was somewhat nervous about working with approximately 60 high school seniors from across Melbourne, spread across three computer labs at Monash University on Clayton campus, working with [R](www.r-project.org) and the pedestrian sensor data that is available on [Open Data Melbourne](https://data.melbourne.vic.gov.au/Transport-Movement/Pedestrian-Counts/b2ak-trbp). The task was to examine the hourly counts of pedestrians taken from sensors spread around the city, some of which have been recording since 2009. No-one had used R before. 

### Preliminary descriptions

![map]({{ site.url }}/assets/pedestrians/locations.png)

We started by reading in the data from the full csv download, the top few lines look like:

```
> pedestrian <- read_csv("data/Pedestrian_Counts.csv",
      col_names=c("DateTime","SensorID","SensorName","Counts"), skip=1)
> head(pedestrian)
Source: local data frame [6 x 4]

           DateTime SensorID                 SensorName Counts
              (chr)    (int)                      (chr)  (int)
1 01-MAY-2009 00:00        4           Town Hall (West)    209
2 01-MAY-2009 00:00       17      Collins Place (South)     28
3 01-MAY-2009 00:00       18      Collins Place (North)     36
4 01-MAY-2009 00:00       16       Australia on Collins     22
5 01-MAY-2009 00:00        2 Bourke Street Mall (South)     52
6 01-MAY-2009 00:00        1 Bourke Street Mall (North)     53

```

Followed by using `lubridate` to process the date into more useful and meaningful units:

```
> pedestrian$Date <- as.Date(substr(pedestrian$DateTime, 1, 11), format="%d-%b-%Y")
> pedestrian$Year <- year(pedestrian$Date)
> pedestrian$Month <- month(pedestrian$Date, label=TRUE, abbr=TRUE)
> pedestrian$Day <- wday(pedestrian$Date, label=TRUE) # and re-order days
> pedestrian$Day <- factor(pedestrian$Day, levels = levels(pedestrian$Day)[c(2:7, 1)])
> pedestrian$Hour <- as.numeric(substr(pedestrian$DateTime, 13, 14))
> pedestrian <- pedestrian %>% group_by(SensorID) %>% 
+   mutate(Time=as.numeric(Date - min(Date, na.rm=T))*24 + Hour)
> pedestrian <- pedestrian %>% filter(Date >= as.Date("2013-01-01"))
> head(pedestrian)
Source: local data frame [6 x 10]
Groups: SensorID [6]

           DateTime SensorID                 SensorName Counts       Date  Year  Month    Day  Hour  Time
              (chr)    (int)                      (chr)  (int)     (date) (dbl) (fctr) (fctr) (dbl) (dbl)
1 01-JAN-2013 00:00        4           Town Hall (West)   2992 2013-01-01  2013    Jan   Tues     0 32184
2 01-JAN-2013 00:00       17      Collins Place (South)    979 2013-01-01  2013    Jan   Tues     0 32184
3 01-JAN-2013 00:00       18      Collins Place (North)    413 2013-01-01  2013    Jan   Tues     0 32184
4 01-JAN-2013 00:00       16       Australia on Collins    807 2013-01-01  2013    Jan   Tues     0 32184
5 01-JAN-2013 00:00        2 Bourke Street Mall (South)    785 2013-01-01  2013    Jan   Tues     0 32184
6 01-JAN-2013 00:00        1 Bourke Street Mall (North)    651 2013-01-01  2013    Jan   Tues     0 32184

```

We also subset the data to ignore counts before January 2013, because the counts were more consistently measured in recent years. To start simply only counts for one location, sensor 1, Bourke Street Mall (North), were examined. Here are a few pictures. 

![hourly]({{ site.url }}/assets/pedestrians/timeplots-1.png)

These are side-by-side boxplots of counts by hour of day at this location, for all days. You can see there are rarely pedestrians between midnight and 6am, but numbers start climbing from 7am through noon, staty fairly flat until 5pm and then decline rapidly as the evening progresses. There are some large counts, which can be seen later to come from ["White Night"](http://whitenightmelbourne.com.au).

![day]({{ site.url }}/assets/pedestrians/timeplots-ex1-1.png)

These are side-by-side boxplots of counts by hour of day at this location, separately by day of week. A different week day to weekend pattern can be seen. On the weekends there is a steady increase  in counts to mid-afternoon and then a slow decrease. The outliers (white night) were on a Saturday evening, and Thursday has a pattern of high counts, which we cannot yet provide an explanation.

![day-month]({{ site.url }}/assets/pedestrians/timeplots-ex2-1.png)

This plot breaks down the counts by day of the week and month, and connects values for each day as a line. The February, Saturday, White night events can be seen. The high counts for Thursday correspond to December, actually can be worked out to be Christmas Eve 2015. The week day to weekend pattern is still visible. There is a difference in the variability in counts from month to month, with December being the most variable from ewek to week. You can see some public holidays, lines of low counts on Fridays in January, March and April. 

### What did the high school students find?

The students were tasked with coming up with some questions that they'd like to answer with the data, and make the appropriate plots and analysis to answer their questions. The results were very impressive.

Team 6 (Matthew, Jackson, Daniel, Ivy, Clare and Hanze) tackled the question "Does the pedestrian count around the train stations differ during weekends and weekdays?" They made this plot of four sensor locations. 

![team6]({{ site.url }}/assets/pedestrians/team6.png)

The plot shows the counts for the four train stations for January 2016, with weekend vs week days differentiated by colour.  Flagstaff, Flinders Steet and Southern Cross stations show the distinct difference in patterns, but Melbourne Central has a similar pattern regardless of the type of day. Flinders Street has a different pattern but it is still very busy on a weekend, just later in the day. Flagstaff and Southern Cross are very quiet on weekends. 

Team 8 (Jason, Nicky, Leander, Michael and Zoe) compared pedestrian traffic at Flinders St station with the Bourke St Mall (shown earlier) and noticed the triple peak week day pattern at Flinders. 

Team 3 (Ruth, Evelyn, Alex and Reuben) also looked at train station traffic (Flinders vs Melbourne Central) using side-by-side boxplots which exaggerated the weekday/end difference at Flinders station, in the timing of peak traffic, and lack of difference at Lembourne Central. 

Team 5 (Erin, Sarah, Fiona, Zak, and Wencheng) asked if the Queen Vic market pedestrian traffic (also a shopping area) was similar to the Bourke Street Mall. They suspected a different pattern between the two, with QV being more a weekend location, less central to the city, and with no name, small businesses. 

![team5]({{ site.url }}/assets/pedestrians/team5-bourke.png)
![team5]({{ site.url }}/assets/pedestrians/team5-QV.png)

And they noticed a big difference form the side-by-side boxplots. QV is quiet on week days, but has a strong peak on some Wednesdays which corresponds to the summer Wednesday "night markets". White night can be seen at both locations. Bourke Street Mall is the busier shopping area by overall count. 

Team 10 (William, James, Irene and Genevieve) compared pedestrian traffic at all locations on grand final day (red in plot below) with all other Saturdays in September. 

![team10]({{ site.url }}/assets/pedestrians/team10.png)

Despite what we might think, the city does NOT come to a standstill. The pedestrian traffic is slightly lower than usual in the main shopping areas, e.g Bourke Street Mall, and Flinders St counts peak earlier around 11am, with people heading to the 2:30pm game at the MCG. Princes Bridge shows a peak around 4:30-5:00pm - maybe people heading home from watching the game in the pubs. 

Team 11 (Jessica, Hua, Glenn and Eric) examined pedestrian patterns in the Bourke Street Mall during December 2013. 

![team11]({{ site.url }}/assets/pedestrians/team11.png)

Christmas Eve, Day and Boxing Day are detectable in this plot. Christmas Eve (Tue, olive) has an uusual peak around 2pm - a lot of people running to do last minute shopping before shops close. Christmas Day (Fri, green) is the low count line, where half the normal number of people are out and about. Boxing Day is the high count line that starts early and peaks around 3pm - lots of people taking advantage of sales. 

Team 1 (Alex, Xavier, Renecia and Katie) found a unusual spike in counts at three locations between 5-7am on May 22 2009. 

![team1]({{ site.url }}/assets/pedestrians/team1.png)

There was no obvious reason for this, such as an early morning athletic event, to be found using google search. 

Team 4 (Isabella, Milly, Aravind, Sarath and William) looked at times of heaviest foot traffic in all locations to suggest times that extra security should be employed for safety of citizens. 

Team 12 (nicknamed JACCHammers, Janet, Justin, Andrew, Clare, Chathura and Hasini) went after low pedestrian counts at all locations to recommend times when construction would provide the least disturbance of pedestrian activity. 

### Sustainability theme

- Relieve the pressure on Flinders Street by placing more weekend activities or tourist locations near Southern Cross and Flagstaff stations. 
- Placing more sensors around Southern Cross and Melbourne Central could help study flow of pedestrians. There are clearly a lot of people entering the city through these ports, especially on weekdays, but there is a big spatial gap in sensors in these neighborhoods making it hard to see where people go after these points.

### Acknowledgements

Three PhD students and one undergraduate student TA'd the labs, and guided the students with their Monash University undergrad mentors through the analysis: [Carson Sievert](http://cpsievert.github.io), [Earo Wang](https://github.com/earowang), [Nathaniel Tomasetti](https://github.com/ntomasetti) and [Mitch O'Hara-Wild](https://github.com/mitchelloharawild).

Data and analyses were made possible with open data and open source software. The data was extracted from [Melbourne Open Data](https://data.melbourne.vic.gov.au/Transport-Movement/Pedestrian-Counts/b2ak-trbp). Analysis and plots were made using these R packages: `dplyr`, `ggplot2`, `knitr`, `lubridate`, `readr`, `tidyr`.

The Monash Big Data Challenge Day was organised by Kate Galati and Stephanie Hah. 

[Here is the script]({{ site.url }}/assets/pedestrians/data-analytics-worksheet.R)  for reproducing the plots shown, used on the data downloaded from the csv file from  [Melbourne Open Data](https://data.melbourne.vic.gov.au/Transport-Movement/Pedestrian-Counts/b2ak-trbp).
