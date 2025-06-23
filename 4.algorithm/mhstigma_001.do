
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
	
	*User community commands
	ssc install vreverse, replace

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

** Reverse recode
foreach x of varlist omhs_pre_6 omhs_pre_7 omhs_pre_8 omhs_pre_14{
	vreverse `x', gen(`x'_r)	
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

** Reverse recode
foreach x of varlist omhs_post_6 omhs_post_7 omhs_post_8 omhs_post_14{
	vreverse `x', gen(`x'_r)	
}

macro drop _all

*Overall scoring
*Pre
egen attitude_omhs_pre = rowtotal(omhs_pre_9 omhs_pre_1 omhs_pre_10 omhs_pre_11 omhs_pre_13 omhs_pre_15)
label var attitude_omhs_pre "Attitude of health care providers towards people with mental illness"
egen disclosure_omhs_pre = rowtotal(omhs_pre_3 omhs_pre_4 omhs_pre_5 omhs_pre_8)
label var disclosure_omhs_pre "Disclosure/help seeking"
egen social_omhs_pre = rowtotal(omhs_pre_2 omhs_pre_6 omhs_pre_7 omhs_pre_12 omhs_pre_14)
label var social_omhs_pre "Social Distance"
egen omhs_score_pre = rowtotal(omhs_pre_1 omhs_pre_2 omhs_pre_3 omhs_pre_4 omhs_pre_5 omhs_pre_6 omhs_pre_7 omhs_pre_8 omhs_pre_9 omhs_pre_10 omhs_pre_11 omhs_pre_12 omhs_pre_13 omhs_pre_14 omhs_pre_15)
label var omhs_score_pre "Overal OMHS Score"


*Post
egen attitude_omhs_post = rowtotal(omhs_post_9 omhs_post_1 omhs_post_10 omhs_post_11 omhs_post_13 omhs_post_15)
label var attitude_omhs_post "Attitude of health care providers towards people with mental illness"
egen disclosure_omhs_post = rowtotal(omhs_post_3 omhs_post_4 omhs_post_5 omhs_post_8)
label var disclosure_omhs_post "Disclosure/help seeking"
egen social_omhs_post = rowtotal(omhs_post_2 omhs_post_6 omhs_post_7 omhs_post_12 omhs_post_14)
label var social_omhs_post "Social Distance"
egen omhs_score_post = rowtotal(omhs_post_1 omhs_post_2 omhs_post_3 omhs_post_4 omhs_post_5 omhs_post_6 omhs_post_7 omhs_post_8 omhs_post_9 omhs_post_10 omhs_post_11 omhs_post_12 omhs_post_13 omhs_post_14 omhs_post_15)
label var omhs_score_post "Overal OMHS Score"

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

*Overall score
egen mica_score_pre = rowtotal(mica_pre_1 mica_pre_2 mica_pre_3 mica_pre_4 mica_pre_5 mica_pre_6 mica_pre_7 mica_pre_8 mica_pre_9 mica_pre_10 mica_pre_11 mica_pre_12 mica_pre_13 mica_pre_14 mica_pre_15 mica_pre_16)
label var mica_score_pre "MICA Overall score"


*Post
local old_var_post "AZ BB BD BF BH BJ BL BN BP BR BT BV BX BZ CB CD"

local num_post = 1

foreach var in `old_var_post' {
	
	rename `var' mica_post_`num_post'
		label define mica_post_`num_post' 1"Strongly Agree" 2"Agree" 3"Somewhat Agree" 4"Somewhat Disagree" 5"Disagree" 6"Strongly Disagree", 
	label value mica_post_`num_post' mica_post_`num_post'
	local ++num_post
	
}

*Overall score
egen mica_score_post = rowtotal(mica_post_1 mica_post_2 mica_post_3 mica_post_4 mica_post_5 mica_post_6 mica_post_7 mica_post_8 mica_post_9 mica_post_10 mica_post_11 mica_post_12 mica_post_13 mica_post_14 mica_post_15 mica_post_16)
label var mica_score_post "MICA Overall score"
macro drop _all

*-------------------------------------------------------------------------------

*Remove duplicate and unneccessary variables
drop D E F G H I AN AO AP AQ AR AS AT AU AV AW AX

*Save cleaned dataset
	local datapath "/Users/kernrocke/Library/Mobile Documents/com~apple~CloudDocs/Github/MHealth_BRB_nurse" // Kern encrypted local

label data "Mental Illness-Related Stigma in Primary Care Nurses"
save "`datapath'/2.working/mental_health_HCW_stigma.dta", replace

*---------------------------END-------------------------------------------------

