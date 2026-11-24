# Bitácora de Decisiones de Limpieza

**Archivo origen:** `data/empleados_analitica.csv` (603 filas × 11 columnas)  
**Destino final:** `data/empleados.db` — tabla `empleados` (600 filas × 14 columnas)  
**Notebook reproducible:** `notebooks/01_limpieza_y_bd.ipynb`

---

## 1. Eliminación de duplicados
* **Qué se hizo:** Se eliminaron 3 filas exactamente duplicadas correspondientes a los registros `id_empleado` `2`, `6` y `10` usando `drop_duplicates(subset=["id_empleado"], keep="first")`.
* **Por qué:** Evitar doble conteo en promedios y totales, y garantizar la unicidad requerida por la clave primaria (`PRIMARY KEY`) en SQLite.

## 2. Normalización de texto y tipos de datos
* **Qué se hizo:** Se aplicó `.str.strip()` a las variables categóricas (`departamento`, `ciudad`, `genero`), se convirtió `edad` de `float64` a `INTEGER` y se redondeó `salario_mensual` a 2 decimales.
* **Por qué:** Prevenir fragmentación de categorías por espacios accidentales y asegurar consistencia de tipos al cargar en SQLite.

## 3. Imputación de valores faltantes
* **Qué se hizo:**
  * `edad` (8 nulos): imputada con la **mediana por `departamento`**, redondeada al entero más cercano.
  * `salario_mensual` (15 nulos): imputada con la **mediana por `departamento`**.
* **Por qué:** Se descartó eliminar filas para no perder información válida del resto de variables. Se eligió la mediana por grupo (en lugar de la media global) porque respeta las diferencias estructurales entre áreas y es robusta frente a valores extremos.

## 4. Tratamiento de valores atípicos (Outliers)
* **Qué se hizo:** Se evaluó `salario_mensual` mediante el criterio de rango intercuartílico ($1.5 \times \text{IQR}$), obteniendo $Q1 = 33,341.55$, $Q3 = 52,160.22$ y un límite superior de `$80,388.23`. Se detectó 1 valor atípico extremo (`id_empleado = 21`, Finanzas, con `$210,000.00`) y se aplicó recorte (*winsorizing*) al límite superior con `.clip()`.
* **Por qué:** Conservar el registro completo del empleado sin que un valor aislado distorsione los salarios promedio por departamento ni sesgue modelos analíticos posteriores.

## 5. Verificación de consistencia lógica
* **Qué se hizo:** Se validó que ningún empleado tuviera `antiguedad_empresa > experiencia_anios` ni `edad - experiencia_anios < 18`.
* **Resultado:** 0 inconsistencias detectadas.

## 6. Creación de variables derivadas
* **Qué se hizo:** Se generaron 3 variables nuevas: `rango_edad` (agrupación etaria), `ratio_antiguedad_exp` (indicador de retención) y `horas_extra_altas` (indicador binario para `horas_extra_mes > 15`).
* **Por qué:** Facilitar segmentaciones, consultas SQL agregadas y análisis exploratorios sin recalcular reglas de negocio en cada consulta.

## 7. Almacenamiento e integridad en SQLite
* **Qué se hizo:** Se definió el esquema en `sql/schema.sql` con `PRIMARY KEY`, restricciones `NOT NULL` y `CHECK` en los rangos válidos, además de índices en `departamento` y `ciudad`.
* **Por qué:** Asegurar que cualquier recarga futura rechace automáticamente datos corruptos y acelerar las consultas agregadas más frecuentes.
