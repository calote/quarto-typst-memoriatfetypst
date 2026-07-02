#!/usr/bin/env Rscript

# Ejecutar tests de regresión de la extensión memoriatfetypst
# Uso: Rscript tests/regresion/ejecutar-tests.R [test-name]
#
# - Sin argumentos: ejecuta todos los test-*.qmd
# - Con un argumento: solo ejecuta los tests cuyo nombre contenga esa cadena
#   (útil para depurar un test concreto sin renderizar todos)
#
# Renderiza cada test-*.qmd a typst (PDF) y html, y verifica que no haya errores.
# Si algún test falla, sale con código 1.

args <- commandArgs(trailingOnly = TRUE)
filtro <- if (length(args) >= 1L) args[1L] else NULL

test_dir <- "tests/regresion"
extension_src <- "_extensions/memoriatfetypst"
extension_dst <- file.path(test_dir, "_extensions", "memoriatfetypst")

# Sincronizar extensión antes de testear
dir.create(extension_dst, showWarnings = FALSE, recursive = TRUE)
invisible(file.copy(
  list.files(extension_src, full.names = TRUE),
  extension_dst,
  overwrite = TRUE, recursive = TRUE
))

qmd_files <- sort(list.files(test_dir, pattern = "^test-.*\\.qmd$", full.names = TRUE))

if (!is.null(filtro)) {
  qmd_files <- qmd_files[grepl(filtro, basename(qmd_files), ignore.case = TRUE)]
}

if (length(qmd_files) == 0L) {
  if (!is.null(filtro)) {
    cat("No se encontraron tests que coincidan con '", filtro, "' en ", test_dir, "\n", sep = "")
  } else {
    cat("No se encontraron ficheros test-*.qmd en", test_dir, "\n")
  }
  quit(status = 1L, save = "no")
}

resultados <- data.frame(
  archivo = character(),
  formato = character(),
  ok = logical(),
  stringsAsFactors = FALSE
)

for (f in qmd_files) {
  for (fmt in c("memoriatfetypst-typst", "html")) {
    out <- basename(f)
    cat(sprintf("  → %s [%s] ... ", out, fmt))
    r <- system(
      sprintf("quarto render %s --to %s", shQuote(f), fmt),
      ignore.stdout = TRUE, ignore.stderr = TRUE
    )
    ok <- r == 0L
    cat(if (ok) "\u2713" else "\u2717", "\n", sep = "")
    resultados <- rbind(resultados, data.frame(
      archivo = basename(f),
      formato = fmt,
      ok = ok,
      stringsAsFactors = FALSE
    ))
  }
}

cat("\n", paste0(rep("=", 60), collapse = ""), "\n\n", sep = "")

if (all(resultados$ok)) {
  n <- nrow(resultados)
  cat("\u2713 ", n, " test(s) pasaron correctamente.\n\n", sep = "")
  quit(status = 0L, save = "no")
} else {
  n_fail <- sum(!resultados$ok)
  cat(sprintf("\u2717 Fallaron %d test(s):\n\n", n_fail))
  for (i in which(!resultados$ok)) {
    cat(sprintf("  - %s [%s]\n", resultados$archivo[i], resultados$formato[i]))
  }
  cat("\n")
  quit(status = 1L, save = "no")
}
