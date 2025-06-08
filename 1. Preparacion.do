***** 1) Preparación de base *****
*# Comienzo procesamiento #1

clear
local cd "..." /// Completar con directorio
cd "`cd'"
capture mkdir "`cd'/Resultados"

**** Guardo la BD como "eder2019_usuarios_retro_08.022"

import delimited "`cd'/Datos/eder2019_usuarios_retro_hijo.txt", clear
capture run "`cd'/0. Labels.do"

sort id nhogar miembro
tempfile temp1
save `temp1'

**** Hago el merge con la base hijes_retro (vars id/nhogar/miembro + hijo) 

import delimited "`cd'/Datos/eder2019_usuarios_ retro.txt", clear
capture run "`cd'/0. Labels.do"

sort id nhogar miembro
merge 1:m id nhogar miembro annio_retro using `temp1'

***** 2) Creación de variables *****

**# Variables de eventos

* HijoN
* vars: p1_hije acuhije p_hije p1_hije2 hijo2 (variables intermedias)
* guarda que al volver a correr noto que borré una variable de más la p10_2b, en todo caso volver a la BD que tiene todo el merge. 

* Primero creamos la variable que nos marca uno cada vez que tiene un hije

gen p1_hijo=0 
replace p1_hijo=1 if annio_retro==p10_2b & id==id[_n-1]
* Creamos la variable que nos marca el año anterior a tener un hije
gen p1_hijo_ant=0
replace p1_hijo_ant = 1 if annio_retro==p10_2b-1 & id==id[_n-1]
* Creamos la variable que nos marca el año posterior a tener un hije
gen p1_hijo_post=0
replace p1_hijo_post = 1 if annio_retro==p10_2b+1 & id==id[_n-1]

* Luego creamos una variable que nos va a acumular la cantidad de hijes para cada id (o folio) (variable cambiante de acumulaciÛn de cambios)
sort id annio_retro p10_2b
bys id: gen acuhijo= sum(p1_hijo)
bys id: gen acuhijoant= sum(p1_hijo_ant)
bys id: gen acuhijopost= sum(p1_hijo_post) 
  
*Quito datos por hijo. Solo un dato por año del entrevistado
bys id annio_retro: keep if _n==1
bys id: egen cant_hijo = max(acuhijo)
gen mapadre = 0
replace mapadre = 1 if cant_hijo > 0

* Nacimiento del hijo *
forval x = 1/10 {
	gen hijo_`x' = 0 
	replace hijo_`x' = 1 if acuhijo==`x' & acuhijo[_n-1]==(`x'-1)
	
	gen hijo_`x'_ant = 0
	replace hijo_`x'_ant = 1 if acuhijoant==`x' & acuhijoant[_n-1]==(`x'-1)
	
	gen hijo_`x'_post = 0
	replace hijo_`x'_post = 1 if acuhijopost==`x' & acuhijopost[_n-1]==(`x'-1)
}

**# Variables objetivo ****
**** EMPLEO: _y (movil y fija) _c _d _t
* Situación al año de hijo N *
*reemplazar el 5 por el maximo de hijos*
local max_hijos 5

forval x = 1/`max_hijos' {
	
	* Situación laboral al momento del hijo x *
	gen ocupado_hijo_`x'  = .
	replace ocupado_hijo_`x' = 0 if hijo_`x' == 1 & p5_2 == 0 // Desocupados/inactivo
	replace ocupado_hijo_`x' = 1 if hijo_`x' == 1 & (p5_2 == 1 | p5_2 == 2) // Ocupados
	gen edad_ocupado_hijo_`x' = edad_retro if ocupado_hijo_`x' != .
	
	bys id: egen ocupado_hijo_`x'_prov = max(ocupado_hijo_`x')
	drop ocupado_hijo_`x'
	rename ocupado_hijo_`x'_prov ocupado_hijo_`x'
	bys id: egen edad_ocupado_hijo_`x'_prov = max(edad_ocupado_hijo_`x')
	drop edad_ocupado_hijo_`x'
	rename edad_ocupado_hijo_`x'_prov edad_ocupado_hijo_`x'
	
	* Situación de formalidad al momento del hijo x *
	gen asalformal_hijo_`x' = . 
	replace asalformal_hijo_`x' = 0 if hijo_`x' == 1 & (p5_2 == 1 | p5_2 == 2) & (p5_9 == 3 | p5_9 == 9)
	replace asalformal_hijo_`x' = 1 if hijo_`x' == 1 & (p5_2 == 1 | p5_2 == 2) & (p5_9 == 1 | p5_9 == 2)  	
	
	bys id: egen asalformal_hijo_`x'_prov = max(asalformal_hijo_`x')
	drop asalformal_hijo_`x'
	rename asalformal_hijo_`x'_prov asalformal_hijo_`x'	
	
	** Nivel educativo**
	
	* Posición de hijo_1
	bysort id (edad_retro): gen hijo_`x'_posicion = _n if hijo_`x' == 1
	* Posición de hijo_1 a todas las filas 
	bysort id: egen hijo_`x'_pos = max(hijo_`x'_posicion)
	* Identifico el valor máximo de p4_2 antes de hijo_1 y su correspondiente valor de p4_5
	bysort id (edad_retro): egen max_p4_2_pre_hijo`x' = max(p4_2) if edad_retro < hijo_`x'_pos
	bysort id (edad_retro): gen p4_5_pre_hijo`x' = p4_5 if max_p4_2_pre_hijo`x' == p4_2
	bysort id (edad_retro): egen max_p4_5_pre_hijo`x' = max(p4_5_pre_hijo`x')

	gen niveled_hijo`x' = .
	replace niveled_hijo`x' = 0 if acuhijo > 0
	replace niveled_hijo`x' = 1 if hijo_`x' == 1   // Sin secundario completo
	replace niveled_hijo`x' = 2 if hijo_`x' == 1 & ((inrange(max_p4_2_pre_hijo`x',5,6) & max_p4_5_pre_hijo`x' == 2) | (max_p4_2_pre_hijo`x' == 4 & max_p4_5_pre_hijo`x' == 1))    // Secundario completo
	replace niveled_hijo`x' = 3 if hijo_`x' == 1 & (inrange(max_p4_2_pre_hijo`x', 5, 7) & max_p4_5_pre_hijo`x' == 1) | (max_p4_2_pre_hijo`x' == 7 & max_p4_5_pre_hijo`x' == 2)   // Superior completo o mas
	bys id: egen niveled_hijo`x'_prov = max(niveled_hijo`x')
	drop niveled_hijo`x'
	rename niveled_hijo`x'_prov niveled_hijo`x'
	
	gen anio_hijo`x' = . 
	replace anio_hijo`x' = 0 if acuhijo > 0
	replace anio_hijo`x' = annio_retro if hijo_`x' == 1
	bys id: egen anio_hijo`x'_prov = max(anio_hijo`x')
	drop anio_hijo`x'
	rename anio_hijo`x'_prov anio_hijo`x'	
		
	gen caba_hijo`x'= .
	replace caba_hijo`x'= 0 if acuhijo > 0
	replace caba_hijo`x' = 1 if  hijo_`x' == 1 & p2_3 ==1 
	bys id: egen caba_hijo`x'_prov = max(caba_hijo`x')
	drop caba_hijo`x'
	rename caba_hijo`x'_prov caba_hijo`x'	
	
}

local anios 5
noi forval x = 1/`anios' {
	noi forval y = 1/`max_hijos' { 
		* Ocupados cuando hijoY
		gen ocu_ocu_hijo_`y'_a`x' = . // Ocupado a ocupado x años despues de hijoY
		replace ocu_ocu_hijo_`y'_a`x' = 0 if acuhijo > 0
		replace ocu_ocu_hijo_`y'_a`x' = 1 if ocupado_hijo_`y' == 1 & (edad_retro == edad_ocupado_hijo_`y'+`x' & (p5_2 == 1 | p5_2 == 2))
		
		* No ocupados cuando hijoY
		gen noocu_ocu_hijo_`y'_a`x' = . // No ocupado a ocupado x años despues de hijoY
		replace noocu_ocu_hijo_`y'_a`x' = 0 if acuhijo > 0
		replace noocu_ocu_hijo_`y'_a`x' = 1 if ocupado_hijo_`y' == 0 & (edad_retro == edad_ocupado_hijo_`y'+`x' & (p5_2 == 1 | p5_2 == 2))	
		
		* Asalariados formales cuando hijoY
		
		gen asalformal_af_hijo_`y'_a`x' = .
		replace asalformal_af_hijo_`y'_a`x' = 0 if acuhijo > 0 & ocupado_hijo_`y' == 1
		replace asalformal_af_hijo_`y'_a`x' = 1 if asalformal_hijo_`y' == 1 & (edad_retro == edad_ocupado_hijo_`y'+`x' & (p5_2 == 1 | p5_2 == 2) & p5_9 == 1)
		
		* Asalariados informales cuando hijoY
		gen asalinf_af_hijo_`y'_a`x' = .
		replace asalinf_af_hijo_`y'_a`x' = 0 if acuhijo > 0 & ocupado_hijo_`y' == 1
		replace asalinf_af_hijo_`y'_a`x' = 1 if asalformal_hijo_`y' == 0 & (edad_retro == edad_ocupado_hijo_`y'+`x' & (p5_2 == 1 | p5_2 == 2) & p5_9 == 1)
		
	}
}

foreach var of varlist ocu_ocu_hijo_1_a1-asalinf_af_hijo_`max_hijos'_a`anios'{
	* Extiendo dato de evento a todos los años *
	bys id: egen `var'_prov = max(`var')
	drop `var'
	rename `var'_prov `var'	
}

** Situacion laboral el año anterior **

forval x = 1/`max_hijos' {
	
	* Situación laboral al momento del hijo x *
	gen ocupado_hijo_`x'_ant  = .
	replace ocupado_hijo_`x'_ant = 0 if hijo_`x'_ant == 1 & p5_2 == 0 // Desocupados/inactivo
	replace ocupado_hijo_`x'_ant = 1 if hijo_`x'_ant == 1 & (p5_2 == 1 | p5_2 == 2) // Ocupados
	gen edad_ocupado_hijo_`x'_ant = edad_retro if ocupado_hijo_`x'_ant != .
	
	bys id: egen ocupado_hijo_`x'_prov_ant = max(ocupado_hijo_`x'_ant)
	drop ocupado_hijo_`x'_ant
	rename ocupado_hijo_`x'_prov_ant ocupado_hijo_`x'_ant
	bys id: egen edad_ocupado_hijo_`x'_prov_ant = max(edad_ocupado_hijo_`x'_ant)
	drop edad_ocupado_hijo_`x'_ant
	rename edad_ocupado_hijo_`x'_prov_ant edad_ocupado_hijo_`x'_ant
	
	* Situación de formalidad al momento del hijo x *
	gen asalformal_hijo_`x'_ant = . 
	replace asalformal_hijo_`x'_ant = 0 if hijo_`x'_ant == 1 & (p5_2 == 1 | p5_2 == 2) & (p5_9 == 3 | p5_9 == 9)
	replace asalformal_hijo_`x'_ant = 1 if hijo_`x'_ant == 1 & (p5_2 == 1 | p5_2 == 2) & (p5_9 == 1 | p5_9 == 2)  	
	bys id: egen asalformal_hijo_`x'_prov_ant = max(asalformal_hijo_`x'_ant)
	drop asalformal_hijo_`x'_ant
	rename asalformal_hijo_`x'_prov_ant asalformal_hijo_`x'_ant
}

*** Para año anterior en laborales ***
local anios 6
noi forval x = 1/`anios' {
	noi forval y = 1/`max_hijos' { 
		* Ocupados cuando hijoY
		gen ocu_ocu_hijo_`y'_a`x'_ant = . // Ocupado a ocupado x años despues de hijoY
		replace ocu_ocu_hijo_`y'_a`x'_ant = 0 if acuhijoant > 0
		replace ocu_ocu_hijo_`y'_a`x'_ant = 1 if ocupado_hijo_`y'_ant == 1 & (edad_retro == edad_ocupado_hijo_`y'_ant +`x' & (p5_2 == 1 | p5_2 == 2))
		
		* No ocupados cuando hijoY
		gen noocu_ocu_hijo_`y'_a`x'_ant = . // No ocupado a ocupado x años despues de hijoY
		replace noocu_ocu_hijo_`y'_a`x'_ant = 0 if acuhijoant > 0
		replace noocu_ocu_hijo_`y'_a`x'_ant = 1 if ocupado_hijo_`y'_ant == 0 & (edad_retro == edad_ocupado_hijo_`y'_ant +`x' & (p5_2 == 1 | p5_2 == 2))	
		
		* Asalariados formales cuando hijoY
		
		gen asalformal_af_hijo_`y'_a`x'_ant = .
		replace asalformal_af_hijo_`y'_a`x'_ant = 0 if acuhijoant > 0 & ocupado_hijo_`y'_ant == 1
		replace asalformal_af_hijo_`y'_a`x'_ant = 1 if asalformal_hijo_`y'_ant == 1 & (edad_retro == edad_ocupado_hijo_`y'_ant+`x' & (p5_2 == 1 | p5_2 == 2) & p5_9 == 1)
		
		* Asalariados informales cuando hijoY
		gen asalinf_af_hijo_`y'_a`x'_ant = .
		replace asalinf_af_hijo_`y'_a`x'_ant = 0 if acuhijoant > 0 & ocupado_hijo_`y'_ant == 1
		replace asalinf_af_hijo_`y'_a`x'_ant = 1 if asalformal_hijo_`y'_ant == 0 & (edad_retro == edad_ocupado_hijo_`y'_ant +`x' & (p5_2 == 1 | p5_2 == 2) & p5_9 == 1)
	}
}

* Año posterior (para descriptiva)

forval x = 1/`max_hijos' {
	
	* Situación laboral al momento del hijo x *
	gen ocupado_hijo_`x'_post  = .
	replace ocupado_hijo_`x'_post = 0 if hijo_`x'_post == 1 & p5_2 == 0 // Desocupados/inactivo
	replace ocupado_hijo_`x'_post = 1 if hijo_`x'_post == 1 & (p5_2 == 1 | p5_2 == 2) // Ocupados
	gen edad_ocupado_hijo_`x'_post = edad_retro if ocupado_hijo_`x'_post != .
	
	bys id: egen ocupado_hijo_`x'_prov_post = max(ocupado_hijo_`x'_post)
	drop ocupado_hijo_`x'_post
	rename ocupado_hijo_`x'_prov_post ocupado_hijo_`x'_post
	bys id: egen edad_ocupado_hijo_`x'_prov_post = max(edad_ocupado_hijo_`x'_post)
	drop edad_ocupado_hijo_`x'_post
	rename edad_ocupado_hijo_`x'_prov_post edad_ocupado_hijo_`x'_post
}


foreach var of varlist ocu_ocu_hijo_1_a1_ant-asalinf_af_hijo_`max_hijos'_a`anios'_ant {
	* Extiendo dato de evento a todos los años *
	bys id: egen `var'_prov = max(`var')
	drop `var'
	rename `var'_prov `var'
}

drop if cohorte==.
* Variable de contexto: Género (proxy sexo)
* p2 (sexo 1=varon; 2=mujer)
gen mujer = 0
replace mujer = 1 if p2== 2

save "`cd'/base_regresiones", replace

