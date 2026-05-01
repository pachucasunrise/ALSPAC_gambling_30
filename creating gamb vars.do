*11.03.26
*ALSPAC G1 gambling measures 17-30


* use original ID-swapped data file provided by ALSPAC under project B4314.


********************************************************************
*F@17 clinic
********************************************************************

recode FJGA100-FJGA259 (-10 -1 =.) 

*How many gambled in the last 12 months 
gen gamblast12m_age17_q1to17 = .
local var "FJGA100 FJGA101 FJGA102 FJGA103 FJGA104 FJGA105 FJGA106 FJGA107 FJGA108 FJGA109 FJGA110 FJGA111 FJGA112 FJGA113 FJGA114 FJGA115 FJGA116"
foreach v of local var{
	replace gamblast12m_age17 = 1 if `v'>= 1 & `v'<=7
	replace gamblast12m_age17 = 0 if `v'==8 & gamblast12m_age17!=1
}

tab gamblast12m_age17, m 
*1 = gambled in the last 12 months = 2090

*Creating GAMBLING FREQUENCY variable (no missing data on 17 data)
*regular gambling is categorised by engaging in atleast one activity once a week or more, occasional gambling is less than weekly

recode FJGA100-FJGA116 (8=0)(5/7=1)(1/4=2)

label values FJGA100-FJGA116 gambling_freq
label define gambling_freq 0 "Not in the last 12 months" 1 "Less than Weekly" 2 "Weekly or more"

*then create the cat var 
egen maxfreq17 = rowmax(FJGA100-FJGA116)
gen reg_17 = .
replace reg_17 = 2 if maxfreq17 == 2
replace reg_17 = 1 if maxfreq17 == 1
replace reg_17 = 0 if maxfreq17 == 0

label values reg_17 gamfreq
label define gamfreq 0 "Non-gambling" 1 "Occasional gambling" 2 "Regular gambling"


*Creating PGSI cat for F@17 clinic

* recode in prep for summing the scores - changes both the 12 month and "ever" vars
recode FJGA200-FJGA208 (4=0) (3=1) (2=2) (1=3)

label values FJGA200-FJGA208 pgsi17
label define pgsi17 0"Never" 1"Sometimes" 2 "Most of the time" 3 "Almost always"

*check missing items from pgsi 
egen miss_pgsi17 = rowmiss(FJGA200-FJGA208)

*PGSI total score with no missing items 
egen pgsi_total17 = rowtotal(FJGA200-FJGA208)
replace pgsi_total17 = . if miss_pgsi17 > 0

*Create categories
gen pgsicat_17 = .
replace pgsicat_17 = 0 if pgsi_total17 == 0
replace pgsicat_17 = 1 if inrange(pgsi_total17, 1, 2)
replace pgsicat_17 = 2 if inrange(pgsi_total17, 3, 7)
replace pgsicat_17 = 3 if inrange(pgsi_total17, 8, 27)

label values pgsicat_17 pgsi17_lbl
label define pgsi17_lbl 0 "Non-problem" 1 "Low-risk" 2 "Moderate-risk" 3 "Problem gambler"

* generate at-risk pooling moderate and problem

recode pgsicat_17 (2 3 = 2), gen (rc_17)
label values rc_17 rc17_lbl
label define rc17_lbl 0 "Non-problem" 1 "Low-risk" 2 "At-risk"

**********************************************************************
*20 year data
**********************************************************************
recode CCU1100-CCU1115 CCU1140-CCU1148 (-10/-1=.)

*gambled in the last 12 months
gen gamblast12m_age20 = .
local var "CCU1100 CCU1101 CCU1102 CCU1103 CCU1104 CCU1105 CCU1106 CCU1107 CCU1108 CCU1109 CCU1110 CCU1111 CCU1112 CCU1113 CCU1114 CCU1115"
foreach v of local var{
	replace gamblast12m_age20 = 1 if `v'>= 1 & `v'<=3
	replace gamblast12m_age20 = 0 if `v'==4 & gamblast12m_age20!=1
}
tab gamblast12m_age20, m 
*3008 == 1
 

*Create GAMBLING FREQUENCY variable

recode CCU1100-CCU1115 (1 2=2)(3=1)(4=0)
label values CCU1100-CCU1115 gambling_freq20
label define gambling_freq20 0 "Not in the last 12 months" 1 "Less than Weekly" 2 "Weekly or more"

egen maxfreq20 = rowmax(CCU1100-CCU1115)
gen reg_20 = .
replace reg_20 = 2 if maxfreq20 == 2
replace reg_20 = 1 if maxfreq20 == 1
replace reg_20 = 0 if maxfreq20 == 0
label values reg_20 gamfreq
tab reg_20

*************************************
*20 year use non-missing cells for occ and non-gamblers to avoid misclassification. Fore regular gamblers as long as one regular activity, they can be classed as regular
***************************************
egen miss_gam_CCU = rowmiss(CCU1100-CCU1115)
gen gam_cat_CCU_nonmiss =.

* Regular gamblers (allow missing items)
replace gam_cat_CCU_nonmiss = 2 if maxfreq20 == 2

* Occasional gamblers (no missing items)
replace gam_cat_CCU_nonmiss = 1 if maxfreq20 == 1 & miss_gam_CCU == 0

* Non-gamblers (no missing items)
replace gam_cat_CCU_nonmiss = 0 if maxfreq20 == 0 & miss_gam_CCU == 0

*label var
label values gam_cat_CCU_nonmiss gamfreq
rename gam_cat_CCU_nonmiss reg20_nonmiss

** If restrict non-misssing, we should do the same for whether they gamble or not but this would only be for non-gamblers as if any missing you wouldn't know. But for occasional and regular, as long as down as that one one activity, we know they are gamblers. Then use this code:

gen gamblast12m_age20_nomiss = gamblast12m_age20
replace gamblast12m_age20_nomiss = . if miss_gam_CCU!=0 & gamblast12m_age20==0

*************************************************
*20 year PGSI 
*************************************************
*PGSI already in the data file but checking so corresponds which it does with CCU1151

recode CCU1140-CCU1148 (1=3)(2=2)(3=1)(4=0)
label values CCU1140-CCU1148 pgsi20
label define pgsi20 0"Never" 1"Sometimes" 2 "Most of the time" 3 "Almost always"

*check missing items from pgsi 
egen miss_pgsi20 = rowmiss(CCU1140-CCU1148)

*PGSI total score with no missing items 
egen pgsi_total20 = rowtotal(CCU1140-CCU1148)
replace pgsi_total20 = . if miss_pgsi20 > 0

*Create categories
gen pgsicat_20 = .
replace pgsicat_20 = 0 if pgsi_total20 == 0
replace pgsicat_20 = 1 if inrange(pgsi_total20, 1, 2)
replace pgsicat_20 = 2 if inrange(pgsi_total20, 3, 7)
replace pgsicat_20 = 3 if inrange(pgsi_total20, 8, 19)

label values pgsicat_20 pgsi20_lbl
label define pgsi20_lbl 0 "Non-problem" 1 "Low-risk" 2 "Moderate-risk" 3 "Problem gambler"

* generate at-risk pooling moderate and problem

recode pgsicat_20 (2 3 = 2), gen (rc_20)
label values rc_20 rc20_lbl
label define rc20_lbl 0 "Non-problem" 1 "Low-risk" 2 "At-risk"


**********************************************************************
*24 year data
**********************************************************************

recode YPD9000-YPD9016 YPD9030-YPD9038 (-10/-1=.)

*Gambled in the last 12 months 
gen gamblast12m_age24 = .
local var "YPD9000 YPD9001 YPD9002 YPD9003 YPD9004 YPD9005 YPD9006 YPD9007 YPD9008 YPD9009 YPD9010 YPD9011 YPD9012 YPD9013 YPD9014 YPD9015 YPD9016"
foreach v of local var{
	replace gamblast12m_age24 = 1 if `v'>= 1 & `v'<=3
	replace gamblast12m_age24 = 0 if `v'==0 & gamblast12m_age24!=1
}
tab gamblast12m_age24, m 
*2919 == 1

*Create GAMBLING FREQUENCY variable
recode YPD9000-YPD9016 (2 3=2)
label values YPD9000-YPD9016 gambling_freq24
label define gambling_freq24 0 "Not in the last 12 months" 1 "Less than Weekly" 2 "Weekly or more"

egen maxfreq24 = rowmax(YPD9000-YPD9016)
gen reg_24 = .
replace reg_24 = 2 if maxfreq24 == 2
replace reg_24 = 1 if maxfreq24 == 1
replace reg_24 = 0 if maxfreq24 == 0

label values reg_24 gamfreq
tab reg_24

*************************************
*24 year non-missing for occ and non-gamblers - see above notes for 20
***************************************
egen miss_gam_YPD = rowmiss(YPD9000-YPD9016)
gen gam_cat_YPD_nonmiss =.
* Regular gamblers (allow missing items)
replace gam_cat_YPD_nonmiss = 2 if maxfreq24 == 2

* Occasional gamblers (no missing items)
replace gam_cat_YPD_nonmiss = 1 if maxfreq24 == 1 & miss_gam_YPD == 0

* Non-gamblers (no missing items)
replace gam_cat_YPD_nonmiss = 0 if maxfreq24 == 0 & miss_gam_YPD == 0

*label var
label values gam_cat_YPD_nonmiss gamfreq
rename gam_cat_YPD_nonmiss reg24_nonmiss

* Gambling last 12 months - no missing for non-gamblers - see above note

gen gamblast12m_age24_nomiss = gamblast12m_age24
replace gamblast12m_age24_nomiss = . if miss_gam_YPD!=0 & gamblast12m_age24==0

*************************************************
*24 year PGSI 
*************************************************

*check missing items from pgsi 
egen miss_pgsi24 = rowmiss(YPD9030-YPD9038)

*PGSI total score with no missing items 
egen pgsi_total24 = rowtotal(YPD9030-YPD9038)
replace pgsi_total24 = . if miss_pgsi24 > 0

*Create categories
gen pgsicat_24 = .
replace pgsicat_24 = 0 if pgsi_total24 == 0
replace pgsicat_24 = 1 if inrange(pgsi_total24, 1, 2)
replace pgsicat_24 = 2 if inrange(pgsi_total24, 3, 7)
replace pgsicat_24 = 3 if inrange(pgsi_total24, 8, 25)

label values pgsicat_24 pgsi24_lbl
label define pgsi24_lbl 0 "Non-problem" 1 "Low-risk" 2 "Moderate-risk" 3 "Problem gambler"

* generate at-risk pooling moderate and problem

recode pgsicat_24 (2 3 = 2), gen (rc_24)
label values rc_24 rc24_lbl
label define rc24_lbl 0 "Non-problem" 1 "Low-risk" 2 "At-risk"


**********************************************************************
*30 year data
**********************************************************************
recode YPL4010-YPL4027 YPL4030-YPL4038 (-10 -9 -1=.)

gen gamblast12m_age30 = .
local var "YPL4010 YPL4011 YPL4012 YPL4013 YPL4014 YPL4015 YPL4016 YPL4017 YPL4018 YPL4019 YPL4020 YPL4021 YPL4022 YPL4023 YPL4024 YPL4025 YPL4026 YPL4027"
foreach v of local var{
	replace gamblast12m_age30 = 1 if `v'>= 0 & `v'<=3
	replace gamblast12m_age30 = 0 if `v'==-2 & gamblast12m_age30!=1
}
tab gamblast12m_age30, m 
*1589 == 1


*Create GAMBLING FREQUENCY variable

recode YPL4010-YPL4027 (-2 = 0) (0 1=1) (2 3=2)

label values YPL4010-YPL4027 gambling_freq30
label define gambling_freq30 0 "Not in the last 12 months" 1 "Less than Weekly" 2 "Weekly or more"

egen maxfreq30 = rowmax(YPL4010-YPL4027)
gen reg_30 = .
replace reg_30 = 2 if maxfreq30 == 2
replace reg_30 = 1 if maxfreq30 == 1
replace reg_30 = 0 if maxfreq30 == 0

label values reg_30 gamfreq
tab reg_30

*************************************
*30 year non-missing for occ and non-gamblers - see above note at 20
***************************************
egen miss_gam_YPL = rowmiss(YPL4010-YPL4027)
gen gam_cat_YPL_nonmiss =.
* Regular gamblers (allow missing items)
replace gam_cat_YPL_nonmiss = 2 if maxfreq30 == 2

* Occasional gamblers (no missing items)
replace gam_cat_YPL_nonmiss = 1 if maxfreq30 == 1 & miss_gam_YPL == 0

* Non-gamblers (no missing items)
replace gam_cat_YPL_nonmiss = 0 if maxfreq30 == 0 & miss_gam_YPL == 0

*label var
label values gam_cat_YPL_nonmiss gamfreq
rename gam_cat_YPL_nonmiss reg30_nonmiss


*************************************************
*30 year PGSI 
*************************************************

**PGSI 30 is in the data file but checking so corresponds with YPL4041
**********************

*check missing items from pgsi 
egen miss_pgsi30 = rowmiss(YPL4030-YPL4038)

*PGSI total score with no missing items 
egen pgsi_total30 = rowtotal(YPL4030-YPL4038)
replace pgsi_total30 = . if miss_pgsi30 > 0

*Create categories
gen pgsicat_30 = .
replace pgsicat_30 = 0 if pgsi_total30 == 0
replace pgsicat_30 = 1 if inrange(pgsi_total30, 1, 2)
replace pgsicat_30 = 2 if inrange(pgsi_total30, 3, 7)
replace pgsicat_30 = 3 if inrange(pgsi_total30, 8, 23)

label values pgsicat_30 pgsi30_lbl
label define pgsi30_lbl 0 "Non-problem" 1 "Low-risk" 2 "Moderate-risk" 3 "Problem gambler"

* generate at-risk pooling moderate and problem

recode pgsicat_30 (2 3 = 2), gen (rc_30)
label values rc_30 rc30_lbl
label define rc30_lbl 0 "Non-problem" 1 "Low-risk" 2 "At-risk"



******* Answered at least one questionnaire using gambling yes/no in past 12 months*******

gen completeatleast1_past12 = 1 if gamblast12m_age17_q1to17 !=.
replace completeatleast1_past12 = 1 if gamblast12m_age20_nomiss !=. & completeatleast1_past12 ==.
replace completeatleast1_past12 = 1 if gamblast12m_age24_nomiss !=. & completeatleast1_past12 ==.
replace completeatleast1_past12 = 1 if gamblast12m_age30 !=. & completeatleast1_past12 ==.
tab completeatleast1_past12
*6889

mark ALLquest_past12
markout ALLquest_past12 gamblast12m_age17_q1to17 gamblast12m_age20_nomiss gamblast12m_age24_nomiss gamblast12m_age30
tab ALLquest_past12
*1428

** if using gambling in past 12 months but allowing missing data

gen completeatleast1_past12_miss = 1 if gamblast12m_age17_q1to17 !=.
replace completeatleast1_past12_miss = 1 if gamblast12m_age20 !=. & completeatleast1_past12_miss ==.
replace completeatleast1_past12_miss = 1 if gamblast12m_age24 !=. & completeatleast1_past12_miss ==.
replace completeatleast1_past12_miss = 1 if gamblast12m_age30 !=. & completeatleast1_past12_miss ==.
tab completeatleast1_past12_miss
*6899

mark ALLquest_past12_miss
markout ALLquest_past12_miss gamblast12m_age17_q1to17 gamblast12m_age20 gamblast12m_age24 gamblast12m_age30
tab ALLquest_past12_miss
*1482


** PGSI

gen PGSIcompleteatleast1 = 1 if rc_17 !=.
replace PGSIcompleteatleast1 = 1 if rc_20 !=. & PGSIcompleteatleast1 ==.
replace PGSIcompleteatleast1 = 1 if rc_24 !=. & PGSIcompleteatleast1 ==.
replace PGSIcompleteatleast1 = 1 if rc_30 !=. & PGSIcompleteatleast1 ==.
tab PGSI
mark PGSIALL_nomiss
markout PGSIALL_nomiss rc_17 rc_20 rc_24 rc_30
tab PGSIALL

* save file

