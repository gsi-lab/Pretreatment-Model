#DESIGN OF EXPERIMENTS FOR AUTOTHERMAL PRETREATMENT
# written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

library(rsm)

# Central Composite Design - Autothermal
ccd.pick(2)
ccd(2, n0=c(3,2),
    alpha = 0.714,
    inscribed = FALSE,
    randomize = TRUE,
    coding = list(x1 ~ (Temp - 177.5)/17.5,
                  x2 ~ (time - 40)/20))


