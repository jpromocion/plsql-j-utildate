/**
 * Paquete para utilidades de manipulacion de fechas
 * Autor: jpromocion (https://github.com/jpromocion) -> plsql-j-utildate
 */
CREATE OR REPLACE PACKAGE UTILDATE AS

  /**
   * Devuelve la fecha truncada del día actual
   * @return Fecha del día trucada hasta dia
   */
  FUNCTION hoy RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(hoy, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de dias entre dos fechas
   * @param date1 Fecha inferior
   * @param date2 Fecha superior
   * @return Número de dias entre las fechas
   */
  FUNCTION diasEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(diasEntreFechas, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de dias habiles entre dos fechas.
   * Habil: Lunes a Viernes
   * @param date1 Fecha inferior
   * @param date2 Fecha superior
   * @return Número de dias habiles entre las fechas
   */
  FUNCTION diasHabilesEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(diasHabilesEntreFechas, WNPS, RNPS, WNDS);

  /**
   * Devuelve la fecha concreta dada por incrementar un numero de dias a la fecha indicada
   * Habil: Lunes a Viernes
   * @param date1 Fecha inferior
   * @param dias Dias a incrementar. Si es negativo sera a decrementar
   * @return fecha del día habil tras incrementar el numero indicado
   */
  FUNCTION fechaSiguienteDiasHabiles(date1 DATE, dias NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(fechaSiguienteDiasHabiles, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de meses entre dos fechas
   * @param date1 Fecha inferior
   * @param date2 Fecha superior
   * @return Número de meses entre las fechas
   */
  FUNCTION mesesEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(mesesEntreFechas, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de años entre dos fechas
   * @param date1 Fecha inferior
   * @param date2 Fecha superior
   * @return Número de años entre las fechas
   */
  FUNCTION anosEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(anosEntreFechas, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de años entre dos fechas con aplicacion de decimales
   * @param date1 Fecha inferior
   * @param date2 Fecha superior
   * @return Número de años entre las fechas con aplicacion de decimales
   */
  FUNCTION anosEntreFechasExactos(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(anosEntreFechasExactos, WNPS, RNPS, WNDS);

  /**
   * Devuelve el número de años enteros que tiene una persona en base
   * a la fecha nacimiento
   * @param fechaNacimiento Fecha de nacimiento
   * @param fechaComprobacion Fecha del momento a comprobar. Defecto hoy
   * @return Edad (entero)
   */
  FUNCTION edad(fechaNacimiento DATE, fechaComprobacion DATE := SYSDATE)
  RETURN PLS_INTEGER;
    PRAGMA RESTRICT_REFERENCES(edad, WNPS, RNPS, WNDS);

  /**
   * Devuelve la cadena para fecha: DD de Mes de YYYY
   * @param date1 Fecha
   * @return Fecha como DD de Mes de YYYY
   */
  FUNCTION fechaCadena(date1 DATE)
  RETURN VARCHAR2;
    PRAGMA RESTRICT_REFERENCES(fechaCadena, WNPS, RNPS, WNDS);

  /**
   * Incrementa a una fecha dada el numero de años indicados
   * @param date1 Fecha
   * @param numEjer Numero de ejercicios a incrementar
   * @return Nueva fecha con el incremento de años aplicado
   */
  FUNCTION addAnos(date1 DATE, numEjer NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(addAnos, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de semestre al que pertence la fecha
   * @param date1 Fecha
   * @return Número semestre: 1,2
   */
  FUNCTION semestreFecha(date1 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(semestreFecha, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de trimestre al que pertence la fecha
   * @param date1 Fecha
   * @return Nueva de trimestre: 1,2,3,4
   */
  FUNCTION trimestreFecha(date1 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(trimestreFecha, WNPS, RNPS, WNDS);

  /**
   * Convierte un numero decimal al correspondiente hora de 24 horas
   * @param num NUmero decimal
   * @return Hora del del dia equivalente (2,5 > 02:30). Lo devuelve dentro de un DATE con
   * el sysdate
   */
  FUNCTION numeroAHora(num NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(numeroAHora, WNPS, RNPS, WNDS);

  /**
   * Convierte una hora de 24 horas en un numero decimal correspondiente
   * @param num Fecha con parte horaria
   * @return Numero equivalente a la hora (02:30 -> 2,5).
   */
  FUNCTION horaANumero(date1 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(horaANumero, WNPS, RNPS, WNDS);

  /**
   * Devuelve el numero de dias corresponde a los segundos indicados
   * @param segundos Segundos
   * @return Dias correspondientes
   */
  FUNCTION segundosADias(segundos NUMBER)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(segundosADias, WNPS, RNPS, WNDS);

  /**
   * Comprueba si una fecha esta dentro del rango indicado
   * @param date1 Fecha a comprobar
   * @param fecInicio Fecha inicio rango
   * @param fecFin Fecha fin rango
   * @return TRUE si esta en rango, FALSE en otro caso
   */
  FUNCTION fechaEnRango(date1 DATE, fecInicio DATE, fecFin DATE)
  RETURN BOOLEAN;
    PRAGMA RESTRICT_REFERENCES(fechaEnRango, WNPS, RNPS, WNDS);

  /**
   * Devuevel el dia en el que cae domingo resureccion de la semana santa
   * para el ejercicio indicado
   * @param ejercicio Ejercicio sobre el que obtener
   * @return Fecha del domingo de resureccion
   */
  FUNCTION dameDomingoResureccion(ejercicio NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(dameDomingoResureccion, WNPS, RNPS, WNDS);

  /**
   * Devuelve la fecha de inicio del periodo de vacaciones para Semana Santa
   * teniendo en cuenta que sera el lunes anterior al domingo de resureccion
   * @param ejercicio Ejercicio sobre el que obtener
   * @return Fecha de inicio vacaciones semana santa: lunes de la semana santa.
   */
  FUNCTION dameIniVacaSemanaSanta(ejercicio NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(dameIniVacaSemanaSanta, WNPS, RNPS, WNDS);

  /**
   * Devuelve la fecha de fin del periodo de vacaciones para Semana Santa
  * teniendo en cuenta que sera el domingo de la semana siguiente al domingo de resureccion
   * @param ejercicio Ejercicio sobre el que obtener
   * @return Fecha de fin vacaciones semana santa: domingo semana posterior a semana santa.
   */
  FUNCTION dameFinVacaSemanaSanta(ejercicio NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(dameFinVacaSemanaSanta, WNPS, RNPS, WNDS);


END UTILDATE;
/
SHOW ERRORS
