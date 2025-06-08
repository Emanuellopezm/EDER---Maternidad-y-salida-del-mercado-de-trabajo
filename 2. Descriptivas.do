***** 2) Descriptivos *****
*# Comienzo procesamiento #1

clear
local cd "..." /// Completar con directorio
cd "`cd'"

**** Guardo la BD como "eder2019_usuar
use "`cd'/base_regresiones", clear

******************* Descriptivos *****************

* Cantidad Hombre y Mujeres *

tab mujer cohorte if edad_retro==0, col

* Cantidad Madres y Padres *
bys cohorte: tab mujer mapadre if edad_retro==0, row

* Cantidad promedio de hijos *
bys cohorte: summ cant_hijo if edad_retro==0

* Cantidad promedio de hijos a los 37 años*

preserve
keep if edad_retro == 37
bys cohorte: summ acuhijo
restore

* Edad promedio al primer hijo *

bys cohorte: summ edad_retro if hijo_1 == 1

* Situación laboral el año previo, año de nacimiento y posteriores*

forval y = 1/3 {
	bys cohorte: tab mujer ocupado_hijo_`y'_ant if hijo_`y'_ant == 1, row	 
	bys cohorte: tab mujer ocupado_hijo_`y' if hijo_`y' == 1, row	 
	bys cohorte: tab mujer ocupado_hijo_`y'_post if hijo_`y' == 1, row	 
}


