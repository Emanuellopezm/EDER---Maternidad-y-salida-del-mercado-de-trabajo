***** eder2019_usuarios_retro *****

// Variable label for p2
label variable p2 "Sexo"
// Value labels for p2
label define gender_label 1 "Varón" 2 "Mujer"
label values p2 gender_label

// Variable label for cohorte
label variable cohorte "Cohorte de nacimiento"
// Value labels for cohorte
label define cohort_label 1 "1948-1952" 2 "1968-1972" 3 "1978-1982"
label values cohorte cohort_label

***** eder2019_usuarios_per *****

// Variable label for id
label variable id "Número de vivienda"
// Variable label for nhogar
label variable nhogar "Número de hogar"
// Variable label for miembro
label variable miembro "Número de miembro en el hogar"
// Variable label for total_m
label variable total_m "Total miembros del hogar"

// Variable label for p2
label variable p2 "Sexo"
// Value labels for p2
label define gender_label 1 "Varón" 2 "Mujer" 9 "No sabe o no responde"
label values p2 gender_label

label variable p3 "Año de nacimiento"
label define p3_label 9999 "No sabe o no responde"

label variable p3b "Edad al momento de la entrevista"
label define p3b_label 0 "Menor de 1 año" 9999 "No sabe o no responde"

label variable p4 "Relación de parentesco con el jefe de hogar"
label define p4_label 1 "Jefe/a" 2 "Cónyuge/pareja" 3 "Hijo/a" 4 "Hijastro/a" 5 "Yerno o nuera" 6 "Nieto/a" 7 "Padre/madre/suegro/a"        8 "Hermano/a" 9 "Cuñado/a" 10 "Sobrino/a" 11 "Abuelo/a" 12 "Otro familiar" 14 "Otro no familiar"

label variable e2 "¿Asiste o asistió a algún establecimiento educativo?"
label define e2_label 0 "Sin dato" 1 "Asiste" 2 "No asiste pero asistió" 3 "Nunca asistió" 9 "No sabe o no responde"

label variable e6a "¿Qué nivel está cursando actualmente?"
label define e6a_label 0 "No corresponde/Sin dato" 3 "Primario común" 5 "Primario especial" 6 "Otras escuelas especiales" 7 "Secundario común" 10 "Secundario adultos" 12 "Terciario/superior no universitario" 13 "Universitario" 14 "Postgrado" 15 "Primario adultos" 19 "Jardín maternal, jardín de infantes, de 45 a 3 años." 20 "Jardín de infantes. Salas de 4 y 5 años." 99 "No sabe o no responde"

label variable e12a "¿Cuál es el nivel más alto que cursó?"
label define e12a_label 0 "No corresponde/Sin dato" 3 "Primario común" 4 "EGB (1º a 9º)" 5 "Primario especial" 6 "Otras escuelas especiales" 7 "Secundario/medio común" 10 "Secundario/medio/adultos" 12 "Terciario/superior no universitario" 13 "Universitario" 14 "Postgrado" 15 "Primario adultos" 99 "No sabe o no responde"

label variable e13 "Completó ese nivel?"
label define e13_label 0 "No corresponde/Sin dato" 1 "Sí" 2 "No" 9 "No sabe o no responde"

label variable e16a "Último grado o año aprobado en ese nivel"
label define e16a_label 0 "Ninguno" 1 "Primero" 2 "Segundo" 3 "Tercero" 4 "Cuarto" 5 "Quinto" 6 "Sexto" 7 "Séptimo" 11 "CBC" 88 "Sin dato" 99 "No sabe o no responde"

label variable e_nivel "Máximo nivel de instrucción alcanzado"
label define e_nivel_label 0 "No corresponde/asiste o asistió a escuelas especiales no primarias" 1 "Inicial" 2 "Primario Incompleto" 3 "Primario Completo"  4 "Secundario Incompleto" 5 "Secundario Completo" 6 "Superior / Universitario Incompleto" 7 "Superior / Universitario Completo / Postgrado inc.- compl." 8 "Sin instrucción" 9 "No sabe o no responde"

label variable e_aesc "Años de escolarización"
label define e_aesc_label 0 "Ninguno" 88 "Sin dato" 99 "No sabe o no responde"

label variable retro "Miembro seleccionado para contestar la encuesta retrospectiva"
label define retro_label 0 "No seleccionado" 1 "Seleccionado"

* Variables PADRE:
* Label for variable p13_0: Antecedentes del padre
label variable p13_0 "Antecedentes del padre"
label define p13_0_label 0 "No corresponde" 88 "No tiene ninguna información de su padre"
label values p13_0 p13_0_label

* Population with information about their father (p13_0 ≠ 88)
* Label for variable p13_3: Nivel educativo del padre
label variable p13_3 "Nivel educativo del padre"
label define p13_3_label 0 "Ninguno/ No corresponde" ///
                          1 "Inicial/preprimaria" ///
                          2 "Primaria" ///
                          3 "Secundaria" ///
                          4 "Terciario/no universitario" ///
                          5 "Universitario" ///
                          6 "Postgrado" ///
                          99 "No sabe o no responde"
label values p13_3 p13_3_label

* Population with information about their father (p13_0 ≠ 88) and father's education level is greater than none (p13_3≠ 0)
* Label for variable p13_4: Completitud del nivel educativo alcanzado por el padre
label variable p13_4 "Completitud del nivel educativo alcanzado por el padre"
label define p13_4_label 0 "No corresponde" 1 "Sí" 2 "No" 99 "No sabe o no responde"
label values p13_4 p13_4_label

* Variables MADRE:
* Label for variable p14_0: Antecedentes de la madre
label variable p14_0 "Antecedentes de la madre"
label define p14_0_label 0 "No corresponde" 88 "No tiene ninguna información de su madre"
label values p14_0 p14_0_label

* Population with information about their mother and whose mother was not born in the City of Buenos Aires (p14_1≠1 and p14_0≠88)
* Label for variable p14_3: Nivel educativo de la madre
label variable p14_3 "Nivel educativo de la madre"
label define p14_3_label 0 "Ninguno/ No corresponde" ///
                          1 "Inicial/preprimaria" ///
                          2 "Primaria" ///
                          3 "Secundaria" ///
                          4 "Terciario/no universitario" ///
                          5 "Universitario" ///
                          6 "Postgrado" ///
                          99 "No sabe o no responde"
label values p14_3 p14_3_label

* Population with information about their mother (p14_0 ≠ 88) and whose mother has/had an education level greater than none (p14_3≠ 0)
* Label for variable p14_4: Completitud del máximo nivel educativo alcanzado por la madre
label variable p14_4 "Completitud del máximo nivel educativo alcanzado por la madre"
label define p14_4_label 0 "No corresponde" 1 "Sí" 2 "No" 99 "No sabe o no responde"
label values p14_4 p14_4_label