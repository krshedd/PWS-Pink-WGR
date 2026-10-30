# From Mark Christie
# 2026-10-30

emp        <- read.csv("output/escapement_run_timing_by_district.csv")
districts  <- unique(emp[, 2]) # comment out
district   <- 222
lineage    <- "Odd" # first letter capital case

emp <- emp[which(emp[, 1] == lineage), ]
emp <- emp[which(emp[, 2] == district), ]

sum(emp$p_daily)
plot(density(emp$p_daily))

sim.deviates <- rep(emp$julian_day, 1500*emp$p_daily) # create random deviates
plot(density(sim.deviates), xlab="Julian day")        # density plot
hist(sim.deviates, , xlab="Julian day")               # histogram

plot(emp$julian_day, emp$p_daily)                     # distribution of empirical estimates 



#hist(emp$p_cumulative)
#plot(emp$julian_day, emp$p_cumulative)
#plot(emp$julian_day, cumsum(sim.deviates))
