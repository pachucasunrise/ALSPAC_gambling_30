*use file created from 'creating gambling vars.do'

* all YPH vars @28

recode YPH5520 (-10 -9 -1 = .) (-2 = 1) (0 = 2) (1 = 3), gen (smoke_28) 
recode YPH5670 (-10 -9 -1 = .) (1/3 = 0) (4/5 = 1) (-2 = 2), gen(alc_28) 
recode YPH7000 (-10 = .) (1 = 1) (2=0), gen (meds_28) 
recode YPH5650 (-10 -9 -1 = .) (1 2 3 = 1) (4 5 = 2) (6 = 0), gen (cann_28) 

label values smoke_28 sm_lb
label define sm_lb 1 "Does not smoke" 2 "< weekly" 3 "Weekly" 
 
label values alc_28 alc_lb
label define alc_lb 2 "Does not drink" 0 "<7 units" 1 ">=7 units" 

label values meds_28 med_lb
label define med_lb 1 "Yes" 0"No"

label values cann_28 ca_lb
label define ca_lb 1 "monthly or less" 2 ">=weekly" 0 "not in past 12m"


** all YPJ variables @29

recode YPJ1012 (-10 -1 = .), gen (loc_29) 
recode YPJ1031 (-10 -1 = .), gen (esteem_29) 
recode YPJ1547 (-10 -1 = .), gen (lifeev_29) 

** all YPK variables @30

recode YPK8010 (-10 -9 -1 = .) (0=1) (1=2) (2=3), gen (coc_30) 
recode YPK8602 (-10 -9 -1 = .) (1 2 =0) (3 4 =1), gen (harmdrink_30) 
recode YPK1610 (-10 -1 = .) (0=0) (1=1), gen (gaming_child)
recode YPK1620 (-10 -1 = .) (0=0) (1=1), gen (gaming_teen)
recode YPK1630 (-10 -1 = .) (0=0) (1=1), gen (gaming_adult)

label values coc_30 coc_lb
label define coc_lb 1 "No never"  2 "Yes in past" 3 "Yes recently"

label values harmdrink_30 drink_lb
label define drink_lb 0 "Low/increasing risk"  1 "High risk/poss dependence" 

label values gaming_child gch_lb
label values gaming_teen gte_lb
label values gaming_adult gad_lb

label define gch_lb 0 "No" 1 "Yes"
label define gte_lb 0 "No" 1 "Yes"
label define gad_lb 0 "No" 1 "Yes"


** all YPL variables (not gambling ones) @30

recode YPL2016 (-10 -9 = .) (1=3) (2=2) (3=1), gen (dep_30)

label values dep_30 dep_lb
label define dep_lb 1 "No depression" 2 "Possible depression" 3 "Probable depression"


** Other confounders/adjustment/analyses variables

* Sex
recode kz021 (-2 = .) (1 =1 "Male") (2 = 0 "Female"), gen (sex_num)

* locus of control @27 
recode YPG4120 (-10 -9 -1 =.), gen (loc_27) 

* video games @26
mvdecode YPF3090 YPF3160, mv (-10 -9 -1)

egen maxfreqvideo26 = rowmax(YPF3090 YPF3160)
gen vidgame_26 = .
replace vidgame_26 = 0 if maxfreqvideo == 0
replace vidgame_26 = 1 if maxfreqvideo == 1
replace vidgame_26 = 2 if maxfreqvideo == 2
replace vidgame_26 = 3 if maxfreqvideo == 3
replace vidgame_26 = 4 if maxfreqvideo == 4
replace vidgame_26 = 4 if maxfreqvideo == 5
replace vidgame_26 = 4 if maxfreqvideo == 6

label values vidgame_26 v2_lb
label define v2_lb 0 "<1 hr" 1 "1-2 hrs" 2 "2-3 hrs" 3 "3-4 hrs" 4 ">4 hrs"

* Financial management

recode YPL3000 (-10 -1 =.) (1=1) (2=2) (3 4 5 9 =3), gen (finance)

label values finance fi_lb
label define fi_lb 1 "Living comfortably" 2 "Doing OK" 3 "Doing less well"


recode YPF6220 (-10 -9 -1 =.) (0 =0) (1/4 =1), gen (finance26)
label values finance26 fi26_lb
label define fi26_lb 0 "No" 1 "Yes"

recode c525 (-7 -1 =.), gen (matfinance)

* IQ @8
recode f8ws112 (-3 -2 =.), gen (IQ_8)

* Sensation seeking @18
recode cct2035 (-10 -1 =.), gen (sens_18)

* SDQ @16 - here the -9999 are different from gambling vars

gen emot_16 = tc4025a
gen cond_16 = tc4025b
gen hyper_16 = tc4025c
gen peer_16 = tc4025d

mvdecode emot_16 cond_16 hyper_16 peer_16, mv(-10 -1)


* Childhood happiness @various time points 
recode YPG2330 (-10 -9 -1 =.) (1 2 = 0) (3 4 5 6 =1), gen (happy05)
recode YPG2331 (-10 -9 -1 =.) (1 2 = 0) (3 4 5 6 =1), gen (happy611)
recode YPG2332 (-10 -9 -1 =.) (1 2 = 0) (3 4 5 6 =1), gen (happy1215)
recode YPG2333 (-10 -9 -1 =.) (1 2 = 0) (3 4 5 6 =1), gen (happy1618)

label values happy05 ha1_lb
label values happy611 ha2_lb
label values happy1215 ha3_lb
label values happy1618 ha4_lb

label define ha1_lb 0 "Happy" 1 "Less happy"
label define ha2_lb 0 "Happy" 1 "Less happy"
label define ha3_lb 0 "Happy" 1 "Less happy"
label define ha4_lb 0 "Happy" 1 "Less happy"

* Teen trauma @11-17
recode clon159 (-10 -1 =.), gen (trauma)

label values trauma tr_lb
label define tr_lb 0 "No" 1 "Yes"

* Maternal education 
recode c645a (-1=.) (1/4=0) (5=1), gen (mated)

label values mated mated_lb
label define mated_lb 0 "Lower than degree" 1 "Degree"

* Mother's age 
recode mz028b (-10 -4 -2 =.), gen (mat_age)

* Maternal anxiety
recode b357 (-7 -1 =.), gen (mat_anx)

* Social class
recode c755 (-1 65 =.) (1 2 = 0) (3/6 =1), gen (matsox)
recode c765 (-1 65 =.) (1 2 = 0) (3/6 =1), gen (patsox)

label values matsox msox_lb
label values patsox psox_lb

label define msox_lb 0 "I/II" 1 "III/V"
label define psox_lb 0 "I/II" 1 "III/V"

* Familial gambling
recode t2121 (-10 -2 =.) (0 = 0) (1 = 1) (2/4 = 2), gen (matgamb_any)

label values matgamb_any mgamb_lb
label define mgamb_lb 0 "Non-gambler" 1 "Non=problem gambler" 2 "Any risk gambler"

recode fpa2121 (-2 =.) (0 = 0 "Non-gambler") (1 = 1 "Non=problem gambler") (2/4 = 2 "Any risk gambler"), gen (patgamb_any)

* Parity
recode b032 (-7 -2 -1 = .), gen (parity)

* Crowding index
recode a551 (-7 -1 = .), gen (crowd_index)

label values crowd_index crowd_lb
label define crowd_lb 1 "<=0.5" 2 ">0.5-0.75" 3 ">0.75-1" 4 ">1"

recode crowd_index (3 4 = 3), gen(crowd_index2)
label define crowd_index2 1 "<=0.5" 2 ">0.5-0.75" 3 ">0.75"
label values crowd_index2 crowd_index2
	

* Maternal home ownership
recode a006 (-7 -1 6 = .) (0 1 = 0) (2 5 = 2) (3 4 =1), gen (home_own)

label values home_own home_lb
label define home_lb 0 "Owner-occupied" 1 "Private rent" 2 "Social rent"


* save file


