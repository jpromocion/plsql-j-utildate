/**
 * Util pack date
 * Autor: jpromocion (https://github.com/jpromocion) -> plsql-j-utildate
 */
CREATE OR REPLACE PACKAGE BODY UTILDATE AS

  FUNCTION today RETURN DATE IS
  BEGIN
    RETURN TRUNC(SYSDATE);
  END today;

  FUNCTION daysBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN TRUNC(date2 - date1);
  END daysBetweenDates;

  FUNCTION businessDaysBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER IS
    businessDays NUMBER := 0;
  BEGIN
    WITH DAYS AS
      (
      SELECT date1 + seq AS DATEACT,
        to_char(date1 + seq , 'DY') AS WEEKDAY
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
    INTO businessDays
    FROM DAYS D
    WHERE D.WEEKDAY NOT IN ('SUN','SAT','SÁB','DOM');

    RETURN businessDays;
  END businessDaysBetweenDates;

  FUNCTION nextDateBusinessDay(date1 DATE, days NUMBER)
  RETURN DATE IS
    newDate DATE;
    numCurrentDay NUMBER(15);
  BEGIN
    numCurrentDay := 0;
    newDate := date1;
    <<loopDays>>
    WHILE numCurrentDay < ABS(days) LOOP
      IF days > 0 THEN
        newDate := newDate + 1;
      ELSIF days < 0 THEN
        newDate := newDate - 1;
      END IF;

      IF TO_CHAR(newDate, 'DY') NOT IN ('SUN','SAT','SÁB','DOM') THEN
        numCurrentDay := numCurrentDay + 1;
      END IF;
    END LOOP loopDays;

    RETURN newDate;
  END nextDateBusinessDay;

  FUNCTION monthsBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN MONTHS_BETWEEN(date2, date1);
  END monthsBetweenDates;

  FUNCTION yearsBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN TRUNC(MONTHS_BETWEEN(date2, date1) / 12 );
  END yearsBetweenDates;

  FUNCTION exactYearsBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER IS
    startYear NUMBER(4);
    endYear NUMBER(4);
    totalDays NUMBER(15);
    totalYears NUMBER := 0;
    firstDay DATE;
    lastDay DATE;
    currentYear NUMBER(4);
  BEGIN
    startYear := EXTRACT(YEAR FROM date1);
    endYear := EXTRACT(YEAR FROM date2);

    totalDays := daysBetweenDates(date1, date2);

    IF totalDays = 0 THEN
      totalYears := 0;

    ELSIF startYear = endYear THEN
      firstDay := TRUNC(date1, 'YEAR');
      lastDay := ADD_MONTHS(TRUNC(date2, 'YEAR'),12)-1;

      totalYears := totalDays / daysBetweenDates( firstDay, lastDay );

    ELSIF startYear < endYear THEN
      <<recorreAnos>>
      FOR currentYear IN startYear..endYear LOOP
        firstDay := TO_DATE( '01/01/' || currentYear, 'DD/MM/YYYY' );
        lastDay := TO_DATE( '31/12/' || currentYear, 'DD/MM/YYYY' );

        totalYears := totalYears +
                       daysBetweenDates(
                          GREATEST(date1, firstDay),
                          LEAST(date2, lastDay)) /
                       daysBetweenDates(firstDay, lastDay);
      END LOOP recorreAnos;
    ELSE
      totalYears := NULL;
    END IF;

    RETURN totalYears;
  END exactYearsBetweenDates;


  FUNCTION age(birthDate DATE, checkDate DATE := SYSDATE)
  RETURN PLS_INTEGER IS
  BEGIN
    RETURN TRUNC(yearsBetweenDates(birthDate, checkDate));
  END age;

  FUNCTION dateString(date1 DATE)
  RETURN VARCHAR2 IS
  BEGIN
    RETURN TO_CHAR(date1, 'FMDD" of "') || INITCAP(TO_CHAR(date1, 'FMMONTH')) || TO_CHAR(date1, '" of "FMYYYY');
  END dateString;

  FUNCTION addYears(date1 DATE, numYears NUMBER)
  RETURN DATE IS
  BEGIN
    RETURN ADD_MONTHS(date1, 12 * numYears);
  END addYears;

  FUNCTION semesterDate(date1 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN CEIL(TO_NUMBER(TO_CHAR(date1, 'MM'))/6);
  END semesterDate;

  FUNCTION trimesterDate(date1 DATE)
  RETURN NUMBER IS
  BEGIN
    RETURN CEIL(TO_NUMBER(TO_CHAR(date1, 'MM'))/3);
  END trimesterDate;

  FUNCTION numberToHour(num NUMBER)
  RETURN DATE IS
    integerPart NUMBER;
    decimalPart NUMBER;
    aggregate NUMBER;
  BEGIN
    integerPart := TRUNC(num, 0);
    decimalPart := num - integerPart;
    aggregate := integerPart * 60 + ROUND(decimalPart * 60);
    aggregate := aggregate * 60;
    RETURN TO_DATE(TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')|| ' ' || aggregate,'DD/MM/YYYY SSSSS');
  END numberToHour;

  FUNCTION hourToNumber(date1 DATE)
  RETURN NUMBER IS
    integerPart NUMBER;
    decimalPart NUMBER ;
    aggregate NUMBER;
  BEGIN
    integerPart := TO_NUMBER(TO_CHAR(date1,'HH24'));
    decimalPart := TO_NUMBER(TO_CHAR(date1,'MI')) / 60;
    aggregate := integerPart + decimalPart;
    decimalPart := TO_NUMBER(TO_CHAR(date1,'SS')) / 3600;
    aggregate := aggregate + decimalPart;
    RETURN aggregate;
  END hourToNumber;

  FUNCTION secondToDays(seconds NUMBER)
  RETURN NUMBER IS
  BEGIN
    RETURN seconds / 24 / 60 / 60;
  END secondToDays;

  FUNCTION dateInRange(date1 DATE, starDate DATE, endDate DATE)
  RETURN BOOLEAN IS
    res BOOLEAN;
  BEGIN
    IF date1 BETWEEN starDate AND endDate THEN
      res := TRUE;
    ELSE
      res := FALSE;
    END IF;
    RETURN res;
  END dateInRange;

  FUNCTION getEasterSunday(year NUMBER)
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
    a_ano := to_number(year);

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

    IF (d+e) < 10 THEN
      ld_fecha:= to_date('01/03/'||year,'dd/mm/yyyy')+((d+e)+(22 - 1));
    ELSE
      ld_fecha:= to_date('01/04/'||year,'dd/mm/yyyy')+(((d+e)-9)-1);
    END IF;

    IF to_char(ld_fecha,'dd/mm') = '26/04' then
      ld_fecha:=to_date('19/04/'||year,'dd/mm/yyyy');
    ELSIF to_char(ld_fecha,'dd/mm') = '25/04' AND d=28 and e = 6 AND a > 10 then
      ld_fecha:=to_date('18/04/'||year,'dd/mm/yyyy');
    END IF;

    return ld_fecha;
  END getEasterSunday;

  FUNCTION getStartEasterHolidays(year NUMBER)
  RETURN DATE IS
    easterSunday DATE;
  BEGIN
    easterSunday := getEasterSunday(year);
    RETURN easterSunday-6;
  END getStartEasterHolidays;

  FUNCTION getEndEasterHolidays(year NUMBER)
  RETURN DATE IS
    easterSunday DATE;
  BEGIN
    easterSunday := getEasterSunday(year);
    RETURN easterSunday+7;
  END getEndEasterHolidays;

END UTILDATE;
/
SHOW ERRORS
