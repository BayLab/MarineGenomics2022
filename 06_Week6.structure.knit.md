---
title: 
author: 
date: 
output:
  bookdown::html_book:
    toc: yes
    css: toc.css
---



# Population Structure via conStruct

For this week we will be exploring one way to document population genetic structure (An alternate way is PCA) via a "Structure" plot implemented in the R package conStruct.

conStruct itself has a nice series of tutorials with example data that you can find [here](https://cran.r-project.org/web/packages/conStruct/vignettes/format-data.html)

We'll be using data from the [Xuereb et al. paper on P. californicus](https://onlinelibrary.wiley.com/doi/abs/10.1111/mec.14589). This data consists of a vcf file that is in structure format and contains SNP data (3699 SNPs) from 717 individuals (this is the same data we used for our PCA plot in week 9 for pcadapt, and for week 11 for GEA). 


## Download the data

We'll be using data from the [Xuereb et al. paper on P. californicus](https://onlinelibrary.wiley.com/doi/abs/10.1111/mec.14589). This data consists of a vcf file that is in structure format and contains SNP data (3699 SNPs) from 100 individuals (this is the same data we used for our PCA plot in week 9 for pcadapt, and for week 11 for GEA, just with fewer individuals for this week). 

We'll download a metafile as well that has sample coordinates and names

```html

wget https://raw.githubusercontent.com/BayLab/MarineGenomicsData/main/week12_semester.tar.gz

tar -xzvf week12_semester.tar.gz

cd MarineGenomics

mv Week12 Week6-structure
```

## update our compiler in bash/UNIX and install everything for R in the terminal (in bash/UNIX, NOT in Rstudio)

We need to follow this guide [here](https://fahim-sikder.github.io/post/how-to-install-r-ubuntu-20/)

```html
# first run this to get the compilers

sudo apt-get update


sudo apt-get install --fix-missing -y libxml2-dev libcurl4-openssl-dev libssl-dev libv8-dev


#Then install tidyverse into R from the terminal

sudo R
install.packages('tidyverse')

# then exit R with q() and save your workspace image

# now go back into R through the terminal and do the following

sudo R
remove.packages("rstan")
if (file.exists(".RData")) file.remove(".RData")

# now check that we have the compilers we need

pkgbuild::has_build_tools(debug = TRUE)

# if you see a 'TRUE' then you can go on to the next step, installing rstan
### May not say 'TRUE' but we should still be able to proceed ###

install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)
```

## install conStruct in R

Now that we have rstan installed we should be able to go into Rstudio and install conStruct (you could also stay in the terminal and run install.packages ("conStruct") there if you want.)

















