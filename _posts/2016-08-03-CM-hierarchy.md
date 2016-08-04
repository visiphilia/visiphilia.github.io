---
layout: post
title: "Modern Crowd-Sourcing and Cleveland-McGill's graphical hierarchy"
author: visnut
tags: [education,statistics,R,statistical computing,statistical graphics,data wrangling,visual perception]
---
{% include JB/setup %}

2016 [Statistical Computing](http://stat-computing.org/computing/) and [Graphics](http://stat-graphics.org/graphics/) Award Honored William S. Cleveland for his many contributions to data visualisation and data science. In the session at the [joint statistical meetings](https://www.amstat.org/meetings/jsm/2016/), we did a re-run of the experiment. 

### Hierarchy of graphical mappings

The paper, [Cleveland and McGill (1984)](https://www.jstor.org/stable/2288400?seq=1#page_scan_tab_contents), reported on results from an experiment on ways to map data that enables the reader to accurately return the original data values. The end results was the following hierarchy of mappings from most accurate to least:

1. Position along a common scale e.g. scatter plot, bar chart
2. Position on identical but nonaligned scales e.g. bars on spatial map in 3D, facetted plots, stacked bars
3. Length e.g. candlestick plots, boxplots
4. Angle, slope e.g. pie chart
5. Area e.g. bubble chart
6. Volume, curvature, shading e.g. glyphs
7. Color hue e.g. heatmap, chloropleth map

[Heer and Bostock (2010)](http://vis.stanford.edu/files/2010-MTurk-CHI.pdf) ran a very similar experiment using subjects from Amazon's Mechanical Turk, and effectively reproduced CM84's results.

### Stimuli

The audience was asked to answer two questions for a sequence of plots:

- Which is bigger `a` or `b`?
- How much bigger? (2x, 1.5x, ...)

Here are some examples of plots in the survey.

![](https://dicook.github.io/JSM16/set1_bar.png)
![](https://dicook.github.io/JSM16/set2_bubble.png)
![](https://dicook.github.io/JSM16/set3_pie.png)
![](https://dicook.github.io/JSM16/set4_color.png)
![](https://dicook.github.io/JSM16/set5_unaligned.png)

Five sets of data were generated. The survey is still available at: [http://bit.ly/JSM-vis16](http://bit.ly/JSM-vis16).

### Results

90 people filled in the survey.

The first question is measuring whether the reader can select the larger of the two elements from the different displays. 

![](https://dicook.github.io/JSM16/accuracy-table.png)

The table shows the proportion correct by the plot type for each set of data. Plot type columns are sorted by overall proportion, so from most accurately picked the larger slice, bar, circle, or lighter color. It shows that people were more accuarate for bar charts, but almost as accurate with pie charts and bubble charts. A substantial drop in correct choice for color and unaligned bars. The same information is shown in barchart form below:

![](https://dicook.github.io/JSM16/accuracy-barchart.png)


This yields a hierarchy:

1. Position along a common scale
2. Angle
3. Area 
4. Color hue 
5. Position on identical but nonaligned scales 

This is exactly the order reported by CM84. 

For the second question, we differenced the reported ratio with the true ratio, and plotted these against the plot type. Closer to the zero line would indicate more accurate recognition of the relative size. 

![](https://dicook.github.io/JSM16/differences-boxplot.png)

The plot order matches the table. Barcharts are centered and concentrated at 0. The difference for pie charts are very close to zero, but mostly above and with more variability. It suggests people tend to over-estimate the ratio. Bubble charts have differences close to zero too, but on the lower size, suggesting that people might under-estimate the ratio. Color is similar to bubble charts, perhaps under-estimating the ratio. Differences for unaligned bars are mostly above zero, with more variability than other plot types.  The results would suggest the same hierarchy as above (1) Position along a common scale (2) Angle (3) Area (4) Color hue (5) Position on identical but nonaligned scales, although color and unaligned are virtually tied.

### Conclusion

Yes, we validated Cleveland and McGill's hierarchy (almost) in the space of 20 minutes using crowd-sourcing!

### Resources

Full code and plots and report are available at [https://github.com/dicook/JSM16](https://github.com/dicook/JSM16).
