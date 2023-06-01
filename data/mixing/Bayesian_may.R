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

# surface EM1
EMs1 <- may$Salinity[may$Cast == "Surface" &
                       !is.na(may$Temp) &
                       may$Salinity >= S1 - 0.1 & may$Salinity <= S1 + 0.1 &
                       may$Temp >= T1 - 0.2 & may$Temp <= T1 + 0.2]
for(i in 1:length(EMs1)) {
  EMs1[i] <- which(may$Salinity == EMs1[i])
}
for(i in 1:length(EMs1)) {
  print(may$Station[EMs1[i]])
}

# calc mean & sd for later use
mean_sal_EMs1 <- mean(may$Salinity[EMs1])
sd_sal_EMs1 <- sd(may$Salinity[EMs1])
sal_err1 <- sqrt((1/length(EMs1)) * (0.003^2 * length(EMs1)))
err_sal_EMs1 <- sd_sal_EMs1 + sal_err1

mean_temp_EMs1 <- mean(may$Temp[EMs1])
sd_temp_EMs1 <- sd(may$Temp[EMs1])
temp_err1 <- sqrt((1/length(EMs1)) * (0.002^2 * length(EMs1)))
err_temp_EMs1 <- sd_temp_EMs1 + temp_err1

# surface EM2
EMs2 <- may$Salinity[may$Cast == "Surface" &
                       !is.na(may$Temp) &
                       may$Salinity >= S2 - 0.1 & may$Salinity <= S2 + 0.1 &
                       may$Temp >= T2 - 0.2 & may$Temp <= T2 + 0.2]
for(i in 1:length(EMs2)) {
  EMs2[i] <- which(may$Salinity == EMs2[i])
}
for(i in 1:length(EMs2)) {
  print(may$Station[EMs2[i]])
}

# calc mean & sd for later use
mean_sal_EMs2 <- mean(may$Salinity[EMs2])
sd_sal_EMs2 <- sd(may$Salinity[EMs2])
sal_err2 <- sqrt((1/length(EMs2)) * (0.003^2 * length(EMs2)))
err_sal_EMs2 <- sd_sal_EMs2 + sal_err2

mean_temp_EMs2 <- mean(may$Temp[EMs2])
sd_temp_EMs2 <- sd(may$Temp[EMs2])
temp_err2 <- sqrt((1/length(EMs2)) * (0.002^2 * length(EMs2)))
err_temp_EMs2 <- sd_temp_EMs2 + temp_err2

# surface EM3
EMs3 <- may$Salinity[may$Cast == "Surface" &
                       !is.na(may$Temp) &
                       may$Salinity >= S3 - 0.1 & may$Salinity <= S3 + 0.1 &
                       may$Temp >= T3 - 0.2 & may$Temp <= T3 + 0.2]
for(i in 1:length(EMs3)) {
  EMs3[i] <- which(may$Salinity == EMs3[i])
}
for(i in 1:length(EMs3)) {
  print(may$Station[EMs3[i]])
}

# calc mean & sd for later use
mean_sal_EMs3 <- mean(may$Salinity[EMs3])
sd_sal_EMs3 <- sd(may$Salinity[EMs3])
sal_err3 <- sqrt((1/length(EMs3)) * (0.003^2 * length(EMs3)))
err_sal_EMs3 <- sd_sal_EMs3 + sal_err3

mean_temp_EMs3 <- mean(may$Temp[EMs3])
sd_temp_EMs3 <- sd(may$Temp[EMs3])
temp_err3 <- sqrt((1/length(EMs3)) * (0.002^2 * length(EMs3)))
err_temp_EMs3 <- sd_temp_EMs3 + temp_err3

## Bayesian mixing model

# create mixture data: surface data w/ NAs excluded
read.csv("./MayCruiseData.csv") %>%
  rename(Temp = Temperature) %>%
  filter(Cast == "Surface",
         !is.na(Temp)#,
         #Station != 58 &   # remove possible outlier sites for model integrity
         #Station != 29 &
         #Station != 47 &
         #Station != 2
         ) %>%
  write_csv("MayCruiseData_surface.csv")

# load mixture data
mix <- load_mix_data(filename = "MayCruiseData_surface.csv", 
                     iso_names = c("Salinity", "Temp"),
                     factors = "Station",
                     fac_random = FALSE, # indiv. station is fixed effect
                     fac_nested = NULL,
                     cont_effects = NULL)

# create source data
EM <- c("EM1", "EM2", "EM3")
MeanTemp <- c(mean_temp_EMs1, mean_temp_EMs2, mean_temp_EMs3)
SDTemp <- c(err_temp_EMs1, err_temp_EMs2, err_temp_EMs3)
MeanSalinity <- c(mean_sal_EMs1, mean_sal_EMs2, mean_sal_EMs3)
SDSalinity <- c(err_sal_EMs1, err_sal_EMs2, err_sal_EMs3)
n <- c(length(EMs1), length(EMs2), length(EMs3))

write.csv(cbind(EM, MeanTemp, SDTemp,
                MeanSalinity, SDSalinity, n), "sources_surface.csv",
          row.names = FALSE)

# load source data
source <- load_source_data(filename = "sources_surface.csv",
                           source_factors = NULL, 
                           conc_dep = FALSE, 
                           data_type = "means", 
                           mix)

# create discrimination data: 0 because conservative parameters
MeanTemp <- rep(0, 3)
SDTemp <- rep(0, 3)
MeanSalinity <- rep(0, 3)
SDSalinity <- rep(0, 3)

write.csv(cbind(EM, MeanTemp, SDTemp,
                MeanSalinity, SDSalinity), "discr_surface.csv",
          row.names = FALSE)

# load discrimination data
discr <- load_discr_data(filename = "discr_surface.csv", mix)

## Write & run model
model_filename <- "surface_model_may.txt"
resid_err <- FALSE # because n=1 per Station
process_err <- TRUE
write_JAGS_model(model_filename, resid_err, process_err, mix, source)

run <- list(chainLength = 15000000, burn = 7500000, thin = 500, chains = 3,
            calcDIC = TRUE)
jags.1m <- run_model(run, mix, source, discr, model_filename, alpha.prior = 1)

## Check for convergence
output_options1m <- list(summary_save = TRUE,
                         summary_name = "summary_statistics1m",
                         sup_post = TRUE,
                         plot_post_save_pdf = FALSE,
                         plot_post_name = "posterior_density1m",
                         sup_pairs = TRUE,
                         plot_pairs_save_pdf = FALSE,
                         plot_pairs_name = "pairs_plot1m",
                         sup_xy = FALSE,
                         plot_xy_save_pdf = FALSE,
                         plot_xy_name = "xy_plot1m",
                         gelman = TRUE,
                         heidel = FALSE,
                         geweke = TRUE,
                         diag_save = TRUE,
                         diag_name = "diagnostics1m",
                         indiv_effect = FALSE,
                         plot_post_save_png = FALSE,
                         plot_pairs_save_png = FALSE,
                         plot_xy_save_png = FALSE,
                         diag_save_ggmcmc = FALSE,
                         return_obj = TRUE)

options(max.print = 10000) # change global option
output_JAGS(jags.1m, mix, source, output_options1m)
