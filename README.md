# StateSpace
## Reproducing "An Introduction to State Space Time Series Analysis" using R
Trying to reproduce the examples introduced in "An Introduction to State Space Time Series Analysis" using Stan.

### Example data:
From http://www.ssfpack.com/CKbook.html:
* logUKpetrolprice.txt
* NorwayFinland.txt
* UKdriversKSI.txt
* UKinflation.txt
* UKfrontrearseatKSI.txt

### Models:
1. Introduction
    * fig01_01.R: Linear regression
1. The local level model
    * fig02_01.R: Deterministic level
    * fig02_03.R: Stochastic level
    * fig02_05.R: The local level model and Norwegian fatalities
1. The local linear trend model
    * fig03_01.R: Stochastic level and slope
    * fig03_04.R: Stochastic level and deterministic slope
    * fig03_05.R: The local linear trend model and Finnish fatalities

1. The local level model with seasonal
    * fig04_02.R: Deterministic level and seasonal
    * fig04_06.R: Stochastic level and seasonal
    * fig04_10.R: The local level and seasonal model and UK inflation
1. The local level model with explanatory variable
    * fig05_01.R: Deterministic level and explanatory variable
    * fig05_04.R: Stochastic level and explanatory variable
1. The local level model with intervention variable
    * fig06_01.R: Deterministic level and intervention variable
    * fig06_04.R: Stochastic level and intervention variable
1. The UK seat belt and inflation models
    * fig07_01.R: Deterministic level and seasonal
    * fig07_02.R: Stochastic level and seasonal
    * fig07_04.R: The UK inflation model

- General treatment of univariate state space models
- Multivariate time series analysis
- State space and Box–Jenkins methods for time series analysis
