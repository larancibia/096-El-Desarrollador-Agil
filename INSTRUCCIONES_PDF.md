# 📄 CÓMO OBTENER EL PDF DEL LIBRO

## Opción 1: Descargar HTML y Convertir (RECOMENDADO)

1. **Descargar el HTML:**
```bash
wget https://raw.githubusercontent.com/larancibia/096-El-Desarrollador-Agil/master/El_Desarrollador_Agil.html
```

2. **Abrir en navegador y Guardar como PDF:**
   - Abrir `El_Desarrollador_Agil.html` en Chrome/Firefox
   - Ctrl+P (Imprimir)
   - Seleccionar "Guardar como PDF"
   - Ajustar márgenes
   - ¡Listo!

---

## Opción 2: Usar Pandoc (Si tienes instalado)

```bash
# Descargar el markdown
wget https://raw.githubusercontent.com/larancibia/096-El-Desarrollador-Agil/master/manuscript_final.md

# Convertir a PDF
pandoc manuscript_final.md -o El_Desarrollador_Agil.pdf \
  --pdf-engine=xelatex \
  -V geometry:margin=1in \
  -V fontsize=12pt \
  --toc
```

---

## Opción 3: Herramientas Online

### CloudConvert (Gratis)
1. Ir a: https://cloudconvert.com/html-to-pdf
2. Subir: `El_Desarrollador_Agil.html`
3. Convertir
4. Descargar PDF

### PDF24 (Gratis)
1. Ir a: https://tools.pdf24.org/es/html-a-pdf
2. Subir HTML
3. Convertir

---

## Opción 4: Comando rápido (Con Chrome instalado)

```bash
google-chrome --headless --disable-gpu --print-to-pdf=libro.pdf El_Desarrollador_Agil.html
```

---

## 📥 Descarga Directa del Capítulo 1 (El mejor)

El Capítulo 1 completo (4,500 palabras, calidad bestseller) está disponible aquí:

https://github.com/larancibia/096-El-Desarrollador-Agil/blob/master/outputs/chapters/chapter01_cerebro.md

**Puedes copiar y pegar en Google Docs y exportar como PDF desde ahí.**

---

## 🌐 Ver Online

HTML Preview:
https://htmlpreview.github.io/?https://github.com/larancibia/096-El-Desarrollador-Agil/blob/master/El_Desarrollador_Agil.html

---

**Nota:** Estamos generando un PDF oficial que estará disponible próximamente.
