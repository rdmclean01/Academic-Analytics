//Scale Creation
egen Q_open_mom = rowmean (C_Mutual_1_P1 C_Mutual_2_P1 C_Mutual_3_P1 C_Mutual_4_P1 C_Mutual_6_P1 C_Open_2_P1 C_Open_3_P1 C_Open_4_P1 C_Open_6_P1) 
egen Q_open_dad = rowmean (C_Mutual_1_P2 C_Mutual_2_P2 C_Mutual_3_P2 C_Mutual_4_P2 C_Mutual_6_P2 C_Open_2_P2 C_Open_3_P2 C_Open_4_P2 C_Open_6_P2) 
egen Q_cont_mom = rowmean (C_Control_1_P1 C_Control_2_P1 C_Control_3_P1 C_Control_4_P1 C_Control_5_P1 C_Control_6_P1 C_Open_5_P1)
egen Q_cont_dad = rowmean (C_Control_1_P2 C_Control_2_P2 C_Control_3_P2 C_Control_4_P2 C_Control_5_P2 C_Control_6_P2 C_Open_5_P2)
label variable Q_open_mom "Mom Quality dimension, openness subscale"
label variable Q_cont_mom "Mom Quality dimension, control subscale"
label variable Q_open_dad "Dad Quality dimension, openness subscale"
label variable Q_cont_dad "Dad Quality dimension, control subscale"

// Check Reliability
alpha C_Condom C_Contraception
alpha zC_Intercourse_1b_TEXT zC_Intercourse_1c_TEXT zC_Oral_1b_TEXT zC_Oral_1c_TEXT zC_Oral_2b_TEXT zC_Oral_2c_TEXT

egen risk = rowmean (zC_Intercourse_1b_TEXT zC_Intercourse_1c_TEXT zC_Oral_1b_TEXT zC_Oral_1c_TEXT zC_Oral_2b_TEXT zC_Oral_2c_TEXT) 
	label variable risk "Sexual Frequency in the Last Six Months"
egen contracep = rowmean(C_Condom C_Contraception)
	label variable contracep "Contraceptive Use in the Last Six Months"


global demog C_Age minority heterosexual C_Income C_Relationship //C_RelatLength 
global father_q warm_dad Q_open_dad Q_cont_dad
global father F_risk_dad F_pos_dad F_phys_dad
global mother_q warm_mom Q_open_mom Q_cont_mom
global mother F_risk_mom F_pos_mom F_phys_mom
global outcomes shame este anx risk contracep restr
global condition if sample_`outcome'==1

foreach outcome of global outcomes {
foreach quality of global mother_q { 
	qui gen inter_F_risk_mom = `quality'*F_risk_mom
	qui gen inter_F_pos_mom = `quality'*F_pos_mom 
	qui gen inter_F_phys_mom = `quality'*F_phys_mom
	
	qui reg `outcome' C_Sex $demog `quality' F_risk_mom F_pos_mom F_phys_mom inter_F_risk_mom inter_F_pos_mom inter_F_phys_mom, beta
	//reg `outcome' $demog C_Sex##c.`quality'##c.F_risk_mom i.C_Sex#c.`quality'#c.F_pos_mom i.C_Sex#c.`quality'#c.F_phys_mom, beta
	
	qui gen sample_`outcome' = e(sample)

	qui reg `outcome' C_Sex $demog $condition, beta
	eststo m1
	local r2_1 = e(r2)
	qui reg `outcome' C_Sex $demog `quality' F_risk_mom F_pos_mom F_phys_mom $condition, beta
	eststo m2
	local r2_2 = e(r2)
	qui reg `outcome' C_Sex $demog `quality' F_risk_mom F_pos_mom F_phys_mom inter_F_risk_mom inter_F_pos_mom inter_F_phys_mom $condition, beta
	eststo m3
	local r2_3 = e(r2)
	
	local dr2_1v2 = `r2_2' - `r2_1'
	local dr2_2v3 = `r2_3' - `r2_2'
	
	// Display a table of significant differences
	display "R2 initial = `r2_1'"
	display "R2 change level 2 = `dr2_1v2'"
	display "R2 change level 3 = `dr2_2v3'" 
	display "Total R2 = `r2_3'"
	lrtest m1 m2
	lrtest m2 m3
	
	
	// If p-value of the interaction is significant, create moderation graph
	local pval1 = 2 * ttail(e(df_r), abs(_b[inter_F_risk_mom]/_se[inter_F_risk_mom]))
	local pval2 = 2 * ttail(e(df_r), abs(_b[inter_F_pos_mom]/_se[inter_F_pos_mom]))
	local pval3 = 2 * ttail(e(df_r), abs(_b[inter_F_phys_mom]/_se[inter_F_phys_mom]))
	
	if(`pval1' < 0.1) {
		quietly margins, at(`quality'=(1(1)5) F_risk_mom=(1(1)6)) atmeans
		marginsplot, noci ytitle(Plot for `outcome' (p = `pval1'))
		graph export graphs\graph_`outcome'_`quality'_risk-mom.png, replace
	}
	else { // Do nothing
		//display "FALSE: `pval1' AND `pval2' AND `pval4'"
	}
	if(`pval2' < 0.1) {
		quietly margins, at(`quality'=(1(1)5) F_pos_mom=(1(1)6)) atmeans
		marginsplot, noci ytitle(Plot for `outcome' (p = `pval2'))
		graph export graphs\graph_`outcome'_`quality'_pos-mom.png, replace
	}
	else { // Do nothing
		//display "FALSE: `pval1' AND `pval2' AND `pval4'"
	}
	if(`pval3' < 0.1) {
		quietly margins, at(`quality'=(1(1)5) F_phys_mom=(1(1)6)) atmeans
		marginsplot, noci ytitle(Plot for `outcome' (p = `pval3'))
		graph export graphs\graph_`outcome'_`quality'_phys-mom.png, replace
	}
	else { // Do nothing
		//display "FALSE: `pval1' AND `pval2' AND `pval4'"
	}
	
	drop sample_* inter*
}
}

foreach outcome of global outcomes {
foreach quality of global father_q { 
	qui gen inter_F_risk_dad = `quality'*F_risk_dad
	qui gen inter_F_pos_dad = `quality'*F_pos_dad 
	qui gen inter_F_phys_dad = `quality'*F_phys_dad
	
	qui reg `outcome' C_Sex $demog `quality' F_risk_dad F_pos_dad F_phys_dad inter_F_risk_dad inter_F_pos_dad inter_F_phys_dad, beta
	
	qui gen sample_`outcome' = e(sample)

	reg `outcome' C_Sex $demog $condition, beta
	eststo m1
	local r2_1 = e(r2)
	reg `outcome' C_Sex $demog `quality' F_risk_dad F_pos_dad F_phys_dad $condition, beta
	eststo m2
	local r2_2 = e(r2)
	reg `outcome' C_Sex $demog `quality' F_risk_dad F_pos_dad F_phys_dad inter_F_risk_dad inter_F_pos_dad inter_F_phys_dad $condition, beta
	eststo m3
	local r2_3 = e(r2)
	
	local dr2_1v2 = `r2_2' - `r2_1'
	local dr2_2v3 = `r2_3' - `r2_2'

	display "R2 initial = `r2_1'"
	display "R2 change level 2 = `dr2_1v2'"
	display "R2 change level 3 = `dr2_2v3'" 
	display "Total R2 = `r2_3'"
	lrtest m1 m2
	lrtest m2 m3
	
	
		// If p-value of the interaction is significant, create graph
	local pval1 = 2 * ttail(e(df_r), abs(_b[inter_F_risk_dad]/_se[inter_F_risk_dad]))
	local pval2 = 2 * ttail(e(df_r), abs(_b[inter_F_pos_dad]/_se[inter_F_pos_dad]))
	local pval3 = 2 * ttail(e(df_r), abs(_b[inter_F_phys_dad]/_se[inter_F_phys_dad]))
	
	if(`pval1' < 0.1) {
		quietly margins, at(`quality'=(1(1)5) F_risk_dad=(1(1)6)) atmeans
		marginsplot, noci ytitle(Plot for `outcome' (p = `pval1'))
		graph export graphs\graph_`outcome'_`quality'_risk-dad.png, replace
	}
	else { // Do nothing
		//display "FALSE: `pval1' AND `pval2' AND `pval4'"
	}
	if(`pval2' < 0.1) {
		quietly margins, at(`quality'=(1(1)5) F_pos_dad=(1(1)6)) atmeans
		marginsplot, noci ytitle(Plot for `outcome' (p = `pval2'))
		graph export graphs\graph_`outcome'_`quality'_pos-dad.png, replace
	}
	else { // Do nothing
		//display "FALSE: `pval1' AND `pval2' AND `pval4'"
	}
	if(`pval3' < 0.1) {
		quietly margins, at(`quality'=(1(1)5) F_phys_dad=(1(1)6)) atmeans
		marginsplot, noci ytitle(Plot for `outcome' (p = `pval3'))
		graph export graphs\graph_`outcome'_`quality'_phys-dad.png, replace
	}
	else { // Do nothing
		//display "FALSE: `pval1' AND `pval2' AND `pval4'"
	}
	
	drop sample_* inter*
	//drop inter*
}
}
