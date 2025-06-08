***** 1) Preparación de base *****
*# Comienzo procesamiento #1

clear
local cd "..." /// Completar con directorio
cd "`cd'"

use "`cd'/base_regresiones", clear

*********** Anio anterior *****

local anios 5
local max_hijos 3
local acumtab // orden de procesamiento 
local variables ocu_ocu noocu_ocu

forval c = 1/3 { 
noi foreach vars in `variables' {
	if substr("`vars'",1,3) == "ocu" {
		local cond 1
	}
	else {
		local cond 0
	}
	
	qui forval y = 1/`max_hijos' { 
		qui forval x = 1/`anios' {			
			preserve
			drop if niveled_hijo`y' == 0
			local controles i.niveled_hijo`y'
			local indep `vars'_hijo_`y'_a`x'_ant
			rename `indep' indep
			noi di "`indep'"
			noi di "firthlogit `indep' mujer i.niveled_hijo`y' anio_hijo`x' caba_hijo`x' if hijo_`y' == 1 & ocupado_hijo_`y' == `cond' & cohorte==`c'"
			capture eststo `indep'_c`c' : firthlogit indep mujer `controles' if hijo_`y'_ant == 1 & ocupado_hijo_`y'_ant == `cond' & cohorte==`c'
			local acumtab `acumtab' `indep'_c`c'
			if _rc == 2000 | _rc == 2001 | _rc == 430 {
					local acumtab: subinstr local acumtab "`indep'_c`c'" "", all
			}
			
			restore
		}
	}
	di "`acumtab'"
	local `vars' `acumtab'
	noi est table ``vars'', star(0.1 0.05 0.01) b(%9.4f)
	local sheet_name = substr("``vars''",1,strpos("``vars''", " ")-11)
	xml_tab ``vars'', save("`cd'\Resultados\Resultados_c`c' - Anio ant.xls") sheet("`sheet_name'") append below
	local acumtab
	eststo clear
	}
}

** Formal/informal **
eststo clear
local anios 5
local max_hijos 3
local acumtab // orden de procesamiento 
local variables asalformal_af asalinf_af

forval c = 1/3 { 
	noi foreach vars in `variables' {
	if substr("`vars'",1,10) == "asalformal" {
		local cond 1
	}
	else {
		local cond 0
	}
	
	qui forval y = 1/`max_hijos' { 
		qui forval x = 1/`anios' {			
			preserve
			drop if niveled_hijo`y' == 0
			local controles i.niveled_hijo`y'
			local controles
			local indep `vars'_hijo_`y'_a`x'_ant
			rename `indep' indep
			
			local indep2 `vars'_h`y'a`x'_ant
			local acumtab `acumtab' `indep2'c`c'
			capture eststo `indep2'c`c': firthlogit indep mujer `controles'  if hijo_`y'_ant == 1 & ocupado_hijo_`y'_ant == 1 & asalformal_hijo_`y'_ant == `cond' & cohorte==`c'
			if _rc == 2000 | _rc == 2001 | _rc == 430 {
				local acumtab: subinstr local acumtab "`indep2'c`c'" "", all
			}
			
			restore
		}
	}
	
	di "`acumtab'"
	local `vars' `acumtab'
	noi est table ``vars'', star(0.1 0.05 0.01) b(%9.4f) 
	*local sheet_name = substr("``vars''",1,strpos("``vars''", " ")-10)
	local sheet_name = "`vars'"
	xml_tab ``vars'', save("`cd'\Resultados\Resultados_c`c' - Anio ant.xls") sheet("`sheet_name'") append below
	local acumtab
	eststo clear
	}
}
