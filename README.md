# R scripts:

## 1) Obtaining.metadata.R

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

## 2) Pie.plot.R

Features:
* **1)** Handling command-flags: *available*
* **2)** Handling standard input: *available*
* **3)** Handling multiple input files: *not available yet*

There are two types of usage:

**1)** Default usage: the input file is the standard input:

```{r}

awk -F "\t" '{print $2}' Input.file.txt | ./Pie.plot.R

```

**2)** Specifying some features:

```{r}

./Pie.plot.R --input=Input.file.txt --header=TRUE --output="trial.pdf" --title="Example"

```
