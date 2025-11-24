#!/bin/bash

CHAPTER_NUM=$1
TITLE=$2
WORDS=$3
PROMPT_FILE=$4

echo "Eres un escritor experto creando el libro 'El Desarrollador Ágil' en español.

Debes escribir el Capítulo ${CHAPTER_NUM} COMPLETO titulado '${TITLE}' de exactamente ${WORDS} palabras.

IMPORTANTE: Escribe el capítulo COMPLETO con todo el contenido, NO un resumen o meta-descripción. El output debe ser el texto del capítulo listo para publicar.

Requisitos estrictos:
- Exactamente ${WORDS} palabras
- Idioma: Español
- Estilo: Científico + práctico + accesible (como 'Agilmente' de Bachrach)
- Estructura similar al Capítulo 1 que ya conoces
- Incluye historia de apertura con un protagonista
- Secciones con investigación científica real
- Estrategias prácticas implementables
- Referencias académicas al final

$(cat $PROMPT_FILE)

Escribe ahora el capítulo COMPLETO de ${WORDS} palabras:" | claude --no-cache --print
