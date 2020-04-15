// Data importing
import delimited "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\C4MEMBERBAYES_STATA.csv", delimiter(comma) clear
save "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\4-class-bayes.dta"
use "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\Data-3Step-4class.dta"
drop _merge
merge 1:1 id using "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\4-class-bayes.dta"

/************************************
Models for Females
*************************************/
// Perform Regression for Sexual Ethic (i.e., willingness to engage in casual sex)
reg c_ethic TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 1
// Create Moderation Graph
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Ethic (low is more casual)) name(ethic_peer_girl)
// Check Simple Slopes
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
// Test differences between slopes for all combinations
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Ethic (low is more casual)) name(ethic_media_girl)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))
//test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i3.class4#c.TV_Sex

// Run regression for Sexual Risk
reg risk TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 1
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(risk_peer_girl)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(risk_media_girl)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex

// Run Regression model for age at first sexual intercourse
reg debut TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 1
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(debut_peer_girl)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(debut_media_girl)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex

zinb C_SexLifetime_TEXT TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 1, inflate(C_SexBehav) zip
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Partners) name(lifetime_peer_girl)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Partners) name(lifetime_media_girl)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))

test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex

/****************************************
Regression models for Males
*****************************************/
// Regression model for Sexual Ethic
reg c_ethic TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 0
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Ethic (low is more casual)) name(ethic_peer_boy)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Ethic (low is more casual)) name(ethic_media_boy)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
//test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex

// Regression model for Sexual Risk
reg risk TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 0
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(risk_peer_boy)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(risk_media_boy)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex

// Regression model for age at first sexual intercourse
reg debut TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 0
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(debut_peer_boy)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Risk) name(debut_media_boy)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))
//test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
//test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
//test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
//test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex


zinb C_SexLifetime_TEXT TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 0, inflate(C_SexBehav) zip
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Partners) name(lifetime_peer_boy)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
quietly margins, at (TV_Sex=(1(1)5) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Partners) name(lifetime_media_boy)
margins, dydx(TV_Sex) at(class4bayes=(1(1)4))

test i2.class4bayes#c.C_Peer = i3.class4bayes#c.C_Peer
test i2.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i3.class4bayes#c.C_Peer = i4.class4bayes#c.C_Peer
test i2.class4bayes#c.TV_Sex = i3.class4bayes#c.TV_Sex
test i2.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex
test i3.class4bayes#c.TV_Sex = i4.class4bayes#c.TV_Sex




