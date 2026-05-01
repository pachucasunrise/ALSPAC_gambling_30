** Final analyses creating excel files for creating tables and figures

* Define predictors (continous) 
local pred_cont IQ_8 sens_18 esteem_29 mat_anx emot_16 hyper_16 cond_16 peer_16 loc_29 lifeev_29 parity matfinance mat_age

* Define predictors (categorical) 
local pred_cat meds_28 dep_30 happy05 happy611 happy1215 happy1618  trauma gaming_teen gaming_adult mated finance finance26 smoke_28 alc_28 matgamb_any patgamb_any coc_30 harmdrink_30 vidgame_26 patsox matsox  cann_28 home_own crowd_index2 rc_17 rc_20 rc_24 reg17_nonmiss reg20_nonmiss reg24_nonmiss

* Run separately for males and females
* Males first (sex==1)
local sex 1

*Set up an excel file with which to output your results
putexcel set "resultsimp30_M", sheet("models") modify
putexcel A1="exposure" B1="outcome_level" C1="beta" D1="se" E1="sex" F1="RR" G1="LCI" H1="UCI" I1="outcome" J1="exposure_level" K1="N"
local x=1

* Loop over sex, predictors, and run univariate mi estimate mlogit models by different outcomes
foreach s of local sex{
	use "[filepath for dataset created in imputation_final.do - restricted to the analysis sample]", replace
			
	keep if sex_num==`s'
	foreach var of local pred_cont {
		display "Running mi estimate mlogit for predictor: `var' on at-risk categories at 30 for sex `s'"
		mim: mlogit rc_30 `var'
		mim, storebv

		local levels "Non_problem Low_risk At_risk"
		foreach l of local levels{
			local beta = _b[`l':`var']
			local se = _se[`l':`var']
			local rr=2.718^(`beta') 
			local lci=2.718^(`beta'-1.96*`se')
			local uci=2.718^(`beta'+1.96*`se')
			local n = e(MIM_Nmin)
			local x=`x'+1
			putexcel A`x'="`var'" B`x'="`l'" C`x'=`beta' D`x'=`se' E`x'="`s'" F`x'=`rr' G`x'=`lci' H`x'=`uci' I`x'="Risk-cat 30" J`x'="" K`x'=`n'
			}
			
		display "Running mi estimate mlogit for predictor: `var' on regular gambling categories at 30 for sex `s'"
		mim: mlogit reg30_nonmiss `var'
		mim, storebv

		local levels "Non_gambling Occasional_gambling Regular_gambling"
		foreach l of local levels{
			local beta = _b[`l':`var']
			local se = _se[`l':`var']
			local rr=2.718^(`beta') 
			local lci=2.718^(`beta'-1.96*`se')
			local uci=2.718^(`beta'+1.96*`se')
			local n = e(MIM_Nmin)
			local x=`x'+1
			putexcel A`x'="`var'" B`x'="`l'" C`x'=`beta' D`x'=`se' E`x'="`s'" F`x'=`rr' G`x'=`lci' H`x'=`uci' I`x'="Reg 30"	J`x'=""	K`x'=`n'
			}
		}
	foreach var of local pred_cat {
		display "Running mi estimate mlogit for predictor: `var' on at-risk categories at 30 for sex `s'"
		mim: mlogit rc_30 i.`var'
		mim, storebv

		levelsof `var' if `var' != 0, local(var_levels)
		local out_levels "Non_problem Low_risk At_risk"
		foreach l of local out_levels{
			foreach v of local var_levels{
				local beta = _b[`l':`v'.`var']
				local se = _se[`l':`v'.`var']
				local rr=2.718^(`beta') 
				local lci=2.718^(`beta'-1.96*`se')
				local uci=2.718^(`beta'+1.96*`se')
				local n = e(MIM_Nmin)
				local x=`x'+1
				putexcel A`x'="`var'" B`x'="`l'" C`x'=`beta' D`x'=`se' E`x'="`s'" F`x'=`rr' G`x'=`lci' H`x'=`uci' I`x'="Risk-cat 30" J`x'="`v'" K`x'=`n'
				}
			}
				
		display "Running mi estimate mlogit for predictor: `var' on regular gambling categories at 30 for sex `s'"
		mim: mlogit reg30_nonmiss i.`var'
		mim, storebv

		levelsof `var' if `var' != 0, local(var_levels)
		local out_levels "Non_gambling Occasional_gambling Regular_gambling"
		foreach l of local out_levels{
			foreach v of local var_levels{
				local beta = _b[`l':`v'.`var']
				local se = _se[`l':`v'.`var']
				local rr=2.718^(`beta') 
				local lci=2.718^(`beta'-1.96*`se')
				local uci=2.718^(`beta'+1.96*`se')
				local n = e(MIM_Nmin)
				local x=`x'+1
				putexcel A`x'="`var'" B`x'="`l'" C`x'=`beta' D`x'=`se' E`x'="`s'" F`x'=`rr' G`x'=`lci' H`x'=`uci' I`x'="Reg 30"	J`x'="`v'" K`x'=`n'	
				}
			}
		}
	}