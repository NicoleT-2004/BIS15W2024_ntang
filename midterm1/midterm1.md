---
title: "Midterm 1 W24"
author: "Ni Tang"
date: "2024-02-06"
output:
  html_document: 
    keep_md: yes
  pdf_document: default
---

## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your code must be organized, clean, and run free from errors. Remember, you must remove the `#` for any included code chunks to run. Be sure to add your name to the author header above. 

Your code must knit in order to be considered. If you are stuck and cannot answer a question, then comment out your code and knit the document. You may use your notes, labs, and homework to help you complete this exam. Do not use any other resources- including AI assistance.  

Don't forget to answer any questions that are asked in the prompt!  

Be sure to push your completed midterm to your repository. This exam is worth 30 points.  

## Background
In the data folder, you will find data related to a study on wolf mortality collected by the National Park Service. You should start by reading the `README_NPSwolfdata.pdf` file. This will provide an abstract of the study and an explanation of variables.  

The data are from: Cassidy, Kira et al. (2022). Gray wolf packs and human-caused wolf mortality. [Dryad](https://doi.org/10.5061/dryad.mkkwh713f). 

## Load the libraries

```r
library("tidyverse")
library("janitor")
```

## Load the wolves data
In these data, the authors used `NULL` to represent missing values. I am correcting this for you below and using `janitor` to clean the column names.

```r
wolves <- read.csv("data/NPS_wolfmortalitydata.csv", na = c("NULL")) %>% clean_names()
```

## Questions
Problem 1. (1 point) Let's start with some data exploration. What are the variable (column) names?  

```r
names(wolves)
```

```
##  [1] "park"         "biolyr"       "pack"         "packcode"     "packsize_aug"
##  [6] "mort_yn"      "mort_all"     "mort_lead"    "mort_nonlead" "reprody1"    
## [11] "persisty1"
```
  The column names are shown above.
  
Problem 2. (1 point) Use the function of your choice to summarize the data and get an idea of its structure.  

```r
summary(wolves)
```

```
##      park               biolyr         pack              packcode     
##  Length:864         Min.   :1986   Length:864         Min.   :  2.00  
##  Class :character   1st Qu.:1999   Class :character   1st Qu.: 48.00  
##  Mode  :character   Median :2006   Mode  :character   Median : 86.50  
##                     Mean   :2005                      Mean   : 91.39  
##                     3rd Qu.:2012                      3rd Qu.:133.00  
##                     Max.   :2021                      Max.   :193.00  
##                                                                       
##   packsize_aug       mort_yn          mort_all         mort_lead      
##  Min.   : 0.000   Min.   :0.0000   Min.   : 0.0000   Min.   :0.00000  
##  1st Qu.: 5.000   1st Qu.:0.0000   1st Qu.: 0.0000   1st Qu.:0.00000  
##  Median : 8.000   Median :0.0000   Median : 0.0000   Median :0.00000  
##  Mean   : 8.789   Mean   :0.1956   Mean   : 0.3715   Mean   :0.09552  
##  3rd Qu.:12.000   3rd Qu.:0.0000   3rd Qu.: 0.0000   3rd Qu.:0.00000  
##  Max.   :37.000   Max.   :1.0000   Max.   :24.0000   Max.   :3.00000  
##  NA's   :55                                          NA's   :16       
##   mort_nonlead        reprody1        persisty1     
##  Min.   : 0.0000   Min.   :0.0000   Min.   :0.0000  
##  1st Qu.: 0.0000   1st Qu.:1.0000   1st Qu.:1.0000  
##  Median : 0.0000   Median :1.0000   Median :1.0000  
##  Mean   : 0.2641   Mean   :0.7629   Mean   :0.8865  
##  3rd Qu.: 0.0000   3rd Qu.:1.0000   3rd Qu.:1.0000  
##  Max.   :22.0000   Max.   :1.0000   Max.   :1.0000  
##  NA's   :12        NA's   :71       NA's   :9
```

```r
str(wolves)
```

```
## 'data.frame':	864 obs. of  11 variables:
##  $ park        : chr  "DENA" "DENA" "DENA" "DENA" ...
##  $ biolyr      : int  1996 1991 2017 1996 1992 1994 2007 2007 1995 2003 ...
##  $ pack        : chr  "McKinley River1" "Birch Creek N" "Eagle Gorge" "East Fork" ...
##  $ packcode    : int  89 58 71 72 74 77 101 108 109 53 ...
##  $ packsize_aug: num  12 5 8 13 7 6 10 NA 9 8 ...
##  $ mort_yn     : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ mort_all    : int  4 2 2 2 2 2 2 2 2 1 ...
##  $ mort_lead   : int  2 2 0 0 0 0 1 2 1 1 ...
##  $ mort_nonlead: int  2 0 2 2 2 2 1 0 1 0 ...
##  $ reprody1    : int  0 0 NA 1 NA 0 0 1 0 1 ...
##  $ persisty1   : int  0 0 1 1 1 1 0 1 0 1 ...
```
  It has 864 observations of 11 variables.
  
Problem 3. (3 points) Which parks/ reserves are represented in the data? Don't just use the abstract, pull this information from the data.  

```r
table(wolves$park)
```

```
## 
## DENA GNTP  VNP  YNP YUCH 
##  340   77   48  248  151
```
  DENA, GNTP, VNP, YNP,YUCH are represented in the data. According to the abstract, their full names are  Denali National Park and Preserve, Grand Teton National Park, Voyageurs National Park, Yellowstone National Park, and Yukon-Charley Rivers National Preserve.  
Problem 4. (4 points) Which park has the largest number of wolf packs?

```r
wolves %>%
  group_by(park) %>%
  summarize(wolf_packs_total = n())
```

```
## # A tibble: 5 × 2
##   park  wolf_packs_total
##   <chr>            <int>
## 1 DENA               340
## 2 GNTP                77
## 3 VNP                 48
## 4 YNP                248
## 5 YUCH               151
```
  DENA(Denali National Park and Preserve) has the largest wolf pack numbers.
  
Problem 5. (4 points) Which park has the highest total number of human-caused mortalities `mort_all`?

```r
wolves %>%
  group_by(park) %>%
  summarize(mort_all_total = sum(mort_all))
```

```
## # A tibble: 5 × 2
##   park  mort_all_total
##   <chr>          <int>
## 1 DENA              64
## 2 GNTP              38
## 3 VNP               11
## 4 YNP               72
## 5 YUCH             136
```
  YUCH(Yukon-Charley Rivers National Preserve) has the highert total number of human-caused moralities.  
  
  
### The wolves in [Yellowstone National Park](https://www.nps.gov/yell/learn/nature/wolf-restoration.htm) are an incredible conservation success story. Let's focus our attention on this park.   


Problem 6. (2 points) Create a new object "ynp" that only includes the data from Yellowstone National Park.  

```r
ynp <- filter(wolves, park == "YNP")
```

Problem 7. (3 points) Among the Yellowstone wolf packs, the [Druid Peak Pack](https://www.pbs.org/wnet/nature/in-the-valley-of-the-wolves-the-druid-wolf-pack-story/209/) is one of most famous. What was the average pack size of this pack for the years represented in the data?

```r
ynp_druid <- filter(ynp, pack == "druid")
mean(ynp_druid$packsize_aug)
```

```
## [1] 13.93333
```
  The average pack size of this pack is 13.93
  
Problem 8. (4 points) Pack dynamics can be hard to predict- even for strong packs like the Druid Peak pack. At which year did the Druid Peak pack have the largest pack size? What do you think happened in 2010?

```r
ynp %>%
  filter(pack == "druid") %>%
  filter(packsize_aug == max(packsize_aug))
```

```
##   park biolyr  pack packcode packsize_aug mort_yn mort_all mort_lead
## 1  YNP   2001 druid       26           37       0        0         0
##   mort_nonlead reprody1 persisty1
## 1            0        1         1
```
  In 2001, the Druid Peak pack have the largest pack size. In 2010, the pack disappeared. There may be infectious disease spreading within the pack which causes the elimination.
   
Problem 9. (5 points) Among the YNP wolf packs, which one has had the highest overall persistence `persisty1` for the years represented in the data? Look this pack up online and tell me what is unique about its behavior- specifically, what prey animals does this pack specialize on?  

```r
ynp %>%
  group_by(pack) %>%
  summarize(overall_persistence = sum(persisty1)) %>%
  arrange(desc(overall_persistence))
```

```
## # A tibble: 46 × 2
##    pack        overall_persistence
##    <chr>                     <int>
##  1 mollies                      26
##  2 cougar                       20
##  3 yelldelta                    18
##  4 leopold                      12
##  5 agate                        10
##  6 8mile                         9
##  7 canyon                        9
##  8 gibbon/mary                   9
##  9 junction                      8
## 10 lamar                         8
## # ℹ 36 more rows
```
  The pack Mollies has the highest overall persistence. [Mollies pack](https://www.yellowstonewolf.org/yellowstones_wolves.php?pack_id=6) specialized on hunting bison. The carcasses they produced provide food for scavengers like grizzly bears. They have regular interaction with bears. The pack locates mainly in Pelican Valley area.
  
Problem 10. (3 points) Perform one analysis or exploration of your choice on the `wolves` data. Your answer needs to include at least two lines of code and not be a summary function.  

```r
ynp %>%
  group_by(biolyr) %>%
  summarize(reproduce_total = sum(reprody1, na.rm = T)) %>%
  arrange(desc(reproduce_total))
```

```
## # A tibble: 27 × 2
##    biolyr reproduce_total
##     <int>           <int>
##  1   2002              12
##  2   2003              11
##  3   2004              11
##  4   2005              11
##  5   2008              11
##  6   2006              10
##  7   2001               9
##  8   2007               9
##  9   2009               9
## 10   2012               9
## # ℹ 17 more rows
```
  Exploration: which year has the most reproduced or localized packs?
  According to the data, biological year 2002 has the largest number of reproduced or localized packs. That may be a result of pleasent climate or abundant food. 
