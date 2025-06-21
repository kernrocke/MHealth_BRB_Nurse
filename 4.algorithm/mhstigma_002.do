
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
use "`datapath'/2.working/mental_health_HCW_stigma.dta", clear
