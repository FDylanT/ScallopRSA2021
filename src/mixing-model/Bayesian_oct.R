## Load packages
library(dplyr)
library(readr)
library(numform)
library(MixSIAR)
library(rjags)

### Required file(s)
# OctCruiseData.csv

## Set wd
#setwd("./Repos/ScallopRSA2021")

## Load data
oct <- read.csv("./OctCruiseData.csv") %>%
  rename(Lat = Latitude_degrees_start,
         Long = Longitude_degrees_start,
         Depth = Depth_m_CTD,
         Temp = Temperature,
         DO = Dissolved_oxygen) %>%
  filter(Filtered == "") %>%
  select(Date, Station, Cast, BottleID, Lat, Long,
         Depth, Temp, Pressure, SeaPressure, Salinity,
         DIC, TA, DO) %>%
  mutate(Station = as.character(f_pad_zero(Station)))

## Find endmember property values

# surface EMs
EM1 <- which(oct$Station == "009" & oct$Cast == "Surface")
EM2 <- which(oct$Station == "091" & oct$Cast == "Surface")
EM3 <- which(oct$Station == "043" & oct$Cast == "Surface")

EM7 <- which(oct$Station == "003" & oct$Cast == "Surface") # P-town water

# bottom EMs
EM4 <- which(oct$Station == "033" & oct$Cast == "Bottom")
EM5 <- which(oct$Station == "021" & oct$Cast == "Bottom")
EM6 <- which(oct$Station == "076" & oct$Cast == "Bottom")

# pull values for EMs
S1 <- oct$Salinity[EM1]
S2 <- oct$Salinity[EM2]
S3 <- oct$Salinity[EM3]
S7 <- oct$Salinity[EM7]

S4 <- oct$Salinity[EM4]
S5 <- oct$Salinity[EM5]
S6 <- oct$Salinity[EM6]

T1 <- oct$Temp[EM1]
T2 <- oct$Temp[EM2]
T3 <- oct$Temp[EM3]
T7 <- oct$Temp[EM7]

T4 <- oct$Temp[EM4]
T5 <- oct$Temp[EM5]
T6 <- oct$Temp[EM6]

## Identify EM stat parameters

# surface EM1
EMs1 <- oct$Salinity[oct$Cast == "Surface" &
                       !is.na(oct$Temp) &
                       oct$Salinity >= S1 - 0.15 & oct$Salinity <= S1 + 0.15 &
                       oct$Temp >= T1 - 0.3 & oct$Temp <= T1 + 0.3]
for(i in 1:length(EMs1)) {
  EMs1[i] <- which(oct$Salinity == EMs1[i])
}
for(i in 1:length(EMs1)) {
  print(oct$Station[EMs1[i]])
}

# calc mean & sd for later use
mean_sal_EMs1 <- mean(oct$Salinity[EMs1])
sd_sal_EMs1 <- sd(oct$Salinity[EMs1])
sal_err1 <- sqrt((1/length(EMs1)) * (0.003^2 * length(EMs1)))
err_sal_EMs1 <- sd_sal_EMs1 + sal_err1

mean_temp_EMs1 <- mean(oct$Temp[EMs1])
sd_temp_EMs1 <- sd(oct$Temp[EMs1])
temp_err1 <- sqrt((1/length(EMs1)) * (0.002^2 * length(EMs1)))
err_temp_EMs1 <- sd_temp_EMs1 + temp_err1

# surface EM2
EMs2 <- oct$Salinity[oct$Cast == "Surface" &
                       !is.na(oct$Temp) &
                       oct$Salinity >= S2 - 0.15 & oct$Salinity <= S2 + 0.15 &
                       oct$Temp >= T2 - 0.3 & oct$Temp <= T2 + 0.3]
for(i in 1:length(EMs2)) {
  EMs2[i] <- which(oct$Salinity == EMs2[i])
}
for(i in 1:length(EMs2)) {
  print(oct$Station[EMs2[i]])
}

# calc mean & sd for later use
mean_sal_EMs2 <- mean(oct$Salinity[EMs2])
sd_sal_EMs2 <- sd(oct$Salinity[EMs2])
sal_err2 <- sqrt((1/length(EMs2)) * (0.003^2 * length(EMs2)))
err_sal_EMs2 <- sd_sal_EMs2 + sal_err2

mean_temp_EMs2 <- mean(oct$Temp[EMs2])
sd_temp_EMs2 <- sd(oct$Temp[EMs2])
temp_err2 <- sqrt((1/length(EMs2)) * (0.002^2 * length(EMs2)))
err_temp_EMs2 <- sd_temp_EMs2 + temp_err2

# surface EM3
EMs3 <- oct$Salinity[oct$Cast == "Surface" &
                       !is.na(oct$Temp) &
                       oct$Salinity >= S3 - 0.15 & oct$Salinity <= S3 + 0.15 &
                       oct$Temp >= T3 - 0.3 & oct$Temp <= T3 + 0.3]
for(i in 1:length(EMs3)) {
  EMs3[i] <- which(oct$Salinity == EMs3[i])
  EMs3[i+1] <- which(oct$Cast =="Surface" & oct$Station == "113")
}
for(i in 1:length(EMs3)) {
  print(oct$Station[EMs3[i]])
}

# calc mean & sd for later use
mean_sal_EMs3 <- mean(oct$Salinity[EMs3])
sd_sal_EMs3 <- sd(oct$Salinity[EMs3])
sal_err3 <- sqrt((1/length(EMs3)) * (0.003^2 * length(EMs3)))
err_sal_EMs3 <- sd_sal_EMs3 + sal_err3

mean_temp_EMs3 <- mean(oct$Temp[EMs3])
sd_temp_EMs3 <- sd(oct$Temp[EMs3])
temp_err3 <- sqrt((1/length(EMs3)) * (0.002^2 * length(EMs3)))
err_temp_EMs3 <- sd_temp_EMs3 + temp_err3

## Bayesian mixing model

# create mixture data: surface data w/ NAs & non-triangle sites excluded
read.csv("./OctCruiseData.csv") %>%
  rename(Temp = Temperature) %>%
  filter(Filtered == "",
         Cast == "Surface",
         !is.na(Temp),
         Station > 8) %>% # exclude sites 001-008
  select(-Filtered) %>%
  write_csv("./OctCruiseData_surface.csv")

# load mixture data
mix <- load_mix_data(filename = "./OctCruiseData_surface.csv", 
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
                MeanSalinity, SDSalinity, n), "./sources_surface.csv",
          row.names = FALSE)

# load source data
source <- load_source_data(filename = "./sources_surface.csv",
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
                MeanSalinity, SDSalinity), "./discr_surface.csv",
          row.names = FALSE)

# load discrimination data
discr <- load_discr_data(filename = "./discr_surface.csv", mix)

## Write & run model
model_filename <- "./surface_model_oct.txt"
resid_err <- FALSE # because n=1 per Station
process_err <- TRUE
write_JAGS_model(model_filename, resid_err, process_err, mix, source)

run <- list(chainLength = 5000000, burn = 2500000, thin = 500, chains = 3,
            calcDIC = TRUE)
jags.1 <- run_model(run, mix, source, discr, model_filename, alpha.prior = 1)

## Check for convergence
output_options1 <- list(summary_save = TRUE,
                         summary_name = "summary_statistics1",
                         sup_post = TRUE,
                         plot_post_save_pdf = FALSE,
                         plot_post_name = "posterior_density1",
                         sup_pairs = TRUE,
                         plot_pairs_save_pdf = FALSE,
                         plot_pairs_name = "pairs_plot1",
                         sup_xy = FALSE,
                         plot_xy_save_pdf = FALSE,
                         plot_xy_name = "xy_plot1",
                         gelman = TRUE,
                         heidel = FALSE,
                         geweke = TRUE,
                         diag_save = TRUE,
                         diag_name = "diagnostics1",
                         indiv_effect = FALSE,
                         plot_post_save_png = FALSE,
                         plot_pairs_save_png = FALSE,
                         plot_xy_save_png = FALSE,
                         diag_save_ggmcmc = FALSE,
                         return_obj = TRUE)

options(max.print = 10000) # change global option
output_JAGS(jags.1, mix, source, output_options1)
