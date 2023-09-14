#RESPONSE SURFACE METHODOLOGY MODEL FOR DILUTE ACID PRETREATMENT
# written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
library(rsm)

### DAc Response Surface
DAc_Temp <- c(160,  173, 186, 186, 160, 160, 160,  173, 186, 186,  173, 173,   173, 173,  195,  151, 173)
DAc_time <- c( 10,   18,  10,  26,  10,  26,  26,   18,  10,  26,   18,  18, 31.45,  18,   18,   18, 4.55)
DAc_acid <- c(0.8, 1.25, 1.7, 1.7, 1.7, 1.7, 0.8, 1.25, 0.8, 0.8, 1.25, 0.5,  1.25,   2, 1.25, 1.25, 1.25)
DAc_XyOH <- c(1.47, 20.28, 1.66, 19.48, 3.15, 17.84, 12.79, 21.04, 4.61, 23.27, 20.45, 13.8, 21.3, 21.03, 23.29, 1.44, 1.44)
DAc_Blocks <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2)

DAc_data <- data.frame(DAc_Temp, DAc_time, DAc_acid, DAc_XyOH, DAc_Blocks)
DAc_coded <- coded.data(DAc_data, x1 ~ (DAc_Temp - 173)/13, 
                                  x2 ~ (DAc_time - 18)/8, 
                                  x3 ~ (DAc_acid - 1.25)/0.45)

DAc.rsm <- rsm(formula = DAc_XyOH ~ DAc_Blocks + SO(x1, x2, x3), data = DAc_coded)
summary(DAc.rsm)

