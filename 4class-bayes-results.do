// Data importing
import delimited "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\C4MEMBERBAYES_STATA.csv", delimiter(comma) clear
save "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\4-class-bayes.dta"
use "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\Data-3Step-4class.dta"
drop _merge
merge 1:1 id using "C:\Users\rdmclean\Box\Ryan and Laura\Peers, Media, and Parent Predictors of Adolescent Sexuality\Mixture-Models\4-class-bayes.dta"


/****************************************
Summary for FEMALES
c_ethic
	c_peer
		all slopes significant
		2 is almost different from 1 (.066)
		2 is almost different from 4 (.0765)
	TV_SEX 
		all but slope 3 significant
		2 is almost different from 4 (0.095)
risk	
	peer
		all but slope 4 significant
	media
		no direct effects
debut
	peer
		slope 3 is the only one that approaches significance (.079)
	media
		no direct effects
*****************************************/
reg c_ethic TV_Freq class4bayes##c.C_Peer class4bayes##c.TV_Sex [pw = c_prob_bayes] if C_Sex == 1
quietly margins, at (C_Peer=(-2(0.5)2) class4bayes=(1(1)4)) atmeans
marginsplot, noci ytitle(Plot for Sexual Ethic (low is more casual)) name(ethic_peer_girl)
margins, dydx(C_Peer) at(class4bayes=(1(1)4))
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
Summary for MALES
c_ethic
	c_peer
		all slopes significant
		4 is different from 1 (.014)
		2 is different from 4 (.0154)
	TV_SEX 
		slope 2 is significant, but none of the others
		2 is significantly different from 1 (.037)
risk
	peer
		all slopes significant
		3 is almost different from 4 (0.0796)
	tv_sex
		only slope 3 approaches significance (.058)
		3 is different from 1 (.027)
		2 is almost different from 3 (0.0911)
debut
	peer
		no direct effects
	tv_sex	
		only slope 3 is significant ( < .001)
		3 is different from 1 (.001)
		3 is different from 2 (.0001)
		3 is different from 4 (.0007)
*****************************************/
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

//reg debut TV_Freq class4bayes C_Peer i.class4bayes TV_Sex if C_Sex == 0
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




