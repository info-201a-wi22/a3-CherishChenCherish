---
title: "index"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
source("../source/analysis.R")

```


## Introduction
In the United States, racial discrimination has long been a hot topic and a source of heated debate. I'd like to learn more about the diverse ethnicities, genders, and jail regions through this data visualization study. I studied the changes in the total number of people of different races in different prisons from 1970 to 2020 in the first graph to understand the changes and trends in the total number of people of different races in different prisons, with AAPI and Native numbers remaining low, Latinx numbers in the middle, and black and white numbers increasing significantly since 1980, while overall the black population in prisons is the largest. In recent years, the prison population has fallen. I drew separate scatter plots for males and females in the second graph to establish the number of different genders in prison, and I discovered that the number of females was substantially lower than the number of males. In the third graph, I compared the area security maps given by the police to find a correlation between the number of people in prison and the security of the area in order to understand the number of people in prison in individual places.


## Summary Description
The average total tail population for all the counties is `r round(avg_total_jail_pop, 2)`, the highest total tail population occured in `r highest_record$county_name`, `r highest_record$state`, the value is `r round(highest_record$total_jail_pop)`. The lowest total tail population occured in `r lowest_record$county_name`, `r lowest_record$state`, the value is `r lowest_record$total_jail_pop`.


## Trend Over Time
```{r echo=F}
plot1
```


## Comparing
```{r echo=F}
plot2
```

## Map
```{r echo=F}
plot3
```

