---
title: "dplyr Superhero"
date: "2024-01-30"
output:
  html_document: 
    theme: spacelab
    toc: yes
    toc_float: yes
    keep_md: yes
---

## Learning Goals  
*At the end of this exercise, you will be able to:*    
1. Develop your dplyr superpowers so you can easily and confidently manipulate dataframes.  
2. Learn helpful new functions that are part of the `janitor` package.  

## Instructions
For the second part of lab today, we are going to spend time practicing the dplyr functions we have learned and add a few new ones. This lab doubles as your homework. Please complete the lab and push your final code to GitHub.  

## Load the libraries

```r
library("tidyverse")
```

```
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.4
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.4.4     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

```r
library("janitor")
```

```
## 
## Attaching package: 'janitor'
## 
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

## Load the superhero data
These are data taken from comic books and assembled by fans. The include a good mix of categorical and continuous data.  Data taken from: https://www.kaggle.com/claudiodavi/superhero-set  

Check out the way I am loading these data. If I know there are NAs, I can take care of them at the beginning. But, we should do this very cautiously. At times it is better to keep the original columns and data intact.  

```r
superhero_info <- read_csv("data/heroes_information.csv", na = c("", "-99", "-"))
```

```
## Rows: 734 Columns: 10
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (8): name, Gender, Eye color, Race, Hair color, Publisher, Skin color, A...
## dbl (2): Height, Weight
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
superhero_powers <- read_csv("data/super_hero_powers.csv", na = c("", "-99", "-"))
```

```
## Rows: 667 Columns: 168
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr   (1): hero_names
## lgl (167): Agility, Accelerated Healing, Lantern Power Ring, Dimensional Awa...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Data tidy
1. Some of the names used in the `superhero_info` data are problematic so you should rename them here. Before you do anything, first have a look at the names of the variables. You can use `rename()` or `clean_names()`. 

```r
superhero_info <- clean_names(superhero_info)
names(superhero_info)
```

```
##  [1] "name"       "gender"     "eye_color"  "race"       "hair_color"
##  [6] "height"     "publisher"  "skin_color" "alignment"  "weight"
```


## `tabyl`
The `janitor` package has many awesome functions that we will explore. Here is its version of `table` which not only produces counts but also percentages. Very handy! Let's use it to explore the proportion of good guys and bad guys in the `superhero_info` data.  

```r
tabyl(superhero_info, alignment)
```

```
##  alignment   n     percent valid_percent
##        bad 207 0.282016349    0.28473177
##       good 496 0.675749319    0.68225585
##    neutral  24 0.032697548    0.03301238
##       <NA>   7 0.009536785            NA
```

1. Who are the publishers of the superheros? Show the proportion of superheros from each publisher. Which publisher has the highest number of superheros?  

```r
tabyl(superhero_info, publisher)
```

```
##          publisher   n     percent valid_percent
##        ABC Studios   4 0.005449591   0.005563282
##          DC Comics 215 0.292915531   0.299026426
##  Dark Horse Comics  18 0.024523161   0.025034771
##       George Lucas  14 0.019073569   0.019471488
##      Hanna-Barbera   1 0.001362398   0.001390821
##      HarperCollins   6 0.008174387   0.008344924
##     IDW Publishing   4 0.005449591   0.005563282
##        Icon Comics   4 0.005449591   0.005563282
##       Image Comics  14 0.019073569   0.019471488
##      J. K. Rowling   1 0.001362398   0.001390821
##   J. R. R. Tolkien   1 0.001362398   0.001390821
##      Marvel Comics 388 0.528610354   0.539638387
##          Microsoft   1 0.001362398   0.001390821
##       NBC - Heroes  19 0.025885559   0.026425591
##          Rebellion   1 0.001362398   0.001390821
##           Shueisha   4 0.005449591   0.005563282
##      Sony Pictures   2 0.002724796   0.002781641
##         South Park   1 0.001362398   0.001390821
##          Star Trek   6 0.008174387   0.008344924
##               SyFy   5 0.006811989   0.006954103
##       Team Epic TV   5 0.006811989   0.006954103
##        Titan Books   1 0.001362398   0.001390821
##  Universal Studios   1 0.001362398   0.001390821
##          Wildstorm   3 0.004087193   0.004172462
##               <NA>  15 0.020435967            NA
```

2. Notice that we have some neutral superheros! Who are they? List their names below.  

```r
filter(superhero_info, alignment == "neutral")
```

```
## # A tibble: 24 × 10
##    name  gender eye_color race  hair_color height publisher skin_color alignment
##    <chr> <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>      <chr>    
##  1 Biza… Male   black     Biza… Black         191 DC Comics white      neutral  
##  2 Blac… Male   <NA>      God … <NA>           NA DC Comics <NA>       neutral  
##  3 Capt… Male   brown     Human Brown          NA DC Comics <NA>       neutral  
##  4 Copy… Female red       Muta… White         183 Marvel C… blue       neutral  
##  5 Dead… Male   brown     Muta… No Hair       188 Marvel C… <NA>       neutral  
##  6 Deat… Male   blue      Human White         193 DC Comics <NA>       neutral  
##  7 Etri… Male   red       Demon No Hair       193 DC Comics yellow     neutral  
##  8 Gala… Male   black     Cosm… Black         876 Marvel C… <NA>       neutral  
##  9 Glad… Male   blue      Stro… Blue          198 Marvel C… purple     neutral  
## 10 Indi… Female <NA>      Alien Purple         NA DC Comics <NA>       neutral  
## # ℹ 14 more rows
## # ℹ 1 more variable: weight <dbl>
```

## `superhero_info`
3. Let's say we are only interested in the variables name, alignment, and "race". How would you isolate these variables from `superhero_info`?

```r
select(superhero_info, "name", "alignment", "race")
```

```
## # A tibble: 734 × 3
##    name          alignment race             
##    <chr>         <chr>     <chr>            
##  1 A-Bomb        good      Human            
##  2 Abe Sapien    good      Icthyo Sapien    
##  3 Abin Sur      good      Ungaran          
##  4 Abomination   bad       Human / Radiation
##  5 Abraxas       bad       Cosmic Entity    
##  6 Absorbing Man bad       Human            
##  7 Adam Monroe   good      <NA>             
##  8 Adam Strange  good      Human            
##  9 Agent 13      good      <NA>             
## 10 Agent Bob     good      Human            
## # ℹ 724 more rows
```


## Not Human
4. List all of the superheros that are not human.

```r
filter(superhero_info, race != "Human")
```

```
## # A tibble: 222 × 10
##    name  gender eye_color race  hair_color height publisher skin_color alignment
##    <chr> <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>      <chr>    
##  1 Abe … Male   blue      Icth… No Hair       191 Dark Hor… blue       good     
##  2 Abin… Male   blue      Unga… No Hair       185 DC Comics red        good     
##  3 Abom… Male   green     Huma… No Hair       203 Marvel C… <NA>       bad      
##  4 Abra… Male   blue      Cosm… Black          NA Marvel C… <NA>       bad      
##  5 Ajax  Male   brown     Cybo… Black         193 Marvel C… <NA>       bad      
##  6 Alien Male   <NA>      Xeno… No Hair       244 Dark Hor… black      bad      
##  7 Amazo Male   red       Andr… <NA>          257 DC Comics <NA>       bad      
##  8 Angel Male   <NA>      Vamp… <NA>           NA Dark Hor… <NA>       good     
##  9 Ange… Female yellow    Muta… Black         165 Marvel C… <NA>       good     
## 10 Anti… Male   yellow    God … No Hair        61 DC Comics <NA>       bad      
## # ℹ 212 more rows
## # ℹ 1 more variable: weight <dbl>
```

## Good and Evil
5. Let's make two different data frames, one focused on the "good guys" and another focused on the "bad guys".

```r
good_guys <- filter(superhero_info, alignment == "good")
bad_guys <- filter(superhero_info, alignment == "bad")
```

6. For the good guys, use the `tabyl` function to summarize their "race".

```r
tabyl(good_guys, race)
```

```
##               race   n     percent valid_percent
##              Alien   3 0.006048387   0.010752688
##              Alpha   5 0.010080645   0.017921147
##             Amazon   2 0.004032258   0.007168459
##            Android   4 0.008064516   0.014336918
##             Animal   2 0.004032258   0.007168459
##          Asgardian   3 0.006048387   0.010752688
##          Atlantean   4 0.008064516   0.014336918
##         Bolovaxian   1 0.002016129   0.003584229
##              Clone   1 0.002016129   0.003584229
##             Cyborg   3 0.006048387   0.010752688
##           Demi-God   2 0.004032258   0.007168459
##              Demon   3 0.006048387   0.010752688
##            Eternal   1 0.002016129   0.003584229
##     Flora Colossus   1 0.002016129   0.003584229
##        Frost Giant   1 0.002016129   0.003584229
##      God / Eternal   6 0.012096774   0.021505376
##             Gungan   1 0.002016129   0.003584229
##              Human 148 0.298387097   0.530465950
##    Human / Altered   2 0.004032258   0.007168459
##     Human / Cosmic   2 0.004032258   0.007168459
##  Human / Radiation   8 0.016129032   0.028673835
##         Human-Kree   2 0.004032258   0.007168459
##      Human-Spartoi   1 0.002016129   0.003584229
##       Human-Vulcan   1 0.002016129   0.003584229
##    Human-Vuldarian   1 0.002016129   0.003584229
##      Icthyo Sapien   1 0.002016129   0.003584229
##            Inhuman   4 0.008064516   0.014336918
##    Kakarantharaian   1 0.002016129   0.003584229
##         Kryptonian   4 0.008064516   0.014336918
##            Martian   1 0.002016129   0.003584229
##          Metahuman   1 0.002016129   0.003584229
##             Mutant  46 0.092741935   0.164874552
##     Mutant / Clone   1 0.002016129   0.003584229
##             Planet   1 0.002016129   0.003584229
##             Saiyan   1 0.002016129   0.003584229
##           Symbiote   3 0.006048387   0.010752688
##           Talokite   1 0.002016129   0.003584229
##         Tamaranean   1 0.002016129   0.003584229
##            Ungaran   1 0.002016129   0.003584229
##            Vampire   2 0.004032258   0.007168459
##     Yoda's species   1 0.002016129   0.003584229
##      Zen-Whoberian   1 0.002016129   0.003584229
##               <NA> 217 0.437500000            NA
```

7. Among the good guys, Who are the Vampires?

```r
filter(good_guys, race == "Vampire")
```

```
## # A tibble: 2 × 10
##   name  gender eye_color race   hair_color height publisher skin_color alignment
##   <chr> <chr>  <chr>     <chr>  <chr>       <dbl> <chr>     <chr>      <chr>    
## 1 Angel Male   <NA>      Vampi… <NA>           NA Dark Hor… <NA>       good     
## 2 Blade Male   brown     Vampi… Black         188 Marvel C… <NA>       good     
## # ℹ 1 more variable: weight <dbl>
```

8. Among the bad guys, who are the male humans over 200 inches in height?

```r
bad_guys %>%
  filter(gender == "Male") %>%
  filter(race == "Human") %>%
  filter(height > 200)
```

```
## # A tibble: 5 × 10
##   name   gender eye_color race  hair_color height publisher skin_color alignment
##   <chr>  <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>      <chr>    
## 1 Bane   Male   <NA>      Human <NA>          203 DC Comics <NA>       bad      
## 2 Docto… Male   brown     Human Brown         201 Marvel C… <NA>       bad      
## 3 Kingp… Male   blue      Human No Hair       201 Marvel C… <NA>       bad      
## 4 Lizard Male   red       Human No Hair       203 Marvel C… <NA>       bad      
## 5 Scorp… Male   brown     Human Brown         211 Marvel C… <NA>       bad      
## # ℹ 1 more variable: weight <dbl>
```

9. Are there more good guys or bad guys with green hair?  

```r
good_guys %>%
  filter(hair_color == "Green") %>%
  summary(good_guys)
```

```
##      name              gender           eye_color             race          
##  Length:7           Length:7           Length:7           Length:7          
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##                                                                             
##   hair_color            height       publisher          skin_color       
##  Length:7           Min.   :170.0   Length:7           Length:7          
##  Class :character   1st Qu.:173.0   Class :character   Class :character  
##  Mode  :character   Median :198.0   Mode  :character   Mode  :character  
##                     Mean   :197.2                                        
##                     3rd Qu.:201.0                                        
##                     Max.   :244.0                                        
##                     NA's   :2                                            
##   alignment             weight     
##  Length:7           Min.   : 52.0  
##  Class :character   1st Qu.: 68.0  
##  Mode  :character   Median :171.0  
##                     Mean   :247.2  
##                     3rd Qu.:315.0  
##                     Max.   :630.0  
##                     NA's   :2
```

```r
bad_guys %>%
  filter(hair_color == "Green") %>%
  summary(bad_guys)
```

```
##      name              gender           eye_color             race          
##  Length:1           Length:1           Length:1           Length:1          
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##   hair_color            height     publisher          skin_color       
##  Length:1           Min.   :196   Length:1           Length:1          
##  Class :character   1st Qu.:196   Class :character   Class :character  
##  Mode  :character   Median :196   Mode  :character   Mode  :character  
##                     Mean   :196                                        
##                     3rd Qu.:196                                        
##                     Max.   :196                                        
##   alignment             weight  
##  Length:1           Min.   :86  
##  Class :character   1st Qu.:86  
##  Mode  :character   Median :86  
##                     Mean   :86  
##                     3rd Qu.:86  
##                     Max.   :86
```
There is more green hair superheros in good guys.

10. Let's explore who the really small superheros are. In the `superhero_info` data, which have a weight less than 50? Be sure to sort your results by weight lowest to highest.  

```r
superhero_info %>%
  filter(weight < 50) %>%
  arrange(weight)
```

```
## # A tibble: 19 × 10
##    name  gender eye_color race  hair_color height publisher skin_color alignment
##    <chr> <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>      <chr>    
##  1 Iron… Male   blue      <NA>  No Hair        NA Marvel C… <NA>       bad      
##  2 Groot Male   yellow    Flor… <NA>          701 Marvel C… <NA>       good     
##  3 Jack… Male   blue      Human Brown          71 Dark Hor… <NA>       good     
##  4 Gala… Male   black     Cosm… Black         876 Marvel C… <NA>       neutral  
##  5 Yoda  Male   brown     Yoda… White          66 George L… green      good     
##  6 Fin … Male   red       Kaka… No Hair       975 Marvel C… green      good     
##  7 Howa… Male   brown     <NA>  Yellow         79 Marvel C… <NA>       good     
##  8 Kryp… Male   blue      Kryp… White          64 DC Comics <NA>       good     
##  9 Rock… Male   brown     Anim… Brown         122 Marvel C… <NA>       good     
## 10 Dash  Male   blue      Human Blond         122 Dark Hor… <NA>       good     
## 11 Long… Male   blue      Human Blond         188 Marvel C… <NA>       good     
## 12 Robi… Male   blue      Human Black         137 DC Comics <NA>       good     
## 13 Wiz … <NA>   brown     <NA>  Black         140 Marvel C… <NA>       good     
## 14 Viol… Female violet    Human Black         137 Dark Hor… <NA>       good     
## 15 Fran… Male   blue      Muta… Blond         142 Marvel C… <NA>       good     
## 16 Swarm Male   yellow    Muta… No Hair       196 Marvel C… yellow     bad      
## 17 Hope… Female green     <NA>  Red           168 Marvel C… <NA>       good     
## 18 Jolt  Female blue      <NA>  Black         165 Marvel C… <NA>       good     
## 19 Snow… Female white     <NA>  Blond         178 Marvel C… <NA>       good     
## # ℹ 1 more variable: weight <dbl>
```

11. Let's make a new variable that is the ratio of height to weight. Call this variable `height_weight_ratio`.    

```r
superhero_info %>%
  mutate(height_weight_ratio = height/weight)
```

```
## # A tibble: 734 × 11
##    name  gender eye_color race  hair_color height publisher skin_color alignment
##    <chr> <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>      <chr>    
##  1 A-Bo… Male   yellow    Human No Hair       203 Marvel C… <NA>       good     
##  2 Abe … Male   blue      Icth… No Hair       191 Dark Hor… blue       good     
##  3 Abin… Male   blue      Unga… No Hair       185 DC Comics red        good     
##  4 Abom… Male   green     Huma… No Hair       203 Marvel C… <NA>       bad      
##  5 Abra… Male   blue      Cosm… Black          NA Marvel C… <NA>       bad      
##  6 Abso… Male   blue      Human No Hair       193 Marvel C… <NA>       bad      
##  7 Adam… Male   blue      <NA>  Blond          NA NBC - He… <NA>       good     
##  8 Adam… Male   blue      Human Blond         185 DC Comics <NA>       good     
##  9 Agen… Female blue      <NA>  Blond         173 Marvel C… <NA>       good     
## 10 Agen… Male   brown     Human Brown         178 Marvel C… <NA>       good     
## # ℹ 724 more rows
## # ℹ 2 more variables: weight <dbl>, height_weight_ratio <dbl>
```



12. Who has the highest height to weight ratio?  

```r
superhero_info %>%
  mutate(height_weight_ratio = height/weight) %>%
  arrange(height_weight_ratio)
```

```
## # A tibble: 734 × 11
##    name  gender eye_color race  hair_color height publisher skin_color alignment
##    <chr> <chr>  <chr>     <chr> <chr>       <dbl> <chr>     <chr>      <chr>    
##  1 Giga… Female green     <NA>  Red          62.5 DC Comics <NA>       bad      
##  2 Utga… Male   blue      Fros… White        15.2 Marvel C… <NA>       bad      
##  3 Dark… Male   red       New … No Hair     267   DC Comics grey       bad      
##  4 Jugg… Male   blue      Human Red         287   Marvel C… <NA>       neutral  
##  5 Red … Male   yellow    Huma… Black       213   Marvel C… red        neutral  
##  6 Sasq… Male   red       <NA>  Orange      305   Marvel C… <NA>       good     
##  7 Hulk  Male   green     Huma… Green       244   Marvel C… green      good     
##  8 Bloo… Female blue      Human Brown       218   Marvel C… <NA>       bad      
##  9 Than… Male   red       Eter… No Hair     201   Marvel C… purple     bad      
## 10 A-Bo… Male   yellow    Human No Hair     203   Marvel C… <NA>       good     
## # ℹ 724 more rows
## # ℹ 2 more variables: weight <dbl>, height_weight_ratio <dbl>
```


Groot has the largest height weight ratio.
## `superhero_powers`
Have a quick look at the `superhero_powers` data frame.  

```r
glimpse(superhero_powers)
```

```
## Rows: 667
## Columns: 168
## $ hero_names                     <chr> "3-D Man", "A-Bomb", "Abe Sapien", "Abi…
## $ Agility                        <lgl> TRUE, FALSE, TRUE, FALSE, FALSE, FALSE,…
## $ `Accelerated Healing`          <lgl> FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, …
## $ `Lantern Power Ring`           <lgl> FALSE, FALSE, FALSE, TRUE, FALSE, FALSE…
## $ `Dimensional Awareness`        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Cold Resistance`              <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ Durability                     <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE,…
## $ Stealth                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Energy Absorption`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Flight                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Danger Sense`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Underwater breathing`         <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ Marksmanship                   <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ `Weapons Master`               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ `Power Augmentation`           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Animal Attributes`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Longevity                      <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE,…
## $ Intelligence                   <lgl> FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, …
## $ `Super Strength`               <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TR…
## $ Cryokinesis                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Telepathy                      <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ `Energy Armor`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Energy Blasts`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Duplication                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Size Changing`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Density Control`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Stamina                        <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, F…
## $ `Astral Travel`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Audio Control`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Dexterity                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Omnitrix                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Super Speed`                  <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, …
## $ Possession                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Animal Oriented Powers`       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Weapon-based Powers`          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Electrokinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Darkforce Manipulation`       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Death Touch`                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Teleportation                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Enhanced Senses`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Telekinesis                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Energy Beams`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Magic                          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ Hyperkinesis                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Jump                           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Clairvoyance                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Dimensional Travel`           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Power Sense`                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Shapeshifting                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Peak Human Condition`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Immortality                    <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, TRUE,…
## $ Camouflage                     <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE…
## $ `Element Control`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Phasing                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Astral Projection`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Electrical Transport`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Fire Control`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Projection                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Summoning                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Enhanced Memory`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Reflexes                       <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ Invulnerability                <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,…
## $ `Energy Constructs`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Force Fields`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Self-Sustenance`              <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE…
## $ `Anti-Gravity`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Empathy                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Power Nullifier`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Radiation Control`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Psionic Powers`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Elasticity                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Substance Secretion`          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Elemental Transmogrification` <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Technopath/Cyberpath`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Photographic Reflexes`        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Seismic Power`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Animation                      <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE…
## $ Precognition                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Mind Control`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Fire Resistance`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Power Absorption`             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Enhanced Hearing`             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Nova Force`                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Insanity                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Hypnokinesis                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Animal Control`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Natural Armor`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Intangibility                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Enhanced Sight`               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ `Molecular Manipulation`       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Heat Generation`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Adaptation                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Gliding                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Power Suit`                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Mind Blast`                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Probability Manipulation`     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Gravity Control`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Regeneration                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Light Control`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Echolocation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Levitation                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Toxin and Disease Control`    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Banish                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Energy Manipulation`          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ `Heat Resistance`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Natural Weapons`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Time Travel`                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Enhanced Smell`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Illusions                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Thirstokinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Hair Manipulation`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Illumination                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Omnipotent                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Cloaking                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Changing Armor`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Power Cosmic`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE…
## $ Biokinesis                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Water Control`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Radiation Immunity`           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Telescopic`          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Toxin and Disease Resistance` <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Spatial Awareness`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Energy Resistance`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Telepathy Resistance`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Molecular Combustion`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Omnilingualism                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Portal Creation`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Magnetism                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Mind Control Resistance`      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Plant Control`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Sonar                          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Sonic Scream`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Time Manipulation`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Enhanced Touch`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Magic Resistance`             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Invisibility                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Sub-Mariner`                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE…
## $ `Radiation Absorption`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Intuitive aptitude`           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Microscopic`         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Melting                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Wind Control`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Super Breath`                 <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE…
## $ Wallcrawling                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Night`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Infrared`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Grim Reaping`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Matter Absorption`            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `The Force`                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Resurrection                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Terrakinesis                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Heat`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Vitakinesis                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Radar Sense`                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Qwardian Power Ring`          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Weather Control`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - X-Ray`               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Thermal`             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Web Creation`                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Reality Warping`              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Odin Force`                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Symbiote Costume`             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Speed Force`                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Phoenix Force`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Molecular Dissipation`        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ `Vision - Cryo`                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Omnipresent                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
## $ Omniscient                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
```

```r
names(superhero_powers)
```

```
##   [1] "hero_names"                   "Agility"                     
##   [3] "Accelerated Healing"          "Lantern Power Ring"          
##   [5] "Dimensional Awareness"        "Cold Resistance"             
##   [7] "Durability"                   "Stealth"                     
##   [9] "Energy Absorption"            "Flight"                      
##  [11] "Danger Sense"                 "Underwater breathing"        
##  [13] "Marksmanship"                 "Weapons Master"              
##  [15] "Power Augmentation"           "Animal Attributes"           
##  [17] "Longevity"                    "Intelligence"                
##  [19] "Super Strength"               "Cryokinesis"                 
##  [21] "Telepathy"                    "Energy Armor"                
##  [23] "Energy Blasts"                "Duplication"                 
##  [25] "Size Changing"                "Density Control"             
##  [27] "Stamina"                      "Astral Travel"               
##  [29] "Audio Control"                "Dexterity"                   
##  [31] "Omnitrix"                     "Super Speed"                 
##  [33] "Possession"                   "Animal Oriented Powers"      
##  [35] "Weapon-based Powers"          "Electrokinesis"              
##  [37] "Darkforce Manipulation"       "Death Touch"                 
##  [39] "Teleportation"                "Enhanced Senses"             
##  [41] "Telekinesis"                  "Energy Beams"                
##  [43] "Magic"                        "Hyperkinesis"                
##  [45] "Jump"                         "Clairvoyance"                
##  [47] "Dimensional Travel"           "Power Sense"                 
##  [49] "Shapeshifting"                "Peak Human Condition"        
##  [51] "Immortality"                  "Camouflage"                  
##  [53] "Element Control"              "Phasing"                     
##  [55] "Astral Projection"            "Electrical Transport"        
##  [57] "Fire Control"                 "Projection"                  
##  [59] "Summoning"                    "Enhanced Memory"             
##  [61] "Reflexes"                     "Invulnerability"             
##  [63] "Energy Constructs"            "Force Fields"                
##  [65] "Self-Sustenance"              "Anti-Gravity"                
##  [67] "Empathy"                      "Power Nullifier"             
##  [69] "Radiation Control"            "Psionic Powers"              
##  [71] "Elasticity"                   "Substance Secretion"         
##  [73] "Elemental Transmogrification" "Technopath/Cyberpath"        
##  [75] "Photographic Reflexes"        "Seismic Power"               
##  [77] "Animation"                    "Precognition"                
##  [79] "Mind Control"                 "Fire Resistance"             
##  [81] "Power Absorption"             "Enhanced Hearing"            
##  [83] "Nova Force"                   "Insanity"                    
##  [85] "Hypnokinesis"                 "Animal Control"              
##  [87] "Natural Armor"                "Intangibility"               
##  [89] "Enhanced Sight"               "Molecular Manipulation"      
##  [91] "Heat Generation"              "Adaptation"                  
##  [93] "Gliding"                      "Power Suit"                  
##  [95] "Mind Blast"                   "Probability Manipulation"    
##  [97] "Gravity Control"              "Regeneration"                
##  [99] "Light Control"                "Echolocation"                
## [101] "Levitation"                   "Toxin and Disease Control"   
## [103] "Banish"                       "Energy Manipulation"         
## [105] "Heat Resistance"              "Natural Weapons"             
## [107] "Time Travel"                  "Enhanced Smell"              
## [109] "Illusions"                    "Thirstokinesis"              
## [111] "Hair Manipulation"            "Illumination"                
## [113] "Omnipotent"                   "Cloaking"                    
## [115] "Changing Armor"               "Power Cosmic"                
## [117] "Biokinesis"                   "Water Control"               
## [119] "Radiation Immunity"           "Vision - Telescopic"         
## [121] "Toxin and Disease Resistance" "Spatial Awareness"           
## [123] "Energy Resistance"            "Telepathy Resistance"        
## [125] "Molecular Combustion"         "Omnilingualism"              
## [127] "Portal Creation"              "Magnetism"                   
## [129] "Mind Control Resistance"      "Plant Control"               
## [131] "Sonar"                        "Sonic Scream"                
## [133] "Time Manipulation"            "Enhanced Touch"              
## [135] "Magic Resistance"             "Invisibility"                
## [137] "Sub-Mariner"                  "Radiation Absorption"        
## [139] "Intuitive aptitude"           "Vision - Microscopic"        
## [141] "Melting"                      "Wind Control"                
## [143] "Super Breath"                 "Wallcrawling"                
## [145] "Vision - Night"               "Vision - Infrared"           
## [147] "Grim Reaping"                 "Matter Absorption"           
## [149] "The Force"                    "Resurrection"                
## [151] "Terrakinesis"                 "Vision - Heat"               
## [153] "Vitakinesis"                  "Radar Sense"                 
## [155] "Qwardian Power Ring"          "Weather Control"             
## [157] "Vision - X-Ray"               "Vision - Thermal"            
## [159] "Web Creation"                 "Reality Warping"             
## [161] "Odin Force"                   "Symbiote Costume"            
## [163] "Speed Force"                  "Phoenix Force"               
## [165] "Molecular Dissipation"        "Vision - Cryo"               
## [167] "Omnipresent"                  "Omniscient"
```

13. How many superheros have a combination of agility, stealth, super_strength, stamina?

```r
superhero_powers %>%
  filter(Agility & Stealth & `Super Strength` & Stamina) %>%
  summary(superhero_powers)
```

```
##   hero_names        Agility        Accelerated Healing Lantern Power Ring
##  Length:40          Mode:logical   Mode :logical       Mode :logical     
##  Class :character   TRUE:40        FALSE:12            FALSE:40          
##  Mode  :character                  TRUE :28                              
##  Dimensional Awareness Cold Resistance Durability      Stealth       
##  Mode :logical         Mode :logical   Mode :logical   Mode:logical  
##  FALSE:38              FALSE:34        FALSE:12        TRUE:40       
##  TRUE :2               TRUE :6         TRUE :28                      
##  Energy Absorption   Flight        Danger Sense    Underwater breathing
##  Mode :logical     Mode :logical   Mode :logical   Mode :logical       
##  FALSE:36          FALSE:28        FALSE:29        FALSE:37            
##  TRUE :4           TRUE :12        TRUE :11        TRUE :3             
##  Marksmanship    Weapons Master  Power Augmentation Animal Attributes
##  Mode :logical   Mode :logical   Mode :logical      Mode :logical    
##  FALSE:19        FALSE:25        FALSE:40           FALSE:35         
##  TRUE :21        TRUE :15                           TRUE :5          
##  Longevity       Intelligence    Super Strength Cryokinesis     Telepathy      
##  Mode :logical   Mode :logical   Mode:logical   Mode :logical   Mode :logical  
##  FALSE:25        FALSE:23        TRUE:40        FALSE:39        FALSE:31       
##  TRUE :15        TRUE :17                       TRUE :1         TRUE :9        
##  Energy Armor    Energy Blasts   Duplication     Size Changing  
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:39        FALSE:32        FALSE:37        FALSE:34       
##  TRUE :1         TRUE :8         TRUE :3         TRUE :6        
##  Density Control Stamina        Astral Travel   Audio Control   Dexterity      
##  Mode :logical   Mode:logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:39        TRUE:40        FALSE:40        FALSE:40        FALSE:38       
##  TRUE :1                                                        TRUE :2        
##   Omnitrix       Super Speed     Possession      Animal Oriented Powers
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical         
##  FALSE:40        FALSE:8         FALSE:39        FALSE:31              
##                  TRUE :32        TRUE :1         TRUE :9               
##  Weapon-based Powers Electrokinesis  Darkforce Manipulation Death Touch    
##  Mode :logical       Mode :logical   Mode :logical          Mode :logical  
##  FALSE:37            FALSE:38        FALSE:38               FALSE:38       
##  TRUE :3             TRUE :2         TRUE :2                TRUE :2        
##  Teleportation   Enhanced Senses Telekinesis     Energy Beams   
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:33        FALSE:25        FALSE:35        FALSE:38       
##  TRUE :7         TRUE :15        TRUE :5         TRUE :2        
##    Magic         Hyperkinesis       Jump         Clairvoyance   
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:34        FALSE:40        FALSE:27        FALSE:40       
##  TRUE :6                         TRUE :13                       
##  Dimensional Travel Power Sense     Shapeshifting   Peak Human Condition
##  Mode :logical      Mode :logical   Mode :logical   Mode :logical       
##  FALSE:39           FALSE:40        FALSE:27        FALSE:37            
##  TRUE :1                            TRUE :13        TRUE :3             
##  Immortality     Camouflage      Element Control  Phasing       
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:31        FALSE:34        FALSE:40        FALSE:38       
##  TRUE :9         TRUE :6                         TRUE :2        
##  Astral Projection Electrical Transport Fire Control    Projection     
##  Mode :logical     Mode :logical        Mode :logical   Mode :logical  
##  FALSE:36          FALSE:40             FALSE:37        FALSE:40       
##  TRUE :4                                TRUE :3                        
##  Summoning       Enhanced Memory  Reflexes       Invulnerability
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:40        FALSE:35        FALSE:16        FALSE:31       
##                  TRUE :5         TRUE :24        TRUE :9        
##  Energy Constructs Force Fields    Self-Sustenance Anti-Gravity   
##  Mode :logical     Mode :logical   Mode :logical   Mode :logical  
##  FALSE:38          FALSE:33        FALSE:39        FALSE:40       
##  TRUE :2           TRUE :7         TRUE :1                        
##   Empathy        Power Nullifier Radiation Control Psionic Powers 
##  Mode :logical   Mode :logical   Mode :logical     Mode :logical  
##  FALSE:37        FALSE:39        FALSE:39          FALSE:35       
##  TRUE :3         TRUE :1         TRUE :1           TRUE :5        
##  Elasticity      Substance Secretion Elemental Transmogrification
##  Mode :logical   Mode :logical       Mode :logical               
##  FALSE:38        FALSE:34            FALSE:40                    
##  TRUE :2         TRUE :6                                         
##  Technopath/Cyberpath Photographic Reflexes Seismic Power   Animation      
##  Mode :logical        Mode :logical         Mode :logical   Mode :logical  
##  FALSE:35             FALSE:40              FALSE:40        FALSE:39       
##  TRUE :5                                                    TRUE :1        
##  Precognition    Mind Control    Fire Resistance Power Absorption
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical   
##  FALSE:37        FALSE:37        FALSE:38        FALSE:39        
##  TRUE :3         TRUE :3         TRUE :2         TRUE :1         
##  Enhanced Hearing Nova Force       Insanity       Hypnokinesis   
##  Mode :logical    Mode :logical   Mode :logical   Mode :logical  
##  FALSE:25         FALSE:40        FALSE:40        FALSE:39       
##  TRUE :15                                         TRUE :1        
##  Animal Control  Natural Armor   Intangibility   Enhanced Sight 
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:36        FALSE:36        FALSE:38        FALSE:34       
##  TRUE :4         TRUE :4         TRUE :2         TRUE :6        
##  Molecular Manipulation Heat Generation Adaptation       Gliding       
##  Mode :logical          Mode :logical   Mode :logical   Mode :logical  
##  FALSE:37               FALSE:38        FALSE:38        FALSE:36       
##  TRUE :3                TRUE :2         TRUE :2         TRUE :4        
##  Power Suit      Mind Blast      Probability Manipulation Gravity Control
##  Mode :logical   Mode :logical   Mode :logical            Mode :logical  
##  FALSE:37        FALSE:38        FALSE:40                 FALSE:38       
##  TRUE :3         TRUE :2                                  TRUE :2        
##  Regeneration    Light Control   Echolocation    Levitation     
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:35        FALSE:39        FALSE:40        FALSE:38       
##  TRUE :5         TRUE :1                         TRUE :2        
##  Toxin and Disease Control   Banish        Energy Manipulation Heat Resistance
##  Mode :logical             Mode :logical   Mode :logical       Mode :logical  
##  FALSE:39                  FALSE:40        FALSE:37            FALSE:37       
##  TRUE :1                                   TRUE :3             TRUE :3        
##  Natural Weapons Time Travel     Enhanced Smell  Illusions      
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:24        FALSE:36        FALSE:29        FALSE:35       
##  TRUE :16        TRUE :4         TRUE :11        TRUE :5        
##  Thirstokinesis  Hair Manipulation Illumination    Omnipotent     
##  Mode :logical   Mode :logical     Mode :logical   Mode :logical  
##  FALSE:40        FALSE:40          FALSE:40        FALSE:40       
##                                                                   
##   Cloaking       Changing Armor  Power Cosmic    Biokinesis     
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:39        FALSE:40        FALSE:40        FALSE:40       
##  TRUE :1                                                        
##  Water Control   Radiation Immunity Vision - Telescopic
##  Mode :logical   Mode :logical      Mode :logical      
##  FALSE:38        FALSE:40           FALSE:31           
##  TRUE :2                            TRUE :9            
##  Toxin and Disease Resistance Spatial Awareness Energy Resistance
##  Mode :logical                Mode :logical     Mode :logical    
##  FALSE:30                     FALSE:40          FALSE:40         
##  TRUE :10                                                        
##  Telepathy Resistance Molecular Combustion Omnilingualism  Portal Creation
##  Mode :logical        Mode :logical        Mode :logical   Mode :logical  
##  FALSE:35             FALSE:40             FALSE:38        FALSE:40       
##  TRUE :5                                   TRUE :2                        
##  Magnetism       Mind Control Resistance Plant Control     Sonar        
##  Mode :logical   Mode :logical           Mode :logical   Mode :logical  
##  FALSE:40        FALSE:38                FALSE:40        FALSE:39       
##                  TRUE :2                                 TRUE :1        
##  Sonic Scream    Time Manipulation Enhanced Touch  Magic Resistance
##  Mode :logical   Mode :logical     Mode :logical   Mode :logical   
##  FALSE:40        FALSE:36          FALSE:38        FALSE:40        
##                  TRUE :4           TRUE :2                         
##  Invisibility    Sub-Mariner     Radiation Absorption Intuitive aptitude
##  Mode :logical   Mode :logical   Mode :logical        Mode :logical     
##  FALSE:37        FALSE:37        FALSE:39             FALSE:40          
##  TRUE :3         TRUE :3         TRUE :1                                
##  Vision - Microscopic  Melting        Wind Control    Super Breath   
##  Mode :logical        Mode :logical   Mode :logical   Mode :logical  
##  FALSE:38             FALSE:39        FALSE:40        FALSE:39       
##  TRUE :2              TRUE :1                         TRUE :1        
##  Wallcrawling    Vision - Night  Vision - Infrared Grim Reaping   
##  Mode :logical   Mode :logical   Mode :logical     Mode :logical  
##  FALSE:29        FALSE:30        FALSE:35          FALSE:40       
##  TRUE :11        TRUE :10        TRUE :5                          
##  Matter Absorption The Force       Resurrection    Terrakinesis   
##  Mode :logical     Mode :logical   Mode :logical   Mode :logical  
##  FALSE:37          FALSE:39        FALSE:39        FALSE:40       
##  TRUE :3           TRUE :1         TRUE :1                        
##  Vision - Heat   Vitakinesis     Radar Sense     Qwardian Power Ring
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical      
##  FALSE:38        FALSE:40        FALSE:40        FALSE:40           
##  TRUE :2                                                            
##  Weather Control Vision - X-Ray  Vision - Thermal Web Creation   
##  Mode :logical   Mode :logical   Mode :logical    Mode :logical  
##  FALSE:38        FALSE:38        FALSE:34         FALSE:33       
##  TRUE :2         TRUE :2         TRUE :6          TRUE :7        
##  Reality Warping Odin Force      Symbiote Costume Speed Force    
##  Mode :logical   Mode :logical   Mode :logical    Mode :logical  
##  FALSE:38        FALSE:39        FALSE:36         FALSE:40       
##  TRUE :2         TRUE :1         TRUE :4                         
##  Phoenix Force   Molecular Dissipation Vision - Cryo   Omnipresent    
##  Mode :logical   Mode :logical         Mode :logical   Mode :logical  
##  FALSE:40        FALSE:40              FALSE:40        FALSE:40       
##                                                                       
##  Omniscient     
##  Mode :logical  
##  FALSE:40       
## 
```

40 superheros have those powers.
## Your Favorite
14. Pick your favorite superhero and let's see their powers!  

```r
filter(superhero_powers, hero_names == "Groot")
```

```
## # A tibble: 1 × 168
##   hero_names Agility `Accelerated Healing` `Lantern Power Ring`
##   <chr>      <lgl>   <lgl>                 <lgl>               
## 1 Groot      FALSE   FALSE                 FALSE               
## # ℹ 164 more variables: `Dimensional Awareness` <lgl>, `Cold Resistance` <lgl>,
## #   Durability <lgl>, Stealth <lgl>, `Energy Absorption` <lgl>, Flight <lgl>,
## #   `Danger Sense` <lgl>, `Underwater breathing` <lgl>, Marksmanship <lgl>,
## #   `Weapons Master` <lgl>, `Power Augmentation` <lgl>,
## #   `Animal Attributes` <lgl>, Longevity <lgl>, Intelligence <lgl>,
## #   `Super Strength` <lgl>, Cryokinesis <lgl>, Telepathy <lgl>,
## #   `Energy Armor` <lgl>, `Energy Blasts` <lgl>, Duplication <lgl>, …
```

15. Can you find your hero in the superhero_info data? Show their info!  

```r
filter(superhero_info, name == "Groot")
```

```
## # A tibble: 1 × 10
##   name  gender eye_color race   hair_color height publisher skin_color alignment
##   <chr> <chr>  <chr>     <chr>  <chr>       <dbl> <chr>     <chr>      <chr>    
## 1 Groot Male   yellow    Flora… <NA>          701 Marvel C… <NA>       good     
## # ℹ 1 more variable: weight <dbl>
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.  
