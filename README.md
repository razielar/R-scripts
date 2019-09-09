# R scripts:

### Content:

1. [Obtaining.metadata.R](#Obtaining)
2. [Pie plot](#pie)
3. [Count Bar plot](#bar)
4. [Shannon's entropy and Isoform ratio](#entropy)
5. [Venn Diagram](#venn)
6. [Boxplots Area Pixels](#image_pixels)

## 1) <a id='Obtaining'></a> Obtaining.metadata.R

AS: *Alternative splicing*

List_of_AS_events.txt:

| AS event   |     Sample 1     |  Sample 2 |  dPSI  |
|----------|:-------------:|------:| ------:|
| DmeINT0025681 | 14.9588 | 0.5367 | 14.9409 |
| DmeINT0006388 | 8.3756 | 1.1523 | 7.0302|
| DmeALTD0001672-1/2 | 11.6038 | 4.3211 | 6.1084 |

Usage:

```{r}

./Obtaining.metadata.R  List_of_AS_events.txt

```

## 2) <a id='pie'></a> Pie.plot.R

There are three types of usage:

**a)** Default usage: the input file is the standard input:

```{r}

awk -F "\t" '{print $2}' Input.file.txt | ./Pie.plot.R

```

**b)** Specifying some features:

```{r}

./Pie.plot.R --input=Input.file.txt --header=TRUE --output="trial.pdf" --title="Example"

```
**c)** Specifying a specific color palette:

```{r}

awk -F "\t" '{print $2}' Input.file.txt |\
./Pie.plot.R --selectColor=TRUE --palette=/nfs/users2/rg/ramador/R/palettes/example.palette.txt

```

## 3) <a id='bar'></a> Bar.ggplot.R

Same features as *Pie.plot.R*

Usage:

```{r}

cat list_of_elements | ./Bar.ggplot.R --title="Desired title" --x_axis_rotation=TRUE

```

## 4) <a id='entropy'></a> Shannons.entropy.and.isoform.ratio.R

Description:

This script needs **two input** files, a transcript expression matrix in TPM/RPKM/FPMK and a GTF file with the **specific order**: *Gene_ID, Transcript_ID, Gene_Name and Transcript_name* the rest of information within the GTF will be ignored.  

Example of GTF file:

| Gene ID   |     Transcript ID     |  Gene Name |  Transcript Name  |
|----------|:-------------:|------:| ------:|
| FBgn0031208 | FBtr0300689 | CG11023 | CG11023-RB |
| FBgn0031208 | FBtr0300690 | CG11023 | CG11023-RC|
| FBgn0031208 | FBtr0330654 | CG11023 | CG11023-RD |

Features:
* Handling command-flags: *available*
* Handling standard input: *not available*

```{r}

./Shannons.entropy.and.isoform.ratio.R  --input_matrix=/Folder/Transcription.matrix.TPM.tsv  --annotation=/Folder/GTF.file.txt

```

## 5) <a id='venn'></a> Venn.Diagram.R

Description:

Receives a tsv file and returns a Venn Diagram and a file with the intersections of the items of input file.

Features:

* Handling command-flags: *available*
* Handling standard input: *available*

## 6) <a id='image_pixels'></a> Boxplots Area Pixels

Description:

Receives a *csv file* and returns Boxplots (ggplot2) in pdf, in x-axis the different phenotypes and y-axis relative wing area in pixels.  

```{r}

cat file.csv | ./Bar.ggplot.R

```
