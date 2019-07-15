/**
 * Paquete para utilidades de manipulacion de fechas
 * Autor: jpromocion (https://github.com/jpromocion) -> plsql-j-utildate
 */
CREATE OR REPLACE PACKAGE BODY UTILDATE AS

  FUNCTION hoy RETURN DATE IS
  BEGIN
    RETURN TRUNC(SYSDATE);
  END hoy;

  FUNCTION diasEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN TRUNC(date2 - date1);
  END diasEntreFechas;

  FUNCTION diasHabilesEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER IS
    diasNegocio NUMBER := 0;
  BEGIN
    WITH DIAS AS
      (
      SELECT date1 + seq AS FECHA,
        to_char(date1 + seq , 'DY') AS DIASEMANA
      FROM
        (
        SELECT ROWNUM-1 seq
        FROM
          (
          SELECT 1
          FROM   dual
          CONNECT BY LEVEL <= (date2 - date1) + 1
          )
        )
      ORDER BY 1
      )
    SELECT count(1)
    INTO diasNegocio
    FROM DIAS D
    WHERE D.DIASEMANA NOT IN ('SUN','SAT','SÁB','DOM');

    RETURN diasNegocio;
  END diasHabilesEntreFechas;

  FUNCTION fechaSiguienteDiasHabiles(date1 DATE, dias NUMBER)
  RETURN DATE IS
    nuevaFecha DATE;
    numDiaActual NUMBER(15);
  BEGIN
    numDiaActual := 0;
    nuevaFecha := date1;
    <<recorreDias>>
    WHILE numDiaActual < ABS(dias) LOOP
      IF dias > 0 THEN
        nuevaFecha := nuevaFecha + 1;
      ELSIF dias < 0 THEN
        nuevaFecha := nuevaFecha - 1;
      END IF;

      IF TO_CHAR(nuevaFecha, 'DY') NOT IN ('SUN','SAT','SÁB','DOM') THEN
        numDiaActual := numDiaActual + 1;
      END IF;
    END LOOP recorreDias;

    RETURN nuevaFecha;
  END fechaSiguienteDiasHabiles;

  FUNCTION mesesEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN MONTHS_BETWEEN(date2, date1);
  END mesesEntreFechas;

  FUNCTION anosEntreFechas(date1 DATE, date2 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN TRUNC(MONTHS_BETWEEN(date2, date1) / 12 );
  END anosEntreFechas;

  FUNCTION anosEntreFechasExactos(date1 DATE, date2 DATE)
  RETURN NUMBER IS
    ejerInicial NUMBER(4);
    ejerFinal NUMBER(4);
    diasTotales NUMBER(15);
    anosTotales NUMBER := 0;
    primerDia DATE;
    ultimoDia DATE;
    anoActual NUMBER(4);
  BEGIN
    ejerInicial := EXTRACT(YEAR FROM date1);
    ejerFinal := EXTRACT(YEAR FROM date2);

    diasTotales := diasEntreFechas(date1, date2);

    IF diasTotales = 0 THEN
      anosTotales := 0;

    ELSIF ejerInicial = ejerFinal THEN
      --Mismo ejercicio -> calcula propicion a las fechas de inicio y fin de ese ejercicio
      -- Obtengo la fecha de inicio y fin del año
      primerDia := TRUNC(date1, 'YEAR');
      ultimoDia := ADD_MONTHS(TRUNC(date2, 'YEAR'),12)-1;

      anosTotales := diasTotales / diasEntreFechas( primerDia, ultimoDia );

    ELSIF ejerInicial < ejerFinal THEN
      --Proporcion pero por cada ejercicio, y vamos acumulando
      <<recorreAnos>>
      FOR anoActual IN ejerInicial..ejerFinal LOOP
        primerDia := TO_DATE( '01/01/' || anoActual, 'DD/MM/YYYY' );
        ultimoDia := TO_DATE( '31/12/' || anoActual, 'DD/MM/YYYY' );

        anosTotales := anosTotales +
                       diasEntreFechas(
                          GREATEST(date1, primerDia),
                          LEAST(date2, ultimoDia)) /
                       diasEntreFechas(primerDia, ultimoDia);
      END LOOP recorreAnos;
    ELSE
      anosTotales := NULL;
    END IF;

    RETURN anosTotales;
  END anosEntreFechasExactos;


  FUNCTION edad(fechaNacimiento DATE, fechaComprobacion DATE := SYSDATE)
  RETURN PLS_INTEGER IS
  BEGIN
    RETURN TRUNC(anosEntreFechas(fechaNacimiento, fechaComprobacion));
  END edad;

  FUNCTION fechaCadena(date1 DATE)
  RETURN VARCHAR2 IS
  BEGIN
    RETURN TO_CHAR(date1, 'FMDD" de "') || INITCAP(TO_CHAR(date1, 'FMMONTH')) || TO_CHAR(date1, '" de "FMYYYY');
  END fechaCadena;

  FUNCTION addAnos(date1 DATE, numEjer NUMBER)
  RETURN DATE IS
  BEGIN
    RETURN ADD_MONTHS(date1, 12 * numEjer);
  END addAnos;

  FUNCTION semestreFecha(date1 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN CEIL(TO_NUMBER(TO_CHAR(date1, 'MM'))/6);
  END semestreFecha;

  FUNCTION trimestreFecha(date1 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN CEIL(TO_NUMBER(TO_CHAR(date1, 'MM'))/3);
  END trimestreFecha;

  FUNCTION numeroAHora(num NUMBER)
  RETURN DATE IS
    parteEntera NUMBER;
    parteDecimal NUMBER ;
    acumulado NUMBER;
  BEGIN
    parteEntera := TRUNC(num, 0);
    parteDecimal := num - parteEntera;
    acumulado := parteEntera * 60 + ROUND(parteDecimal * 60);
    acumulado := acumulado * 60;
    RETURN TO_DATE(TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')|| ' ' || acumulado,'DD/MM/YYYY SSSSS');
  END numeroAHora;

  FUNCTION horaANumero(date1 DATE)
  RETURN NUMBER IS
    parteEntera NUMBER;
    parteDecimal NUMBER ;
    acumulado NUMBER;
  BEGIN
    parteEntera := TO_NUMBER(TO_CHAR(date1,'HH24'));
    parteDecimal := TO_NUMBER(TO_CHAR(date1,'MI')) / 60;
    acumulado := parteEntera + parteDecimal;
    parteDecimal := TO_NUMBER(TO_CHAR(date1,'SS')) / 3600;
    acumulado := acumulado + parteDecimal;
    RETURN acumulado;
  END horaANumero;

  FUNCTION segundosADias(segundos NUMBER)
  RETURN NUMBER IS
  BEGIN
    RETURN segundos / 24 / 60 / 60;
  END segundosADias;

  FUNCTION fechaEnRango(date1 DATE, fecInicio DATE, fecFin DATE)
  RETURN BOOLEAN IS
    res BOOLEAN;
  BEGIN
    IF date1 BETWEEN fecInicio AND fecFin THEN
      res := TRUE;
    ELSE
      res := FALSE;
    END IF;
    RETURN res;
  END fechaEnRango;

  FUNCTION dameDomingoResureccion(ejercicio NUMBER)
  RETURN DATE IS
    ld_fecha date;
    a_ano number;

    a integer;
    b integer;
    c integer;
    d integer;
    e integer;
    M integer;
    N integer;
  BEGIN
    --NOTA: https://es.wikipedia.org/wiki/Anexo:Implementaciones_del_algoritmo_de_c%C3%A1lculo_de_la_fecha_de_Pascua#Algoritmo_en_PL_SQL_Oracle
    a_ano := to_number(ejercicio);

    IF a_ano >= 1583 and a_ano <= 1699 THEN
      M:=22;
      N:=2;
    ELSIF a_ano >= 1700 AND a_ano <= 1799 THEN
      M:=23;
      N:=3;
    ELSIF a_ano >= 1800 AND a_ano <= 1899 THEN
      M:=23;
      N:=4;
    ELSIF a_ano >= 1900 AND a_ano <= 2099 THEN
      M:=24;
      N:=5;
    ELSIF a_ano >= 2100 AND a_ano <= 2199 THEN
      M:=24;
      N:=6;
    ELSIF a_ano >= 2200 AND a_ano <= 2299 THEN
      M:=25;
      N:=0;
    END IF;

    a:=Mod(a_ano,19);
    b:=Mod(a_ano,4);
    c:=Mod(a_ano,7);
    d:=Mod(((19*a) + M),30);
    e:=Mod(((2*b)+(4*c)+(6*d)+N),7);

    --Cálculo de fecha relativa.
    IF (d+e) < 10 THEN
      -- se resta 1 (22 dias -1) porque se toma como base el 1ro. de marzo.
      ld_fecha:= to_date('01/03/'||ejercicio,'dd/mm/yyyy')+((d+e)+(22 - 1));
    ELSE
      -- se resta 1 (9 dias -1) porque se toma como base el 1ro. de abril.
      ld_fecha:= to_date('01/04/'||ejercicio,'dd/mm/yyyy')+(((d+e)-9)-1);
    END IF;


    /*Condicionales especiales (excepciones según explicación).
    Existen dos excepciones a tener en cuenta:
    Si la fecha obtenida es el 26 de abril...
    la Pascua caerá en el 19 de abril.
    Si la fecha obtenida es el 25 de abril, con d = 28, e = 6 y a > 10.…
    la Pascua caerá en el 18 de abril.*/
    IF to_char(ld_fecha,'dd/mm') = '26/04' then
      ld_fecha:=to_date('19/04/'||ejercicio,'dd/mm/yyyy');
    ELSIF to_char(ld_fecha,'dd/mm') = '25/04' AND d=28 and e = 6 AND a > 10 then
      ld_fecha:=to_date('18/04/'||ejercicio,'dd/mm/yyyy');
    END IF;

    return ld_fecha;
  END dameDomingoResureccion;

  FUNCTION dameIniVacaSemanaSanta(ejercicio NUMBER)
  RETURN DATE IS
    domingoPascua DATE;
  BEGIN
    domingoPascua := dameDomingoResureccion(ejercicio);
    RETURN domingoPascua-6;
  END dameIniVacaSemanaSanta;

  FUNCTION dameFinVacaSemanaSanta(ejercicio NUMBER)
  RETURN DATE IS
    domingoPascua DATE;
  BEGIN
    domingoPascua := dameDomingoResureccion(ejercicio);
    RETURN domingoPascua+7;
  END dameFinVacaSemanaSanta;

END UTILDATE;
/
SHOW ERRORS
