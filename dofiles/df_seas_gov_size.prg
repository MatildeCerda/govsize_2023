'Opens a workfile
wfcreate(wf=eviews_gov_size) q 2006.1 2021.4

'Read data from csv created in Rstudio
import "C:\Users\Axel Canales\Documents\GitHub\govsize_2023\dofiles\df_seas.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @freq Q @id @date(date) @destid @date @smpl @all

'dummy variables
series d_2008 = @recode(@date<@dateval("2008q3") or @date>@dateval("2009q1"),1,0)

series d_2018= @recode(@date>@dateval("2018q2"),1,0)

'Rename variables

rename GOV_GDP_S x1_sa
rename PRIV_INV_GDP_S x2_sa
rename TR_OP_S x3_sa

'============ Unit Root test ============
'ADF
'diferencias	

freeze(adftable_dif_log_gdp_pc_s_c) log_gdp_pc_s.uroot(dif=1)
freeze(adftable_dif_log_gdp_pc_s_ct) log_gdp_pc_s.uroot(exog=trend, dif=1)
freeze(adftable_dif_log_gdp_pc_s_nc) log_gdp_pc_s.uroot(exog=none, dif=1)

freeze(adftable_dif_pub_inv_gdp_s_c) pub_inv_gdp_s.uroot(dif=1)
freeze(adftable_dif_pub_inv_gdp_s_ct) pub_inv_gdp_s.uroot(exog=trend, dif=1)
freeze(adftable_dif_lpub_inv_gdp_s_nc) pub_inv_gdp_s.uroot(exog=none, dif=1)

for !i=1 to 3
freeze(adftable_dif_{!i}_c) x{!i}_sa.uroot(dif=1)
freeze(adftable_dif_{!i}_ct) x{!i}_sa.uroot(exog=trend, dif=1)
freeze(adftable_dif_{!i}_nc) x{!i}_sa.uroot(exog=none, dif=1)

next

'Niveles

freeze(adftable_log_gdp_pc_s_c) log_gdp_pc_s.uroot
freeze(adftable_log_gdp_pc_s_ct) log_gdp_pc_s.uroot(exog=trend)
freeze(adftable_log_gdp_pc_s_nc) log_gdp_pc_s.uroot(exog=none)

freeze(adftable_pub_inv_gdp_s_c) pub_inv_gdp_s.uroot
freeze(adftable_pub_inv_gdp_s_ct) pub_inv_gdp_s.uroot(exog=trend)
freeze(adftable_lpub_inv_gdp_s_nc) pub_inv_gdp_s.uroot(exog=none)

for !i=1 to 3
freeze(adftable_{!i}_c) x{!i}_sa.uroot
freeze(adftable_{!i}_ct) x{!i}_sa.uroot(exog=trend)
freeze(adftable_{!i}_nc) x{!i}_sa.uroot(exog=none)

next

'Phillips-perron 
'Niveles

freeze(pptable_log_gdp_pc_s_c) log_gdp_pc_s.uroot(pp)
freeze(pptable_log_gdp_pc_s_ct) log_gdp_pc_s.uroot(exog=trend, pp)
freeze(pptable_log_gdp_pc_s_nc) log_gdp_pc_s.uroot(exog=none, pp)

freeze(pptable_pub_inv_gdpc_s_c) pub_inv_gdp_s.uroot(pp)
freeze(pptable_pub_inv_gdp_s_ct) pub_inv_gdp_s.uroot(exog=trend, pp)
freeze(pptable_pub_inv_gdp_s_nc) pub_inv_gdp_s.uroot(exog=none, pp)

for !i=1 to 3
freeze(pptable{!i}_c) x{!i}_sa.uroot(pp)
freeze(pptable{!i}_ct) x{!i}_sa.uroot(exog=trend, pp)
freeze(pptable{!i}_nc) x{!i}_sa.uroot(exog=none, pp)

next

'Diferencias
freeze(pptable_dif_log_gdp_pc_s_c) log_gdp_pc_s.uroot(dif=1, pp)
freeze(pptable_dif_log_gdp_pc_s_ct) log_gdp_pc_s.uroot(exog=trend, dif=1, pp)
freeze(pptable_dif_log_gdp_pc_s_nc) log_gdp_pc_s.uroot(exog=none,dif=1, pp)

freeze(pptable_dif_pub_inv_gdpc_s_c) pub_inv_gdp_s.uroot(dif=1,pp)
freeze(pptable_dif_pub_inv_gdp_s_ct) pub_inv_gdp_s.uroot(exog=trend, dif=1, pp)
freeze(pptable_dif_pub_inv_gdp_s_nc) pub_inv_gdp_s.uroot(exog=none, dif=1, pp)

for !i=1 to 3
freeze(pptable_dif_{!i}_c) x{!i}_sa.uroot(dif=1, pp)
freeze(pptable_dif_{!i}_ct) x{!i}_sa.uroot(exog=trend, dif=1, pp)
freeze(pptable_dif_{!i}_nc) x{!i}_sa.uroot(exog=none, dif=1, pp)

next

'===========================
'Long Rung models
'===========================

'------------------------------------------------------------------------------------------------------------------------------
'Variable independiente del gobierno: Gasto de Gobierno Agregado
'------------------------------------------------------------------------------------------------------------------------------

'Modelos lineales con todas las metodologias en muestra completa
'OLS:
smpl @all
equation eql1.ls log_gdp_pc_s c x1_sa x2_sa x3_sa d_2008 d_2018

'FMOLS:
smpl @all
equation eql2.cointreg log_gdp_pc_s x1_sa  x2_sa x3_sa @determ d_2008 d_2018

'CCR
smpl @all
equation eql3.cointreg(method=ccr) log_gdp_pc_s x1_sa x2_sa x3_sa @determ d_2008 d_2018

'Modelos lineales con todas las metodologias en muestra recortada

smpl 2006Q1 2017Q4
equation eql4.ls log_gdp_pc_s c x1_sa x2_sa x3_sa d_2008

smpl 2006Q1 2017Q4
equation eql5.cointreg log_gdp_pc_s x1_sa  x2_sa x3_sa @determ d_2008 

smpl 2006Q1 2017Q4
equation eql6.cointreg(method=ccr) log_gdp_pc_s x1_sa  x2_sa x3_sa @determ d_2008 

'Modelos cuadr�ticos con todas las metodologias en muestra completa

smpl @all
equation eq1.ls log_gdp_pc_s c x1_sa (x1_sa)^2 x2_sa x3_sa d_2008 d_2018


smpl @all
equation eq2.cointreg log_gdp_pc_s x1_sa (x1_sa)^2 x2_sa x3_sa @determ d_2008 d_2018

smpl @all
equation eq3.cointreg(method=ccr) log_gdp_pc_s x1_sa (x1_sa)^2 x2_sa x3_sa @determ d_2008 d_2018

'Modelos cuadr�ticos con todas las metodologias en muestra recortada

smpl 2006Q1 2017Q4
equation eq4.ls log_gdp_pc_s c x1_sa (x1_sa)^2 x2_sa x3_sa d_2008

smpl 2006Q1 2017Q4
equation eq5.cointreg log_gdp_pc_s x1_sa (x1_sa)^2 x2_sa x3_sa @determ d_2008 

smpl 2006Q1 2017Q4
equation eq6.cointreg(method=ccr) log_gdp_pc_s x1_sa (x1_sa)^2 x2_sa x3_sa @determ d_2008 

'Modelos c�bicos con todas las metodologias en muestra completa
smpl @all
equation eq7.ls log_gdp_pc_s c x1_sa (x1_sa)^2 (x1_sa)^3 x2_sa x3_sa d_2008 d_2018

smpl @all
equation eq8.cointreg log_gdp_pc_s x1_sa (x1_sa)^2 (x1_sa)^3 x2_sa x3_sa @determ d_2008 d_2018

smpl @all
equation eq9.cointreg(method=ccr) log_gdp_pc_s  x1_sa (x1_sa)^2 (x1_sa)^3 x2_sa x3_sa @determ d_2008 d_2018

'Modelos c�bicos con todas las metodologias en muestra recortada

smpl 2006Q1 2017Q4
equation eq10.ls log_gdp_pc_s c x1_sa (x1_sa)^2 (x1_sa)^3 x2_sa x3_sa d_2008

smpl 2006Q1 2017Q4
equation eq11.cointreg log_gdp_pc_s  x1_sa (x1_sa)^2 (x1_sa)^3 x2_sa x3_sa @determ d_2008

smpl 2006Q1 2017Q4
equation eq12.cointreg(method=ccr) log_gdp_pc_s  x1_sa (x1_sa)^2 (x1_sa)^3 x2_sa x3_sa @determ d_2008 

'------------------------------------------------------------------------------------------------------------------------------
'Variable independiente del gobierno: Inversion fija p�blica
'------------------------------------------------------------------------------------------------------------------------------

'Modelos lineales  con todas las metodologias en muestra completa

smpl @all
equation eql19.ls log_gdp_pc_s c PUB_INV_GDP_S   x2_sa x3_sa d_2008 d_2018


smpl @all
equation eql20.cointreg log_gdp_pc_s PUB_INV_GDP_S   x2_sa x3_sa @determ d_2008 d_2018

smpl @all
equation eql21.cointreg(method=ccr) log_gdp_pc_s PUB_INV_GDP_S  x2_sa x3_sa @determ d_2008 d_2018

'Variable independiente del gobierno: Inversion fija p�blica

'Modelos lineales  con todas las metodologias en muestra recortada

smpl 2006Q1 2017Q4
equation eql22.ls log_gdp_pc_s c PUB_INV_GDP_S   x2_sa x3_sa d_2008

smpl 2006Q1 2017Q4
equation eql23.cointreg log_gdp_pc_s PUB_INV_GDP_S   x2_sa x3_sa @determ d_2008 

smpl 2006Q1 2017Q4
equation eql24.cointreg(method=ccr) log_gdp_pc_s PUB_INV_GDP_S   x2_sa x3_sa @determ d_2008 


'Modelos cuadr�ticos con todas las metodologias en muestra completa

smpl @all
equation eq19.ls log_gdp_pc_s c PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 x2_sa x3_sa d_2008 d_2018

smpl @all
equation eq20.cointreg log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 x2_sa x3_sa @determ d_2008 d_2018

smpl @all
equation eq21.cointreg(method=ccr) log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 x2_sa x3_sa @determ d_2008 d_2018

'Modelos cuadr�ticos con todas las metodologias en muestra recortada

smpl 2006Q1 2017Q4
equation eq22.ls log_gdp_pc_s c PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 x2_sa x3_sa d_2008

smpl 2006Q1 2017Q4
equation eq23.cointreg log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 x2_sa x3_sa @determ d_2008 

smpl 2006Q1 2017Q4
equation eq24.cointreg(method=ccr) log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 x2_sa x3_sa @determ d_2008 

'Modelos c�bicos con todas las metodologias en muestra completa

smpl @all
equation eq25.ls log_gdp_pc_s c PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 (PUB_INV_GDP_S )^3 x2_sa x3_sa d_2008 d_2018

smpl @all
equation eq26.cointreg log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 (PUB_INV_GDP_S )^3 x2_sa x3_sa @determ d_2008 d_2018

smpl @all
equation eq27.cointreg(method=ccr) log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 (PUB_INV_GDP_S )^3 x2_sa x3_sa @determ d_2008 d_2018

'Modelos c�bicos con todas las metodologias en muestra recortada

smpl 2006Q1 2017Q4
equation eq28.ls log_gdp_pc_s c PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 (PUB_INV_GDP_S )^3 x2_sa x3_sa d_2008

smpl 2006Q1 2017Q4
equation eq29.cointreg log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 (PUB_INV_GDP_S )^3 x2_sa x3_sa @determ d_2008

smpl 2006Q1 2017Q4
equation eq30.cointreg(method=ccr) log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 (PUB_INV_GDP_S )^3 x2_sa x3_sa @determ d_2008 


'--------------------------------------------------------------------------------------------------------
'Variable independiente del gobierno:Consumo publico
'--------------------------------------------------------------------------------------------------------

'Modelos lineales con todas las metodologias en muestra completa

'smpl @all
'equation eql37.ls log_gdp_pc_s c rgob_sa  x2_sa x3_sa d_2008 d_2018


'smpl @all
'equation eql38.cointreg log_gdp_pc_s rgob_sa  x2_sa x3_sa @determ d_2008 d_2018

'smpl @all
'equation eql39.cointreg(method=ccr) log_gdp_pc_s rgob_sa  x2_sa x3_sa @determ d_2008 d_2018

'Modelos lineales con todas las metodologias en muestra recortada

'smpl 2006Q1 2017Q4
'equation eql40.ls log_gdp_pc_s c rgob_sa  x2_sa x3_sa d_2008

'smpl 2006Q1 2017Q4
'equation eql41.cointreg log_gdp_pc_s rgob_sa  x2_sa x3_sa @determ d_2008 

'smpl 2006Q1 2017Q4
'equation eql42.cointreg(method=ccr) log_gdp_pc_s rgob_sa  x2_sa x3_sa @determ d_2008

'Modelos cuadr�ticos con todas las metodologias en muestra completa

'smpl @all
'equation eq37.ls log_gdp_pc_s c rgob_sa (rgob_sa)^2 x2_sa x3_sa d_2008 d_2018

'smpl @all
'equation eq38.cointreg log_gdp_pc_s rgob_sa (rgob_sa)^2 x2_sa x3_sa @determ d_2008 d_2018

'smpl @all
'equation eq39.cointreg(method=ccr) log_gdp_pc_s rgob_sa (rgob_sa)^2 x2_sa x3_sa @determ d_2008 d_2018

'Modelos cuadr�ticos con todas las metodologias en muestra recortada

'smpl 2006Q1 2017Q4
'equation eq40.ls log_gdp_pc_s c rgob_sa (rgob_sa)^2 x2_sa x3_sa d_2008

'smpl 2006Q1 2017Q4
'equation eq41.cointreg log_gdp_pc_s rgob_sa (rgob_sa)^2 x2_sa x3_sa @determ d_2008 

'smpl 2006Q1 2017Q4
'equation eq42.cointreg(method=ccr) log_gdp_pc_s rgob_sa (rgob_sa)^2 x2_sa x3_sa @determ d_2008

'Modelos c�bicos con todas las metodologias en muestra completa

'smpl @all
'equation eq42.ls log_gdp_pc_s c rgob_sa (rgob_sa)^2 (rgob_sa)^3 x2_sa x3_sa d_2008 d_2018
'
'smpl @all
'equation eq43.cointreg log_gdp_pc_s rgob_sa (rgob_sa)^2 (rgob_sa)^3 x2_sa x3_sa @determ d_2008 d_2018

'smpl @all
'equation eq44.cointreg(method=ccr) log_gdp_pc_s  rgob_sa (rgob_sa)^2 (rgob_sa)^3 x2_sa x3_sa @determ d_2008 d_2018

'Modelos c�bicos con todas las metodologias en muestra recortada
'smpl 2006Q1 2017Q4
'equation eq45.ls log_gdp_pc_s c rgob_sa (rgob_sa)^2 (rgob_sa)^3 x2_sa x3_sa d_2008

'smpl 2006Q1 2017Q4
'equation eq46.cointreg log_gdp_pc_s  rgob_sa (rgob_sa)^2 (rgob_sa)^3 x2_sa x3_sa @determ d_2008

'smpl 2006Q1 2017Q4
'equation eq47.cointreg(method=ccr) log_gdp_pc_s rgob_sa (rgob_sa)^2 (rgob_sa)^3 x2_sa x3_sa @determ d_2008 


'=============================
'Bootstrap
'=============================
'Gasto agregado

for !x=1 to 30
if !x<13 then
smpl @first+{!x} @last
equation reg_agregado{!x}.COINTREG log_gdp_pc_s X1_SA (X1_SA)^2 X2_SA X3_SA @DETERM D_2008 D_2018
else
smpl @first+{!x} @last
equation reg_agregado{!x}.COINTREG log_gdp_pc_s X1_SA (X1_SA)^2 X2_SA X3_SA @DETERM D_2018
endif

next

for !x=1 to 30
table(30,1) lineales_agregado
table(30,1) cuadraticos_agregado
lineales_agregado({!x},1) = reg_agregado{!x}.@coef(1)
cuadraticos_agregado({!x},1) = reg_agregado{!x}.@coef(2)
next

'inversion Fija publica

for !x=1 to 30
if !x<13 then

smpl @first+{!x} @last
equation reg_inversion{!x}.COINTREG log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 X2_SA X3_SA @DETERM D_2008 D_2018
else
smpl @first+{!x} @last
equation reg_inversion{!x}.COINTREG log_gdp_pc_s PUB_INV_GDP_S  (PUB_INV_GDP_S )^2 X2_SA X3_SA @DETERM D_2018
endif
next

for !x=1 to 30
table(30,1) lineales_inversion
table(30,1) cuadraticos_inversion
lineales_inversion({!x},1) = reg_inversion{!x}.@coef(1)
cuadraticos_inversion({!x},1) = reg_inversion{!x}.@coef(2)
next

'Exportando coeficientes
lineales_agregado.save(t=csv) "C:\Users\Axel Canales\Documents\GitHub\govsize_2023\dofiles\lineales_agregado.csv"
cuadraticos_agregado.save(t=csv) "C:\Users\Axel Canales\Documents\GitHub\govsize_2023\dofiles\cuadraticos_agregado.csv"


