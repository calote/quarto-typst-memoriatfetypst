#!/bin/bash
# Empaqueta el ejemplo ejemploconslides en un ZIP autocontenido
# Ejecutar desde cualquier directorio; el ZIP se crea en tests/ejemploconslides/

cd "$(dirname "$0")"

ZIP="ejemploconslides.zip"

echo "📦 Empaquetando ejemplo en ${ZIP} ..."

rm -f "${ZIP}"

zip -r "${ZIP}" \
  _extensions/ \
  _contenido.qmd \
  a_ejemplo.qmd \
  a_ejemplo-slides.qmd \
  eliminar-separadores.lua \
  fontsize-noop.lua \
  color-spans-typst.lua \
  logo.png \
  referencias.bib \
  empaquetar-ejemplo.sh \
  -x "*/_extensions/*/.git" \
  -x "*/_extensions/*/.git/*" \
  -x ".quarto/*"

# Eliminar PDFs y HTML del ZIP si se incluyeron accidentalmente
zip -d "${ZIP}" "*.pdf" "*.html" "*.knit.md" "*.typ" "*.log" > /dev/null 2>&1

echo "✅ Creado: $(pwd)/${ZIP}"
echo "   Tamaño: $(du -h "${ZIP}" | cut -f1)"
echo ""
echo "Para descomprimir en un proyecto nuevo:"
echo "  unzip ${ZIP} -d /ruta/mi-proyecto"
