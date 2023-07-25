# Source Code

The scripts `chemistry_May.Rmd` and `chemistry_Oct.Rmd` contain calculations and other manipulation conducted on the data from both cruises.

The script `QC_check.Rmd` compares the RSA data to historical observations from the northwest Atlantic.

The folder `CTD-sal-processing` contains scripts used to process the raw CTD and salinity data, including
* `CTDprelim.Rmd`, which contains old R code originally used to load raw CTD files from both cruises.
* `CTDprocess_May.m` and `CTDprocess_Oct.m`, which contain up-to-date processing code for the raw CTD files from both cruises.
* `mixedLayer.m`, which calculates mixed-layer depths for all study sites in May and October.
* `SalinityProcess_May.Rmd` and `SalinityProcess_Oct.Rmd`, which contain code used to process salinity data from both the CTD and bottle samples measured by Dave Wellwood.
