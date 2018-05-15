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
* 1) Handling command-flags: *available*
* 2) Handling standard input: *not available*
* 3) Handling multiple input files: *not available*

Usage:

```{r}

./Pie.plot.R  --file=Input.file.txt  --header=TRUE  --title="Regeneration samples"

```
