#show: doc => examtypst(
  $if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
  $endif$
  $if(papersize)$
  paper: "$papersize$",
  $endif$
  $if(fontsize-header)$
  fontsize-header: $fontsize-header$pt,
  $elseif(tamano-fuente-cabecera)$
  fontsize-header: $tamano-fuente-cabecera$pt,
  $endif$
  $if(idioma)$
  lang: "$idioma$",
  $elseif(lang)$
  lang: "$lang$",
  $endif$
  $if(fontsize)$
  fontsize: $fontsize$pt,
  $endif$
  $if(departamento)$
  department: "$departamento$",
  $elseif(department)$
  department: "$department$",
  $endif$
  $if(asignatura)$
  subject: "$asignatura$",
  $elseif(subject)$
  subject: "$subject$",
  $endif$
  $if(titulacion)$
  degree: "$titulacion$",
  $elseif(degree)$
  degree: "$degree$",
  $endif$
  $if(tipo-examen)$
  exam-type: "$tipo-examen$",
  $elseif(exam-type)$
  exam-type: "$exam-type$",
  $endif$
  $if(fecha-examen)$
  exam-date: "$fecha-examen$",
  $elseif(exam-date)$
  exam-date: "$exam-date$",
  $endif$
  $if(mostrar-datos-estudiante)$
  show-student-data: $mostrar-datos-estudiante$,
  $elseif(show-student-data)$
  show-student-data: $show-student-data$,
  $endif$
  // $if(show-solutions)$
  // show-solutions: $show-solutions$,
  // $elseif(mostrar-soluciones)$
  // show-solutions: $mostrar-soluciones$,
  // $endif$
  // $if(show-cabecera)$
  // show-cabecera: $show-cabecera$,
  // $elseif(mostrar-cabecera)$
  // show-cabecera: $mostrar-cabecera$,
  // $endif$
  $if(mostrar-ejercicio-cuadro)$
  show-ejercicio-cuadro: $mostrar-ejercicio-cuadro$,
  $elseif(show-ejercicio-cuadro)$
  show-ejercicio-cuadro: $show-ejercicio-cuadro$,
  $endif$
  // $if(ejercicio-salto-linea)$
  // ejercicio-salto-linea: $ejercicio-salto-linea$,
  // $elseif(exercise-line-break)$
  // ejercicio-salto-linea: $exercise-line-break$,
  // $endif$
  
  doc
)