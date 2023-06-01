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

# bottom EM4
EMs4 <- oct$Salinity[oct$Cast == "Bottom" &
                       !is.na(oct$Temp) &
                       oct$Salinity >= S4 - 0.25 & oct$Salinity <= S4 + 0.25 &
                       oct$Temp >= T4 - 0.6 & oct$Temp <= T4 + 0.6]
for(i in 1:length(EMs4)) {
  EMs4[i] <- which(oct$Salinity == EMs4[i])
}
for(i in 1:length(EMs4)) {
  print(oct$Station[EMs4[i]])
}

# calc mean & sd for later use
mean_sal_EMs4 <- mean(oct$Salinity[EMs4])
sd_sal_EMs4 <- sd(oct$Salinity[EMs4])
sal_err4 <- sqrt((1/length(EMs4)) * (0.003^2 * length(EMs4)))
err_sal_EMs4 <- sd_sal_EMs4 + sal_err4

mean_temp_EMs4 <- mean(oct$Temp[EMs4])
sd_temp_EMs4 <- sd(oct$Temp[EMs4])
temp_err4 <- sqrt((1/length(EMs4)) * (0.002^2 * length(EMs4)))
err_temp_EMs4 <- sd_temp_EMs4 + temp_err4

# bottom EM5
EMs5 <- oct$Salinity[oct$Cast == "Bottom" &
                       !is.na(oct$Temp) &
                       oct$Salinity >= S5 - 0.25 & oct$Salinity <= S5 + 0.25 &
                       oct$Temp >= T5 - 0.6 & oct$Temp <= T5 + 0.6]
for(i in 1:length(EMs5)) {
  EMs5[i] <- which(oct$Salinity == EMs5[i])
}
for(i in 1:length(EMs5)) {
  print(oct$Station[EMs5[i]])
}

# calc mean & sd for later use
mean_sal_EMs5 <- mean(oct$Salinity[EMs5])
sd_sal_EMs5 <- sd(oct$Salinity[EMs5])
sal_err5 <- sqrt((1/length(EMs5)) * (0.003^2 * length(EMs5)))
err_sal_EMs5 <- sd_sal_EMs5 + sal_err5

mean_temp_EMs5 <- mean(oct$Temp[EMs5])
sd_temp_EMs5 <- sd(oct$Temp[EMs5])
temp_err5 <- sqrt((1/length(EMs5)) * (0.002^2 * length(EMs5)))
err_temp_EMs5 <- sd_temp_EMs5 + temp_err5

# bottom EM6
EMs6 <- oct$Salinity[oct$Cast == "Bottom" &
                     !is.na(oct$Temp) &
                     oct$Salinity >= S6 - 0.25 & oct$Salinity <= S6 + 0.25 &
                     oct$Temp >= T6 - 0.6 & oct$Temp <= T6 + 0.6]
for(i in 1:length(EMs6)) {
  EMs6[i] <- which(oct$Salinity == EMs6[i])
}
for(i in 1:length(EMs6)) {
  print(oct$Station[EMs6[i]])
}

# calc mean & sd for later use
mean_sal_EMs6 <- mean(oct$Salinity[EMs6])
sd_sal_EMs6 <- sd(oct$Salinity[EMs6])
sal_err6 <- sqrt((1/length(EMs6)) * (0.003^2 * length(EMs6)))
err_sal_EMs6 <- sd_sal_EMs6 + sal_err6

mean_temp_EMs6 <- mean(oct$Temp[EMs6])
sd_temp_EMs6 <- sd(oct$Temp[EMs6])
temp_err6 <- sqrt((1/length(EMs6)) * (0.002^2 * length(EMs6)))
err_temp_EMs6 <- sd_temp_EMs6 + temp_err6

## Bayesian mixing model

# create mixture data: bottom data w/ NAs excluded
read.csv("./OctCruiseData.csv") %>%
  rename(Temp = Temperature) %>%
  filter(Filtered == "",
         Cast == "Bottom",
         !is.na(Temp)) %>%
  select(-Filtered) %>%
  write_csv("OctCruiseData_bottom.csv")

# load mixture data
mix <- load_mix_data(filename = "OctCruiseData_bottom.csv", 
                     iso_names = c("Salinity", "Temp"),
                     factors = "Station",
                     fac_random = FALSE, # indiv. station is fixed effect
                     fac_nested = NULL,
                     cont_effects = NULL)

# create source data
EM <- c("EM4", "EM5", "EM6")
MeanTemp <- c(mean_temp_EMs4, mean_temp_EMs5, mean_temp_EMs6)
SDTemp <- c(err_temp_EMs4, err_temp_EMs5, err_temp_EMs6)
MeanSalinity <- c(mean_sal_EMs4, mean_sal_EMs5, mean_sal_EMs6)
SDSalinity <- c(err_sal_EMs4, err_sal_EMs5, err_sal_EMs6)
n <- c(length(EMs4), length(EMs5), length(EMs6))

write.csv(cbind(EM, MeanTemp, SDTemp,
                MeanSalinity, SDSalinity, n), "./sources_bottom.csv",
          row.names = FALSE)

# load source data
source <- load_source_data(filename = "sources_bottom.csv",
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
                MeanSalinity, SDSalinity), "discr_bottom.csv",
          row.names = FALSE)

# load discrimination data
discr <- load_discr_data(filename = "discr_bottom.csv", mix)

## Write & run model
model_filename <- "bottom_model_oct.txt"
resid_err <- FALSE # because n=1 per Station
process_err <- TRUE
write_JAGS_model(model_filename, resid_err, process_err, mix, source)

run <- list(chainLength = 3000000, burn = 1500000, thin = 500, chains = 3,
            calcDIC = TRUE)
jags.2 <- run_model(run, mix, source, discr, model_filename, alpha.prior = 1)

## Check for convergence
output_options2 <- list(summary_save = TRUE,
                         summary_name = "summary_statistics2",
                         sup_post = TRUE,
                         plot_post_save_pdf = FALSE,
                         plot_post_name = "posterior_density2",
                         sup_pairs = TRUE,
                         plot_pairs_save_pdf = FALSE,
                         plot_pairs_name = "pairs_plot2",
                         sup_xy = FALSE,
                         plot_xy_save_pdf = FALSE,
                         plot_xy_name = "xy_plot2",
                         gelman = TRUE,
                         heidel = FALSE,
                         geweke = TRUE,
                         diag_save = TRUE,
                         diag_name = "diagnostics2",
                         indiv_effect = FALSE,
                         plot_post_save_png = FALSE,
                         plot_pairs_save_png = FALSE,
                         plot_xy_save_png = FALSE,
                         diag_save_ggmcmc = FALSE,
                         return_obj = TRUE)

options(max.print = 10000) # change global option
output_JAGS(jags.2, mix, source, output_options2)
