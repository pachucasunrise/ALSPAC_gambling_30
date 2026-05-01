***** IMPUTATION 30 SETS*****

* load dataset created in 'creating and recoding covariates.do'

*recoding certain variables that have -9999 values
mvdecode reg_17 rc_17 reg_20 rc_20 reg_24 rc_24 reg_30 rc_30 smoke_28 alc_28 meds_28 cann_28 loc_29 esteem_29 lifeev_29 coc_30 harmdrink_30 gaming_child gaming_teen gaming_adult dep_30 sex_num vidgame_26 finance IQ_8 sens_18 emot_16 cond_16 hyper_16 peer_16 happy05 happy611 happy1215 happy1618 trauma mated mat_age mat_anx matsox patsox matgamb_any parity crowd_index2 home_own reg20_nonmiss reg24_nonmiss reg30_nonmiss completeatleast1 completeatleast1_miss ALLquest_nonmiss ALLquest_miss PGSIcompleteatleast1 PGSIALL_nomiss patgamb_any matfinance finance26, mv (-9999)

* save dataset for use in imputation on full ALSPAC sample later (as will use to create table comparing covariates between full cohort and analysis sample)

* restrict sample to those who said yes to gambling in the past 12 months and answered at least one of the four gambling questionnaires (the main analysis sample)

keep if completeatleast1_past12 ==1

* generate a copy of the rc variables to put in imputation model

local num "17 20 24 30"
foreach n of local num{
gen rc_`n'_raw = rc_`n'
}

* prepare for imputation 
mi set mlong

mi register imputed IQ_8 crowd_index2 finance matfinance finance26 mat_anx dep_30 emot_16 hyper_16 cond_16 peer_16 sens_18 smoke_28 alc_28 trauma matgamb_any patgamb_any loc_29 esteem_29 harmdrink_30 meds_28 happy05 happy611 happy1215 happy1618 rc_17_raw rc_20_raw rc_24_raw rc_30_raw coc_30 lifeev_29 cann_28 gaming_teen gaming_adult reg_17 reg20_nonmiss reg24_nonmiss reg30_nonmiss matsox patsox home_own parity mated mat_age vidgame_26

mi register regular sex_num 

mi impute chained (pmm, knn(5)) IQ_8 sens_18 esteem_29 mat_anx emot_16 hyper_16 cond_16 peer_16 loc_29 lifeev_29 cann_28 matfinance parity mat_age (logit) finance26 meds_28 happy05 happy611 happy1215 happy1618 trauma gaming_adult gaming_teen matsox patsox mated (ologit) vidgame_26 home_own finance crowd_index2 dep_30 smoke_28 alc_28 rc_17_raw rc_20_raw rc_24_raw rc_30_raw matgamb_any patgamb_any coc_30 harmdrink_30 reg_17 reg20_nonmiss reg24_nonmiss reg30_nonmiss, by(sex_num) rseed(1800) add(30) replace noisily augment force

* create a regular gambling variable at 17 that's named as all the others
mi xeq: gen reg17_nonmiss = reg_17

* recode alcohol use
mi xeq: recode alc_28 (2 = 0) (0 = 1) (1 = 2)
label define alc2_lb 0 "Does not drink" 1 "<7 units" 2 ">=7 units"
mi xeq: label values alc_28 alc2_lb 

drop rc_17 rc_20 rc_24 rc_30

local nums 17 20 24 30

* Create the rc_n variable in every imputation (initialize as missing)
foreach n of local nums {
    mi xeq: gen rc_`n' = .
}

* Fill rc_n using the rules
foreach n of local nums {
    * 1. When regn_nonmiss > 0, use the imputed raw value
    mi xeq: replace rc_`n' = rc_`n'_raw 
	**if reg_`n' > 0

    * 2. When regn_nonmiss == 0, assign category -1
    mi xeq: replace rc_`n' = -1 if reg`n'_nonmiss == 0
	*& rc_`n'==.
	
	*3. replace the -1 for regression models
	mi xeq: replace rc_`n' = rc_`n' + 1
}

* labels
label define rcn2_lbl 0 "Non-gambler" 1 "Non-problem" 2 "Low risk" 3 "At-risk", replace

foreach n of local nums {
    mi xeq: label values rc_`n' rcn2_lbl
}

*save file - imputed dataset of analysis sample
