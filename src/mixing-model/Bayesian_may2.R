## Load packages
library(dplyr)
library(readr)
library(numform)
library(MixSIAR)
library(rjags)

### Required file(s)
# MayCruiseData.csv

## Set wd
#setwd("./Repos/ScallopRSA2021")

## Load data
may <- read.csv("./MayCruiseData.csv") %>%
  rename(Lat = Latitude_degrees_start,
         Long = Longitude_degrees_start,
         Depth = Depth_m_CTD,
         Temp = Temperature,
         DO = Dissolved_oxygen) %>%
  select(Date, Station, Cast, BottleID, Lat, Long,
         Depth, Temp, Pressure, SeaPressure, Salinity,
         DIC, TA, DO) %>%
  mutate(Station = as.character(f_pad_zero(Station)))

## Find endmember property values

# surface EMs
EM1 <- which(may$Station == "004" & may$Cast == "Surface")
EM2 <- which(may$Station == "072" & may$Cast == "Surface")
EM3 <- which(may$Station == "113" & may$Cast == "Surface")

# bottom EMs
EM4 <- which(may$Station == "062" & may$Cast == "Bottom") # already-in-GB water
EM5 <- which(may$Station == "079" & may$Cast == "Bottom") # central water
EM6 <- which(may$Station == "004" & may$Cast == "Bottom") # GoM water (046, 048)
EM7 <- which(may$Station == "059" & may$Cast == "Bottom") # slope water

# pull values for EMs
S1 <- may$Salinity[EM1]
S2 <- may$Salinity[EM2]
S3 <- may$Salinity[EM3]

S4 <- may$Salinity[EM4]
S5 <- may$Salinity[EM5]
S6 <- may$Salinity[EM6]
S7 <- may$Salinity[EM7]

T1 <- may$Temp[EM1]
T2 <- may$Temp[EM2]
T3 <- may$Temp[EM3]

T4 <- may$Temp[EM4]
T5 <- may$Temp[EM5]
T6 <- may$Temp[EM6]
T7 <- may$Temp[EM7]

## Identify EM stat parameters

# bottom EM4
EMs4 <- may$Salinity[may$Cast == "Bottom" &
                       !is.na(may$Temp) &
                       may$Station != "002" &
                       may$Salinity >= S4 - 0.1 & may$Salinity <= S4 + 0.1 &
                       may$Temp >= T4 - 0.2 & may$Temp <= T4 + 0.2]
for(i in 1:length(EMs4)) {
  EMs4[i] <- which(may$Salinity == EMs4[i])
}
for(i in 1:length(EMs4)) {
  print(may$Station[EMs4[i]])
}

# calc mean & sd for later use
mean_sal_EMs4 <- mean(may$Salinity[EMs4])
sd_sal_EMs4 <- sd(may$Salinity[EMs4])
sal_err4 <- sqrt((1/length(EMs4)) * (0.003^2 * length(EMs4)))
err_sal_EMs4 <- sd_sal_EMs4 + sal_err4

mean_temp_EMs4 <- mean(may$Temp[EMs4])
sd_temp_EMs4 <- sd(may$Temp[EMs4])
temp_err4 <- sqrt((1/length(EMs4)) * (0.002^2 * length(EMs4)))
err_temp_EMs4 <- sd_temp_EMs4 + temp_err4

# bottom EM5
EMs5 <- may$Salinity[may$Cast == "Bottom" &
                       !is.na(may$Temp) &
                       may$Salinity >= S5 - 0.1 & may$Salinity <= S5 + 0.1 &
                       may$Temp >= T5 - 0.2 & may$Temp <= T5 + 0.2]
for(i in 1:length(EMs5)) {
  EMs5[i] <- which(may$Salinity == EMs5[i])
}
for(i in 1:length(EMs5)) {
  print(may$Station[EMs5[i]])
}

# calc mean & sd for later use
mean_sal_EMs5 <- mean(may$Salinity[EMs5])
sd_sal_EMs5 <- sd(may$Salinity[EMs5])
sal_err5 <- sqrt((1/length(EMs5)) * (0.003^2 * length(EMs5)))
err_sal_EMs5 <- sd_sal_EMs5 + sal_err5

mean_temp_EMs5 <- mean(may$Temp[EMs5])
sd_temp_EMs5 <- sd(may$Temp[EMs5])
temp_err5 <- sqrt((1/length(EMs5)) * (0.002^2 * length(EMs5)))
err_temp_EMs5 <- sd_temp_EMs5 + temp_err5

# bottom EM6
EMs6 <- may$Salinity[may$Cast == "Bottom" &
                       !is.na(may$Temp) &
                       #may$Station != "003" & may$Station != "004" &
                       may$Salinity >= S6 - 0.1 & may$Salinity <= S6 + 0.1 &
                       may$Temp >= T6 - 0.2 & may$Temp <= T6 + 0.2]
for(i in 1:length(EMs6)) {
  EMs6[i] <- which(may$Salinity == EMs6[i])
}
for(i in 1:length(EMs6)) {
  print(may$Station[EMs6[i]])
}

# calc mean & sd for later use
mean_sal_EMs6 <- mean(may$Salinity[EMs6])
sd_sal_EMs6 <- sd(may$Salinity[EMs6])
sal_err6 <- sqrt((1/length(EMs6)) * (0.003^2 * length(EMs6)))
err_sal_EMs6 <- sd_sal_EMs6 + sal_err6

mean_temp_EMs6 <- mean(may$Temp[EMs6])
sd_temp_EMs6 <- sd(may$Temp[EMs6])
temp_err6 <- sqrt((1/length(EMs6)) * (0.002^2 * length(EMs6)))
err_temp_EMs6 <- sd_temp_EMs6 + temp_err6

# bottom EM7
EMs7 <- may$Salinity[may$Cast == "Bottom" &
                       !is.na(may$Temp) &
                       may$Salinity >= S7 - 0.2 & may$Salinity <= S7 + 0.2 &
                       may$Temp >= T7 - 0.5 & may$Temp <= T7 + 0.5]
for(i in 1:length(EMs7)) {
  EMs7[i] <- which(may$Salinity == EMs7[i])
}
for(i in 1:length(EMs7)) {
  print(may$Station[EMs7[i]])
}

# calc mean & sd for later use
mean_sal_EMs7 <- mean(may$Salinity[EMs7])
sd_sal_EMs7 <- sd(may$Salinity[EMs7])
sal_err7 <- sqrt((1/length(EMs7)) * (0.003^2 * length(EMs7)))
err_sal_EMs7 <- sd_sal_EMs7 + sal_err7

mean_temp_EMs7 <- mean(may$Temp[EMs7])
sd_temp_EMs7 <- sd(may$Temp[EMs7])
temp_err7 <- sqrt((1/length(EMs7)) * (0.002^2 * length(EMs7)))
err_temp_EMs7 <- sd_temp_EMs7 + temp_err7

## Bayesian mixing model

# create mixture data: bottom data w/ NAs excluded
read.csv("./MayCruiseData.csv") %>%
  rename(Temp = Temperature) %>%
  filter(Cast == "Bottom",
         !is.na(Temp),
         #Station != 1 &
         #Station != 2 &
         #Station != 3 &
         #Station != 4 &
         #Station != 113
         ) %>%
  write_csv("MayCruiseData_bottom.csv")

# load mixture data
mix <- load_mix_data(filename = "MayCruiseData_bottom.csv", 
                     iso_names = c("Salinity", "Temp"),
                     factors = "Station",
                     fac_random = FALSE, # indiv. station is fixed effect
                     fac_nested = NULL,
                     cont_effects = NULL)

# create source data
EM <- c("EM4", "EM5", "EM6", "EM7")
MeanTemp <- c(mean_temp_EMs4, mean_temp_EMs5, mean_temp_EMs6, mean_temp_EMs7)
SDTemp <- c(err_temp_EMs4, err_temp_EMs5, err_temp_EMs6, err_temp_EMs7)
MeanSalinity <- c(mean_sal_EMs4, mean_sal_EMs5, mean_sal_EMs6, mean_sal_EMs7)
SDSalinity <- c(err_sal_EMs4, err_sal_EMs5, err_sal_EMs6, err_sal_EMs7)
n <- c(length(EMs4), length(EMs5), length(EMs6), length(EMs7))

write.csv(cbind(EM, MeanTemp, SDTemp,
                MeanSalinity, SDSalinity, n), "sources_bottom.csv",
          row.names = FALSE)

# load source data
source <- load_source_data(filename = "sources_bottom.csv",
                           source_factors = NULL, 
                           conc_dep = FALSE, 
                           data_type = "means", 
                           mix)

# create discrimination data: 0 because conservative parameters
MeanTemp <- rep(0, 4)
SDTemp <- rep(0, 4)
MeanSalinity <- rep(0, 4)
SDSalinity <- rep(0, 4)

write.csv(cbind(EM, MeanTemp, SDTemp,
                MeanSalinity, SDSalinity), "discr_bottom.csv",
          row.names = FALSE)

# load discrimination data
discr <- load_discr_data(filename = "discr_bottom.csv", mix)

## Write & run model
model_filename <- "bottom_model_may.txt"
resid_err <- FALSE # because n=1 per Station
process_err <- TRUE
write_JAGS_model(model_filename, resid_err, process_err, mix, source)

run <- list(chainLength = 10000000, burn = 5000000, thin = 500, chains = 3,
            calcDIC = TRUE)
jags.2m <- run_model(run, mix, source, discr, model_filename, alpha.prior = 1)

## Check for convergence
output_options2m <- list(summary_save = TRUE,
                         summary_name = "summary_statistics2m",
                         sup_post = TRUE,
                         plot_post_save_pdf = FALSE,
                         plot_post_name = "posterior_density2m",
                         sup_pairs = TRUE,
                         plot_pairs_save_pdf = FALSE,
                         plot_pairs_name = "pairs_plot2m",
                         sup_xy = FALSE,
                         plot_xy_save_pdf = FALSE,
                         plot_xy_name = "xy_plot2m",
                         gelman = TRUE,
                         heidel = FALSE,
                         geweke = TRUE,
                         diag_save = TRUE,
                         diag_name = "diagnostics2m",
                         indiv_effect = FALSE,
                         plot_post_save_png = FALSE,
                         plot_pairs_save_png = FALSE,
                         plot_xy_save_png = FALSE,
                         diag_save_ggmcmc = FALSE,
                         return_obj = TRUE)

options(max.print = 10000) # change global option
output_JAGS(jags.2m, mix, source, output_options2m)
