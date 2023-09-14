#DESIGN OF EXPERIMENTS FOR DILUTE ACID PRETREATMENT
# written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

library(rsm)

# Central Composite Design - Dilute Acid
ccd(3, n0=c(2,1), 
    alpha = "rotatable", 
    randomize = TRUE,
    coding = list(x1 ~ (Temp - 173)/13, 
                  x2 ~ (time - 18)/8, 
                  x3 ~ (acid - 1.25)/0.45))