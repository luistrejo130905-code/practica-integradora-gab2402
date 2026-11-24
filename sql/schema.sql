DROP TABLE IF EXISTS empleados;

CREATE TABLE empleados (
    id_empleado          INTEGER PRIMARY KEY,
    edad                 INTEGER NOT NULL CHECK (edad BETWEEN 18 AND 80),
    experiencia_anios    INTEGER NOT NULL CHECK (experiencia_anios >= 0),
    nivel_educativo      INTEGER NOT NULL CHECK (nivel_educativo BETWEEN 1 AND 4),
    departamento         TEXT NOT NULL,
    ciudad               TEXT NOT NULL,
    genero               TEXT NOT NULL CHECK (genero IN ('F', 'M')),
    horas_extra_mes      INTEGER NOT NULL CHECK (horas_extra_mes >= 0),
    satisfaccion_laboral INTEGER NOT NULL CHECK (satisfaccion_laboral BETWEEN 1 AND 5),
    antiguedad_empresa   INTEGER NOT NULL CHECK (antiguedad_empresa >= 0),
    salario_mensual      REAL NOT NULL CHECK (salario_mensual > 0),
    rango_edad           TEXT NOT NULL,
    ratio_antiguedad_exp REAL NOT NULL CHECK (ratio_antiguedad_exp BETWEEN 0 AND 1),
    horas_extra_altas    INTEGER NOT NULL CHECK (horas_extra_altas IN (0, 1))
);

CREATE INDEX idx_empleados_departamento ON empleados(departamento);
CREATE INDEX idx_empleados_ciudad ON empleados(ciudad);