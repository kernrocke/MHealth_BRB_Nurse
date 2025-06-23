
cls
** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name          mhstigma_002.do
    //  project:                Mental Healthl Stigma in Barbados
    //  analysts:               Kern ROCKE
    //  date first created      21-JUN-2025
    // 	date last modified      21-JUN-2025
    //  algorithm task          Descriptive Analysis
    //  status                  IN PROGRESS

    ** General algorithm set-up
    version 17.0
    clear all
    macro drop _all
    set more off

    ** Initialising the STATA log and allow automatic page scrolling
    capture {
            program drop _all
    	drop _all
    	log close
    	}

    ** Set working directories: this is for DATASET and LOGFILE import and export
    ** DATASETS to encrypted SharePoint folder
	local datapath "/Users/kernrocke/Library/Mobile Documents/com~apple~CloudDocs/Github/MHealth_BRB_nurse" // Kern encrypted local

** HEADER -----------------------------------------------------

*load dataset into environment
cd "`datapath'/2.working"
use "`datapath'/2.working/mental_health_HCW_stigma.dta", clear

*-------------------------------------------------------------------------------

*Internal Consistency of OMHS

*Pre
alpha omhs_pre_1 omhs_pre_2 omhs_pre_3 omhs_pre_4 omhs_pre_5 omhs_pre_6 omhs_pre_7 omhs_pre_8 omhs_pre_9 omhs_pre_10 omhs_pre_11 omhs_pre_12 omhs_pre_13 omhs_pre_14 omhs_pre_15

** Cronbach alpha = 0.77

alpha omhs_post_1 omhs_post_2 omhs_post_3 omhs_post_4 omhs_post_5 omhs_post_6 omhs_post_7 omhs_post_8 omhs_post_9 omhs_post_10 omhs_post_11 omhs_post_12 omhs_post_13 omhs_post_14 omhs_post_15

** Cronbach alpha = 0.80

*-------------------------------------------------------------------------------

*Internal Consistency of MICA

*Pre
alpha mica_pre_1 mica_pre_2 mica_pre_3 mica_pre_4 mica_pre_5 mica_pre_6 mica_pre_7 mica_pre_8 mica_pre_9 mica_pre_10 mica_pre_11 mica_pre_12 mica_pre_13 mica_pre_14 mica_pre_15 mica_pre_16

** Cronbach alpha = 0.63

*Post
alpha mica_post_1 mica_post_2 mica_post_3 mica_post_4 mica_post_5 mica_post_6 mica_post_7 mica_post_8 mica_post_9 mica_post_10 mica_post_11 mica_post_12 mica_post_13 mica_post_14 mica_post_15 mica_post_16

** Cronbach alpha = 0.65

*-------------------------------------------------------------------------------

** Descriptive stats on scales

*OMHS

*Pre
tabstat omhs_pre_1 omhs_pre_2 omhs_pre_3 omhs_pre_4 omhs_pre_5 omhs_pre_6 omhs_pre_7 omhs_pre_8 omhs_pre_9 omhs_pre_10 omhs_pre_11 omhs_pre_12 omhs_pre_13 omhs_pre_14 omhs_pre_15 omhs_score_pre, stat(mean sd) col(stat) format(%9.1f)

*Post
tabstat omhs_post_1 omhs_post_2 omhs_post_3 omhs_post_4 omhs_post_5 omhs_post_6 omhs_post_7 omhs_post_8 omhs_post_9 omhs_post_10 omhs_post_11 omhs_post_12 omhs_post_13 omhs_post_14 omhs_post_15 omhs_score_post, stat(mean sd) col(stat) format(%9.1f)

*Examining differences in item scores pre vs post intervention

* Initialize a postfile to store results
* This creates a temporary file named "p_values.dta" and defines variables
* 'pair_id' for the test number and 'p_value' for the extracted p-value.
preserve
postfile results pair_id p_value mean_pre sd_pre mean_post sd_post mean_diff using "paired_differenes_omhs_p_values.dta", replace

*Note: variable name change to add overall score to loop
rename attitude_omhs_pre omhs_pre_16
rename disclosure_omhs_pre omhs_pre_17
rename social_omhs_pre omhs_pre_18
rename omhs_score_pre omhs_pre_19

rename attitude_omhs_post omhs_post_16
rename disclosure_omhs_post omhs_post_17
rename social_omhs_post omhs_post_18
rename omhs_score_post omhs_post_19

forvalues i = 1/19 {
    display "--- Testing omhs_pre_`i' vs. omhs_post_`i' ---"
    ttest omhs_pre_`i' = omhs_post_`i'
	post results (`i') (r(p)) (r(mu_1)) (r(sd_1)) (r(mu_2)) (r(sd_2)) (r(mu_diff))
	
    display "" // Add a blank line for better readability between tests
}

* Close the postfile to finalize the data file
postclose results

* Load the newly created dataset containing the p-values
use "paired_differenes_omhs_p_values.dta", clear
order pair_id mean_pre sd_pre mean_post sd_post mean_diff p_value
replace mean_diff = mean_pre - mean_post
format %9.3f p_value
format %9.1f mean_pre sd_pre mean_post sd_post mean_diff
save "paired_differenes_omhs_p_values.dta", replace
restore

*-------------------------------------------------------------------------------
*MICA

*Pre
tabstat mica_pre_1 mica_pre_2 mica_pre_3 mica_pre_4 mica_pre_5 mica_pre_6 mica_pre_7 mica_pre_8 mica_pre_9 mica_pre_10 mica_pre_11 mica_pre_12 mica_pre_13 mica_pre_14 mica_pre_15 mica_pre_16, stat(mean sd) col(stat) format(%9.1f)

*Post
tabstat mica_post_1 mica_post_2 mica_post_3 mica_post_4 mica_post_5 mica_post_6 mica_post_7 mica_post_8 mica_post_9 mica_post_10 mica_post_11 mica_post_12 mica_post_13 mica_post_14 mica_post_15 mica_post_16, stat(mean sd) col(stat) format(%9.1f)

*Examining differences in item scores pre vs post intervention

* Initialize a postfile to store results
* This creates a temporary file named "p_values.dta" and defines variables
* 'pair_id' for the test number and 'p_value' for the extracted p-value.
preserve
postfile results pair_id p_value mean_pre sd_pre mean_post sd_post mean_diff using "paired_differenes_mica_p_values.dta", replace

rename mica_score_pre mica_pre_17
rename mica_score_post mica_post_17

forvalues i = 1/17 {
    display "--- Testing mica_pre_`i' vs. mica_post_`i' ---"
    ttest mica_pre_`i' = mica_post_`i'
	post results (`i') (r(p)) (r(mu_1)) (r(sd_1)) (r(mu_2)) (r(sd_2)) (r(mu_diff))
	
    display "" // Add a blank line for better readability between tests
}

* Close the postfile to finalize the data file
postclose results

* Load the newly created dataset containing the p-values
use "paired_differenes_mica_p_values.dta", clear
order pair_id mean_pre sd_pre mean_post sd_post mean_diff p_value
replace mean_diff = mean_pre - mean_post
format %9.3f p_value
format %9.1f mean_pre sd_pre mean_post sd_post mean_diff
save "paired_differenes_mica_p_values.dta", replace
restore

*-------------------------------------------------------------------------------






