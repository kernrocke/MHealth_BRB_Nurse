
cls
** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name          mhstigma_001.do
    //  project:                Mental Healthl Stigma in Barbados
    //  analysts:               Kern ROCKE
    //  date first created      21-JUN-2025
    // 	date last modified      21-JUN-2025
    //  algorithm task          Data cleaning to prepare dataset for analysis
    //  status                  COMPLETED

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


*Import excel dataset into environment
import excel "`datapath'/1.input/Mental Health Attitude Scale Full Excel.xlsx",  sheet("Sheet1") cellrange(A2:CD121) firstrow clear

*Cleaning study ID
replace NUMBER = "020" if NUMBER == "020`"
replace NUMBER = "069" if NUMBER == "069 "
destring NUMBER, replace

*Gender
encode GENDER, gen(gender)
replace gender = 1 if gender==3
drop GENDER
order gender, after(NUMBER)
label define gender 1"Female" 2"Male", modify
label value gender gender
tab gender

*Create Age Group
gen age_grp = .
replace age_grp = 1 if D == 1 //<25
replace age_grp = 2 if E == 1 //25-35
replace age_grp = 3 if F == 1 //36-45
replace age_grp = 4 if G == 1 //46-55
replace age_grp = 5 if H == 1 //56-65
replace age_grp = 6 if I == 1 //>65
label var age_grp "Age Group"
label define age_grp 1"<25" 2"25-35" 3"36-45" 4"46-55" 5"56-65" 6">65"
label value age_grp age_grp
order age_grp, after(gender)
*-------------------------------------------------------------------------------

*OMHS-HC-15

*Pre
local old_var_pre "Iammorecomfortablehelpinga IfacolleguewhomIworktoldm IfIwereundertreatmentforme IwouldseemyselfasweakifI Iwouldbereluctanttoseekhel Employersshouldhireaperson Iwouldstillgotoaphysianif IfIhadamentalillnessIwo Despitemyprofessionalbeliefs ThereislittleIcandotohelp Morethanhalfofpeoplewithme Iwouldnotwantapersonwitha Healthcareprovidersdonotnee Iwouldnotmindifapersonwit Istruggletofeelcompassionfo"

local num_pre = 1

foreach var in `old_var_pre' {

    rename `var' omhs_pre_`num_pre'
	
	label define omhs_pre_`num_pre' 1"Strongly Agree" 2"Agree" 3"Neither Agree or Disagree" 4"Disagree" 5"Strongly Disagree", 
	label value omhs_pre_`num_pre' omhs_pre_`num_pre'
	
    local ++num_pre
}

*Post
local old_var_post "K M O Q S U W Y AA AC AE AG AI AK AM"

local num_post = 1

foreach var in `old_var_post' {
	
	rename `var' omhs_post_`num_post'
	label define omhs_post_`num_post' 1"Strongly Agree" 2"Agree" 3"Neither Agree or Disagree" 4"Disagree" 5"Strongly Disagree", 
	label value omhs_post_`num_post' omhs_post_`num_post'
	local ++num_post
	
}
macro drop _all
*-------------------------------------------------------------------------------

*MICA-4

*Pre
local old_var_pre "Ijustlearnedaboutmentalheal Peoplewithaseverementalilln Workinginthementalillnessfi IfIhadamentalillnessIwoul Peoplewithseverementalillnes Healthsocialcarestaffknowmo BK Beingahealthsocialcareprofe Ifaseniorcollegueinstructed Ifeelascomfortbletalkingto Itsimportantthatanyhealths Thepublicdoesnotneedtobep Ifapersonwithamentalillnes Generalpractitionersshouldnot Iwouldusethetermcrazyn Ifacolleguetoldmetheyhada"

local num_pre = 1

foreach var in `old_var_pre' {

    rename `var' mica_pre_`num_pre'
	label define mica_pre_`num_pre' 1"Strongly Agree" 2"Agree" 3"Somewhat Agree" 4"Somewhat Disagree" 5"Disagree" 6"Strongly Disagree", 
	label value mica_pre_`num_pre' mica_pre_`num_pre'
	
    local ++num_pre
}

*Post
local old_var_post "AZ BB BD BF BH BJ BL BN BP BR BT BV BX BZ CB CD"

local num_post = 1

foreach var in `old_var_post' {
	
	rename `var' mica_post_`num_post'
		label define mica_post_`num_post' 1"Strongly Agree" 2"Agree" 3"Somewhat Agree" 4"Somewhat Disagree" 5"Disagree" 6"Strongly Disagree", 
	label value mica_post_`num_post' mica_post_`num_post'
	local ++num_post
	
}
macro drop _all

*-------------------------------------------------------------------------------

*Remove duplicate and unneccessary variables
drop D E F G H I AN AO AP AQ AR AS AT AU AV AW AX

*Save cleaned dataset
	local datapath "/Users/kernrocke/Library/Mobile Documents/com~apple~CloudDocs/Github/MHealth_BRB_nurse" // Kern encrypted local

label data "Mental Illness-Related Stigma in Primary Care Nurses"
save "`datapath'/2.working/mental_health_HCW_stigma.dta", replace

*---------------------------END-------------------------------------------------

