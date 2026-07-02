#!/usr/bin/env Rscript

# Ejecutar tests de regresión de la extensión memoriatfetypst
# Uso: Rscript tests/regresion/ejecutar-tests.R
#
# Renderiza cada test-*.qmd a typst (PDF) y html, y verifica que no haya errores.
# Si algún test falla, sale con código 1.

test_dir <- "tests/regresion"
extension_src <- "_extensions/memoriatfetypst"
extension_dst <- file.path(test_dir, "_extensions", "memoriatfetypst")

# Sincronizar extensión antes de testear
dir.create(extension_dst, showWarnings = FALSE, recursive = TRUE)
file.copy(
  list.files(extension_src, full.names = TRUE),
  extension_dst,
  overwrite = TRUE, recursive = TRUE
)

qmd_files <- sort(list.files(test_dir, pattern = "^test-.*\\.qmd$", full.names = TRUE))

if (length(qmd_files) == 0L) {
  cat("No se encontraron ficheros test-*.qmd en", test_dir, "\n")
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
    r <- system2(
      "quarto",
      c("render", f, "--to", fmt, "--no-clean"),
      stdout = TRUE, stderr = TRUE
    )
    ok <- is.null(attr(r, "status")) || attr(r, "status") == 0L
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
  cat("\u2713 Todos los tests pasaron correctamente.\n\n")
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
