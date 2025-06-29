setwd("~/Data")
df <- readRDS("SiteTreatment.rds")
head(df)

#Create logged house price variable
df$logPrice <- log(df$price)

#Center Running Variable
df$runvar <- df$HRS - 26
df$runvarsq <- df$runvar^2

#Run Regression
fit1 <- lm(logPrice ~ treated + runvar + rooms + age + state, data = df)

#tr1
fit2 <- lm(logPrice ~ treated + runvar + runvarsq + treated*runvar + 
             treated*runvarsq + rooms + age + state, data = df)
t1 <- coef(fit2)["treated"]
tr1 <- exp(t1)
tr1

#tr2
untreated <- subset(df, treated == 0 & HRS >= 20 & HRS < 26)
treated <- subset(df, treated == 1 & HRS >= 26 & HRS <= 32)
tr2 <- mean(treated$logPrice) - mean(untreated$logPrice)
tr2

#price increase for avg home recieving treatment
avgprice <- mean(df$price)
newprice <- avgprice * tr1
dp <- newprice-avgprice
dp

#mccrary test
library(rddensity)
mtest <- rddensity(df$HRS, 26)
summary(mtest)
pm <- mtest$test$p_jk
pm

#treatment effect with rooms as dependent
fit3 <- lm(rooms ~ treated + runvar + runvarsq + treated*runvar + 
             treated*runvarsq + age + state, data = df)
trp <- coef(fit3)["treated"]
trp

#Number6/7
discuss1 <- paste0('the p-value of 0.0001133257 in the Mccrary Test indicates 
                   that we reject the null hypothesis: We are concluding that
                   there is discontinuity in the density of the running variable 
                   at the cutoff point, and the validity of the RD model is 
                   called into question')

discuss2 <- paste0('the trp tells us the treatment effect on the number of 
                   rooms. The trp of -0.05249 indicates that at the cutoff there 
                   was on average 0.05249 less rooms in houses that received 
                   treatment vs houses that did not, controlling for age,
                   state, runvar and runvarsq. Since this is close to zero its
                   possible that it serves as a placebo showing that treatment
                   likely did not affect unrelated home characteristics like 
                   the number of rooms')






