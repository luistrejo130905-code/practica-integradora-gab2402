# Diccionario de Datos — `empleados`

Base de datos: `data/empleados.db` (SQLite)  
Tabla principal: `empleados`  
Total de registros limpios: **600**

| Variable | Tipo (SQLite) | Descripción | Valores posibles / Rango | Notas de calidad |
| :--- | :--- | :--- | :--- | :--- |
| `id_empleado` | `INTEGER` | Identificador único del empleado (Clave Primaria). | `1` – `600` | Se eliminaron 3 registros duplicados exactos (`id_empleado` 2, 6 y 10). Sin nulos. |
| `edad` | `INTEGER` | Edad del empleado en años cumplidos. | `22` – `60` (`CHECK 18–80`) | Se imputaron 8 valores nulos con la mediana por `departamento` y se normalizó de `float` a `INTEGER`. |
| `experiencia_anios` | `INTEGER` | Años totales de experiencia laboral del empleado. | `0` – `35` (`CHECK >= 0`) | Sin nulos ni valores fuera de rango. |
| `nivel_educativo` | `INTEGER` | Nivel máximo de estudios codificado numéricamente. | `1`, `2`, `3`, `4` | Sin nulos. Escala ordinal de 1 a 4. |
| `departamento` | `TEXT` | Área organizacional a la que pertenece el empleado. | `IT`, `Operaciones`, `Ventas`, `Finanzas`, `Marketing`, `RH` | Sin nulos. Texto normalizado con `.strip()`. Indexado (`idx_empleados_departamento`). |
| `ciudad` | `TEXT` | Sede o ciudad de trabajo. | `CDMX`, `GDL`, `MTY`, `PUE`, `QRO` | Sin nulos. Texto normalizado con `.strip()`. Indexado (`idx_empleados_ciudad`). |
| `genero` | `TEXT` | Género registrado del empleado. | `F`, `M` | Sin nulos. Restringido mediante `CHECK`. |
| `horas_extra_mes` | `INTEGER` | Cantidad de horas extra trabajadas al mes. | `0` – `21` (`CHECK >= 0`) | Sin nulos ni valores negativos. |
| `satisfaccion_laboral` | `INTEGER` | Nivel de satisfacción laboral reportado. | `1` – `5` | Sin nulos. Escala discreta del 1 (baja) al 5 (alta). |
| `antiguedad_empresa` | `INTEGER` | Años continuos laborando en la empresa actual. | `0` – `30` (`CHECK >= 0`) | Sin nulos. Se verificó integridad lógica: siempre es menor o igual a `experiencia_anios`. |
| `salario_mensual` | `REAL` | Salario mensual bruto en MXN. | `17,779.99` – `80,388.23` (`CHECK > 0`) | 15 nulos imputados con la mediana por `departamento`. 1 valor atípico (`$210,000.00`) recortado al límite superior IQR. Redondeado a 2 decimales. |
| `rango_edad` | `TEXT` | *(Variable derivada)* Grupo etario del empleado. | `18-29`, `30-39`, `40-49`, `50+` | Generada con `pd.cut()` sobre `edad` para facilitar análisis demográficos. |
| `ratio_antiguedad_exp` | `REAL` | *(Variable derivada)* Proporción de la experiencia total desarrollada dentro de la empresa. | `0.000` – `1.000` | Calculada como `antiguedad_empresa / experiencia_anios` (asignando `0.0` cuando `experiencia_anios == 0`). Redondeada a 3 decimales. |
| `horas_extra_altas` | `INTEGER` | *(Variable derivada)* Indicador binario de carga laboral extra alta. | `0` (No), `1` (Sí, `> 15` h/mes) | Permite segmentar rápidamente empleados con sobrecarga de horas extra. |
