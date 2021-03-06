---
title: 
author: 
date: 
output:
  bookdown::html_book:
    toc: yes
    css: toc.css
---


# Week 3- What is a Genetic Variant?

You'll find the lecture discussing the definition and identification of genetic variation [here](https://github.com/BayLab/MarineGenomics/blob/0e7ead526047e02518c33d01e3a6c88d6a3068a3/ppt/MarineGenomics_Lecture3.pdf)


## To get started lets dowload the data and install a few programs

Download the data from the MarineGenomicsData repository on git hub. We'll be working in the Week_3 folder

```html
cd
pwd
wget https://raw.githubusercontent.com/BayLab/MarineGenomicsData/main/week3_quarter.tar.gz


# uncompress the file

tar -xvzf week3_quarter.tar.gz
```

Next we need to install a few programs that will allow us to do what we need to do. This will all take a few minutes!

*The programs that we are installing
  + samtools: allows us to filter and view our mapped data
  + bowtie2: to map our reads to the reference genome
  + cutadapt: will trim adaptor sequences from the reads
  + fastqc: used to view the quality of the read files

```html
  sudo apt-get -y update && \
  sudo apt-get -y install samtools bowtie2 cutadapt fastqc 
  
```

And one more program that we'll install separately. This is `angsd` which we will use to find variants in our data. The first command navigates you to your home directory.
NOTE: the following should be copy-pasted line-by-line, and you should respond with yes "Y" when prompted.


```html
  cd
  sudo apt  install liblzma-dev
  sudo apt install libbz2-dev
  sudo apt-get install libcurl4-nss-dev
  git clone https://github.com/ANGSD/angsd.git 
  git clone --recursive https://github.com/samtools/htslib.git
  cd angsd
  make CRYPTOLIB=""
  
```

Now we're ready to get going. The first thing we'll do is have a look at our data and directories to make sure we know where everything is. 

```html
$ ls

```

You'll see that when we uncompressed our data file, it created a directory called 'week4', when we are in week3. Use the `mv` command to rename the directory to 'week3'.

Change directories to MarineGenomics/week3. If you `ls` into this directory you should see 6 files with a `.fastq.gz` extension and 1 tiny genome file with a `.fna.gz` extension.


## Raw read quality control

Now we are ready to start working with our data! Let's use the program fastqc to check the quality of our data files

```html
$ fastqc SRR6805880.tiny.fastq.gz

```
* Readout will say: 
  + Started analysis for SRR6805880.tiny.fastq.gz
  + Analysis complete for SRR6805880.tiny.fastq.gz


Let's look to see that it worked
```html
$ ls

Ppar_tinygenome.fna.gz       SRR6805880.tiny_fastqc.zip  SRR6805883.tiny.fastq.gz
SRR6805880.tiny.fastq.gz     SRR6805881.tiny.fastq.gz    SRR6805884.tiny.fastq.gz
SRR6805880.tiny_fastqc.html  SRR6805882.tiny.fastq.gz    SRR6805885.tiny.fastq.gz


```

Looks good! Fastqc generated two outputs for us, a `.html` and a `.zip` directory

Let's run fastqc on the remaining files, and then we'll take a look at the output. You may have noticed fastqc just used the same file name to produce our output with different extensions. We can take advantage of that by running fastqc on all our datafiles with the wildcard `*`.

```html
$ fastqc SRR680588*

```
You'll see you initially get an error message because fastqc doesn't see the .fastq file extension on some of our files. It simply skips these and moves on the the next file. 

To view the output of fastqc, we'll minimize our terminal and look at our `Home` folder on our jetstream desktop. This is the same home directory that we've been working in through the terminal. Go to the directory where you were running fastqc and find an .html file. Double click it and it should open a web browser with the output data. We'll go over how to interpret this file in class.


## Trimming to remove adapters

There are many programs to trim sequence files. We'll use the same paper that was used in the [Xuereb et al. 2018 paper](https://onlinelibrary.wiley.com/doi/pdf/10.1111/mec.14942). Cutadapt is relatively easy to run with the code below, requiring we supply the adapter sequence, input file name, and output file name.


```html
$ cutadapt -g SEQUENCETOTRIM -o name_of_input_file name_of_output_file 

```

Let's do this on one of our files to test it out.

```html
cutadapt -g TGCAG SRR6805880.tiny.fastq.gz -o SRR6805880.tiny_trimmed.fastq.gz 

```
This works for a single file, but if we want to do it for all our read files we need to either do them all individually (slow and error prone) or use the fancy for loops we just learned!


```html
for filename in *.tiny.fastq.gz
do

  base=$(basename $filename .tiny.fastq.gz)
  echo ${base}

  cutadapt -g TGCAG ${base}.tiny.fastq.gz -o ${base}.tiny_trimmed.fastq.gz 

done

```

You should see a little report for each of these files that showing how many reads were trimmed and some other info (how long are the reads, etc)

You can check if the trimmed files are there with:
```html
ls *trimmed*
```

Our reads are now ready to be mapped to the genome.



## Building an index of our genome

First we have to index our genome. We'll do that with the bowtie2-build command. This will generate a lot of files that describe different aspects of our genome

We give bowtie2-build two things, the name of our genome, and a general name to label the output files. I always keep the name of the output files the same as the original genome file (without the .fna.gz extension) to avoid confusion.

```html

bowtie2-build Ppar_tinygenome.fna.gz Ppar_tinygenome

```
This should produce several output files with extensions including: .bt2 and rev.1.bt2 etc (six files in total)

> ### Exercise
>
> Run fastqc on our .trimmed reads and compare the html with the untrimmed files. 

<details><summary><span style="color: purple;">Solution</span></summary>
<p>

> `fastqc *trimmed.fastq.gz`
> We should no longer see the red error flag for the per base sequence quality or base pairs conten. 

</p>
</details>
&nbsp;


## Map reads to the genome

Now we will need to map our reads onto the reference genome, so we can compare their sequences and call genetic variants. Here you would look at the bowtie manual to find the mapping code and it's parameters. We've already done this, and found that we need to run the `bowtie2`command with the parameters `-x` for reference, `-U` for reads, and `-S` for name of output sam file. 

Let's map those reads using a for loop

```html
for filename in *.tiny_trimmed.fastq.gz
do

  base=$(basename $filename .tiny_trimmed.fastq.gz)
  echo ${base}

  bowtie2 -x Ppar_tinygenome -U ${base}.tiny_trimmed.fastq.gz -S ${base}.trim.sam

done

```

You should see a bunch of text telling you all about how well our reads mapped to the genome. For this example we're getting a low percentage (20-30%) because of how the genome and reads were subset for this exercise. The full genome and full read files have a much higher mapping rate (70-80%) than our subset. 

You'll also notice that we have made a bunch of [.sam files](http://samtools.github.io/hts-specs/SAMv1.pdf). This stands for Sequence Alignment Map file. Let's use `less` to look at one of these files.

> ### Exercise
> Map the untrimmed files to the genome. How do the alignments compare?

<details><summary><span style="color: purple;">Solution</span></summary>
<p>

> As a for loop:
>```html
>for filename in *tiny.fastq.gz; do
>base=$(basename $filename .tiny.fastq.gz)
>echo=${base}
>bowtie2 -x Ppar_tinygenome -U ${base}.tiny.fastq.gz -S ${base}.nottrimmed.sam
>done
>```


</p>
</details>
&nbsp;

> ### Exercise
> Run the mapping for loop as a shell script using bash (i.e., store the for loop in a text editor (NANOs or other) and execute the .sh script with bash)

<details><summary><span style="color: purple;">Solution</span></summary>
<p>

> This can be done by copying and pasting the for loop in a text editor that you save as for example `map_samples_bowtie2.sh`. This script is then executed by `bash map_samples_bowtie2.sh`

</p>
</details>
&nbsp;

## sam to bam file conversion

The next step is to convert our sam file to a bam (Binary Alignment Map file). This gets our file ready to be read by angsd, the program we're going to use to call SNPs. 

Try googling the parameters of the `samtools view` command to understand what is done with `-bhS`. 

In the second half of the pipe, we are sorting our sam files and converting to a .bam output, with `-o` indicating the name of the output file(s).

```html
for filename in *.trim.sam
do

  base=$(basename $filename .trim.sam)
  echo ${base}
  
  samtools view -bhS ${base}.trim.sam | samtools sort -o ${base}.bam

done

```

## Genotype likelihoods

There are many ways and many programs that call genotypes. The program that we will use calculates genotype likelihoods, which account for uncertainty due to sequencing errors and/or mapping errors and is one of several programs in the package ANGSD. The purpose of this class is not to discuss which program is the "best", but to teach you to use some commonly used programs.

angsd needs a text file with the `.bam` file names listed. We can make that by running the command below

```html

ls *.bam > bam.filelist

```

Look at the list:
```html
cat bam.filelist
```

Run the following code to calculate genotype likelihoods

```html

../../angsd/angsd -bam bam.filelist -GL 1 -out genotype_likelihoods -doMaf 2 -SNP_pval 1e-2 -doMajorMinor 1

```

This will generate two files, one with a .arg extension, this has a record of the script we ran to generate the output, and a .maf file that will give you the minor allele frequencies and is the main output file. If you see these two files, Yay!! We did it!

> ### Exercise
> Change the parameters of the angsd genotype likelihoods command. How many more/less SNPs do we recover if we lower or raise the SNP p-value? To see what the other parameters do run `../../angsd/angsd -h

<details><summary><span style="color: purple;">Solution</span></summary>
<p>

> If we remove the `-SNP_pval` command entirely we get ~68000 sites retained! Wow! That seems like a lot given our ~20% maping rate. If you instead increase the p-value threshold to 1e-3 we find 0 SNPs. 

</p>
</details>
&nbsp;



> ### Additional Exercises

> A possible answer is located beneath each activities, but it's possible you will correctly perform the suggestion in a different way. 

> 1. Use cutadapt to trim the sequences to 70 bp like they did in the Xuereb et al. 2018 paper. Write the output of cutadapt to an .70bp.trimmed.fastq.gz and then map these 70bp, trimmed reads to the genome. How do they compare to our .trimmed reads?

<details><summary><span style="color: purple;">Solution</span></summary>
<p>
> 1. To find the parameter for maximum read length in cutadapt: `cutadapt - help` 

> `cutadapt -g TGCAG ${base}.tiny.fastq.gz -u 70 -o ${base}.tiny_70bp_trimmed.fastq.gz` 

>```html
>for filename in *tiny_70bp_trimmed.fastq.gz
>do
>base=$(basename $filename .tiny_70bp_trimmed.fastq.gz)
>echo=${base}
>bowtie2 -x Ppar_tinygenome -U ${base}.tiny_70bp_trimmed.fastq.gz  -S ${base}.70bp_trimmed.sam
>done
>```

</p>
</details>
&nbsp;



> 2. For this lesson we ran everything in the same directory and you can see that we generated quite a few files by the time we were done. Many population genomic studies have data for hundreds of individuals and running everything in the same directory gets confusing and messy. However, having the data in a different directory from the output complicates running things a little (you have to remember which directory you're in). 
>Make a new directory called `raw_data` and `mv` the raw data files (those that end in fastq.gz, and the tinygenome) into it. Then mv everything that we generated into a folder called `old_outputs`. Now rerun our code making a directory for the `trimmed_reads` and `sam_bam` files each. 


<details><summary><span style="color: purple;">Solution</span></summary>
<p>

> 2. The commands you will run include:
>
> To make a new directory and move the raw data: `mkdir raw_data; mv *fastq.gz raw_data` 
>
> To move all the old output that we generated: `mv * old_outputs`
>
> Then make output folder for each step in the process: `mkdir trimmed_reads; mkdir sam_bam`
>
> Then rerun the for loops but change the file path for the input and output data. 
>
> For example the cutadapt command can be done with a loop as shown below.
>
>```html
> for filename in raw_data/*.tiny.fastq.gz
>do
>
> base=$(basename $filename .tiny.fastq.gz)
> echo=${base}
>
>cutadapt -g TGCAG raw_data/${base}.tiny.fastq.gz -o trimmed_reads/${base}.tiny_trimmed.fastq.gz 
>
>done
>```
> You can see we've added the file name `raw_data` everytime we're calling the read files (at the beginning of the for loop and withing the cutadapt program). And we specify to put our trimmed reads in the `trimmed_reads` folder. To see if they're there run: `ls trimmed_reads`.
> Much more organized!

</p>
</details>
&nbsp;




