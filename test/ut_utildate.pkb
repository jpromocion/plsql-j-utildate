/**
 * Utplsql unit test for utildate
 * Autor: jpromocion (https://github.com/jpromocion) -> plsql-j-utildate
 */
CREATE OR REPLACE PACKAGE BODY UT_UTILDATE AS

  PROCEDURE setNlsDateLanguage IS
  BEGIN
    execute immediate(q'(ALTER SESSION SET NLS_DATE_LANGUAGE = 'SPANISH')');
  END setNlsDateLanguage;

  PROCEDURE today_01 IS
  BEGIN
    ut.expect( TO_CHAR(UTILDATE.today(),'DD/MM/YYYY HH24:MI:SS') ).to_equal(TO_CHAR(SYSDATE,'DD/MM/YYYY') || ' ' || '00:00:00');
  END today_01;


  PROCEDURE daysBetweenDates_01 IS
  BEGIN
    ut.expect( UTILDATE.daysBetweenDates(SYSDATE, SYSDATE+1) ).to_equal(1);
    ut.expect( UTILDATE.daysBetweenDates(SYSDATE, SYSDATE+7) ).to_equal(7);
  END daysBetweenDates_01;

  PROCEDURE daysBetweenDates_02 IS
  BEGIN
    ut.expect( UTILDATE.daysBetweenDates(SYSDATE, SYSDATE-1) ).to_equal(-1);
    ut.expect( UTILDATE.daysBetweenDates(SYSDATE, SYSDATE-8) ).to_equal(-8);
  END daysBetweenDates_02;

  PROCEDURE daysBetweenDates_03 IS
  BEGIN
    ut.expect( UTILDATE.daysBetweenDates(SYSDATE, SYSDATE) ).to_equal(0);
    ut.expect( UTILDATE.daysBetweenDates(TRUNC(SYSDATE), SYSDATE) ).to_equal(0);
    ut.expect( UTILDATE.daysBetweenDates(SYSDATE, TRUNC(SYSDATE)) ).to_equal(0);
  END daysBetweenDates_03;

  PROCEDURE businessDaysBetweenDates_01 IS
  BEGIN
    ut.expect( UTILDATE.businessDaysBetweenDates(NEXT_DAY(SYSDATE,'Viernes'), NEXT_DAY(SYSDATE,'Viernes')+3) ).to_equal(2);
    ut.expect( UTILDATE.businessDaysBetweenDates(NEXT_DAY(SYSDATE,'Viernes'), NEXT_DAY(SYSDATE,'Viernes')+5) ).to_equal(4);
  END businessDaysBetweenDates_01;

  PROCEDURE businessDaysBetweenDates_02 IS
  BEGIN
    ut.expect( UTILDATE.businessDaysBetweenDates(NEXT_DAY(SYSDATE,'Sábado'), NEXT_DAY(SYSDATE,'Sábado')+1) ).to_equal(0);
  END businessDaysBetweenDates_02;

  PROCEDURE nextDateBusinessDay_01 IS
  BEGIN
    ut.expect( UTILDATE.nextDateBusinessDay(NEXT_DAY(SYSDATE,'Viernes'), 1) ).to_equal(NEXT_DAY(SYSDATE,'Domingo')+1);
  END nextDateBusinessDay_01;

  PROCEDURE nextDateBusinessDay_02 IS
  BEGIN
    ut.expect( UTILDATE.nextDateBusinessDay(NEXT_DAY(SYSDATE,'Domingo'), -1) ).to_equal(NEXT_DAY(SYSDATE,'Viernes'));
  END nextDateBusinessDay_02;

  PROCEDURE monthsBetweenDates_01 IS
  BEGIN
    ut.expect( UTILDATE.monthsBetweenDates(SYSDATE, ADD_MONTHS(SYSDATE,1)) ).to_equal(1);
  END monthsBetweenDates_01;

  PROCEDURE monthsBetweenDates_02 IS
  BEGIN
    ut.expect( UTILDATE.monthsBetweenDates(SYSDATE, ADD_MONTHS(SYSDATE,-1)) ).to_equal(-1);
  END monthsBetweenDates_02;

  PROCEDURE monthsBetweenDates_03 IS
  BEGIN
    ut.expect( UTILDATE.monthsBetweenDates(SYSDATE, SYSDATE) ).to_equal(0);
  END monthsBetweenDates_03;

  PROCEDURE yearsBetweenDates_01 IS
  BEGIN
    ut.expect( UTILDATE.yearsBetweenDates(SYSDATE, ADD_MONTHS(SYSDATE,12)) ).to_equal(1);
  END yearsBetweenDates_01;

  PROCEDURE yearsBetweenDates_02 IS
  BEGIN
    ut.expect( UTILDATE.yearsBetweenDates(SYSDATE, ADD_MONTHS(SYSDATE,-12)) ).to_equal(-1);
  END yearsBetweenDates_02;

  PROCEDURE yearsBetweenDates_03 IS
  BEGIN
    ut.expect( UTILDATE.yearsBetweenDates(SYSDATE, SYSDATE) ).to_equal(0);
  END yearsBetweenDates_03;

  PROCEDURE exactYearsBetweenDates_01 IS
  BEGIN
    ut.expect( UTILDATE.exactYearsBetweenDates(SYSDATE, ADD_MONTHS(SYSDATE,12)+10) ).to_be_between(a_lower_bound => 1, a_upper_bound => 2);
  END exactYearsBetweenDates_01;

  PROCEDURE exactYearsBetweenDates_02 IS
  BEGIN
    ut.expect( UTILDATE.exactYearsBetweenDates(SYSDATE, ADD_MONTHS(SYSDATE,-12)-10) ).to_be_null();
  END exactYearsBetweenDates_02;

  PROCEDURE exactYearsBetweenDates_03 IS
  BEGIN
    ut.expect( UTILDATE.exactYearsBetweenDates(SYSDATE, SYSDATE) ).to_equal(0);
  END exactYearsBetweenDates_03;

  PROCEDURE age_01 IS
  BEGIN
    ut.expect( UTILDATE.age(TO_DATE('01/04/1984','dd/mm/yyyy'), TO_DATE('15/01/2019','dd/mm/yyyy')) ).to_equal(34);
    ut.expect( UTILDATE.age(TO_DATE('01/04/1984','dd/mm/yyyy'), TO_DATE('31/03/2019','dd/mm/yyyy')) ).to_equal(34);
    ut.expect( UTILDATE.age(TO_DATE('01/04/1984','dd/mm/yyyy'), TO_DATE('01/04/2019','dd/mm/yyyy')) ).to_equal(35);
    ut.expect( UTILDATE.age(TO_DATE('01/04/1984','dd/mm/yyyy'), TO_DATE('02/04/2019','dd/mm/yyyy')) ).to_equal(35);
  END age_01;

  PROCEDURE age_02 IS
  BEGIN
    ut.expect( UTILDATE.age(TO_DATE('01/04/2019','dd/mm/yyyy'), TO_DATE('01/05/2019','dd/mm/yyyy')) ).to_equal(0);
    ut.expect( UTILDATE.age(TO_DATE('01/04/2019','dd/mm/yyyy'), TO_DATE('01/04/2019','dd/mm/yyyy')) ).to_equal(0);
    ut.expect( UTILDATE.age(TO_DATE('01/04/2019','dd/mm/yyyy'), TO_DATE('31/03/2020','dd/mm/yyyy')) ).to_equal(0);
  END age_02;

  PROCEDURE addYears_01 IS
  BEGIN
    ut.expect( UTILDATE.addYears(TO_DATE('01/05/2019','DD/MM/YYYY'), 1) ).to_equal(TO_DATE('01/05/2020','DD/MM/YYYY'));
    ut.expect( UTILDATE.addYears(TO_DATE('01/05/2019','DD/MM/YYYY'), 20) ).to_equal(TO_DATE('01/05/2039','DD/MM/YYYY'));
  END addYears_01;

  PROCEDURE addYears_02 IS
  BEGIN
    ut.expect( UTILDATE.addYears(TO_DATE('01/05/2019','DD/MM/YYYY'), -1) ).to_equal(TO_DATE('01/05/2018','DD/MM/YYYY'));
    ut.expect( UTILDATE.addYears(TO_DATE('01/05/2019','DD/MM/YYYY'), -20) ).to_equal(TO_DATE('01/05/1999','DD/MM/YYYY'));
  END addYears_02;

  PROCEDURE addYears_03 IS
  BEGIN
    ut.expect( UTILDATE.addYears(TO_DATE('01/05/2019','DD/MM/YYYY'), 0) ).to_equal(TO_DATE('01/05/2019','DD/MM/YYYY'));
  END addYears_03;

  PROCEDURE semesterDate_01 IS
  BEGIN
    ut.expect( UTILDATE.semesterDate(TO_DATE('01/05/2019','DD/MM/YYYY')) ).to_equal(1);
    ut.expect( UTILDATE.semesterDate(TO_DATE('01/01/2019','DD/MM/YYYY')) ).to_equal(1);
    ut.expect( UTILDATE.semesterDate(TO_DATE('30/06/2019','DD/MM/YYYY')) ).to_equal(1);
    ut.expect( UTILDATE.semesterDate(TO_DATE('01/07/2019','DD/MM/YYYY')) ).to_equal(2);
    ut.expect( UTILDATE.semesterDate(TO_DATE('15/10/2019','DD/MM/YYYY')) ).to_equal(2);
    ut.expect( UTILDATE.semesterDate(TO_DATE('31/12/2019','DD/MM/YYYY')) ).to_equal(2);
  END semesterDate_01;

  PROCEDURE trimesterDate_01 IS
  BEGIN
    ut.expect( UTILDATE.trimesterDate(TO_DATE('01/05/2019','DD/MM/YYYY')) ).to_equal(2);
    ut.expect( UTILDATE.trimesterDate(TO_DATE('01/01/2019','DD/MM/YYYY')) ).to_equal(1);
    ut.expect( UTILDATE.trimesterDate(TO_DATE('30/06/2019','DD/MM/YYYY')) ).to_equal(2);
    ut.expect( UTILDATE.trimesterDate(TO_DATE('01/07/2019','DD/MM/YYYY')) ).to_equal(3);
    ut.expect( UTILDATE.trimesterDate(TO_DATE('15/10/2019','DD/MM/YYYY')) ).to_equal(4);
    ut.expect( UTILDATE.trimesterDate(TO_DATE('31/12/2019','DD/MM/YYYY')) ).to_equal(4);
  END trimesterDate_01;

  PROCEDURE numberToHour_01 IS
  BEGIN
    ut.expect( UTILDATE.numberToHour(0) ).to_equal(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '00:00:00','DD/MM/YYYY HH24:MI:SS'));
    ut.expect( UTILDATE.numberToHour(2.5) ).to_equal(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '02:30:00','DD/MM/YYYY HH24:MI:SS'));
    ut.expect( UTILDATE.numberToHour(2.25) ).to_equal(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '02:15:00','DD/MM/YYYY HH24:MI:SS'));
    ut.expect( UTILDATE.numberToHour(23.99) ).to_equal(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '23:59:00','DD/MM/YYYY HH24:MI:SS'));
  END numberToHour_01;

  PROCEDURE numberToHour_02 IS
  BEGIN
    ut.expect( UTILDATE.numberToHour(24) ).to_equal(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '02:30:00','DD/MM/YYYY HH24:MI:SS'));
  END numberToHour_02;

  PROCEDURE hourToNumber_01 IS
  BEGIN
    ut.expect( UTILDATE.hourToNumber(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '00:00:00','DD/MM/YYYY HH24:MI:SS')) ).to_equal(0);
    ut.expect( UTILDATE.hourToNumber(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '02:30:00','DD/MM/YYYY HH24:MI:SS')) ).to_equal(2.5);
    ut.expect( UTILDATE.hourToNumber(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '02:15:00','DD/MM/YYYY HH24:MI:SS')) ).to_equal(2.25);
    ut.expect( ROUND(UTILDATE.hourToNumber(TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || '23:59:30','DD/MM/YYYY HH24:MI:SS')),2) ).to_equal(23.99);
  END hourToNumber_01;

  PROCEDURE secondToDays_01 IS
  BEGIN
    ut.expect( UTILDATE.secondToDays(1512) ).to_equal(0.0175);
    ut.expect( ROUND(UTILDATE.secondToDays(12451512),2) ).to_equal(144.11);
  END secondToDays_01;

  PROCEDURE secondToDays_02 IS
  BEGIN
    ut.expect( UTILDATE.secondToDays(0) ).to_equal(0);
  END secondToDays_02;

  PROCEDURE dateInRange_01 IS
  BEGIN
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('30/05/2019','DD/MM/YYYY')) ).to_be_true();
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('01/04/2019','DD/MM/YYYY'), TO_DATE('01/05/2019','DD/MM/YYYY')) ).to_be_true();
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('01/04/2019','DD/MM/YYYY'), TO_DATE('30/05/2019','DD/MM/YYYY')) ).to_be_true();
  END dateInRange_01;

  PROCEDURE dateInRange_02 IS
  BEGIN
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('02/05/2019','DD/MM/YYYY'), TO_DATE('30/05/2019','DD/MM/YYYY')) ).to_be_false();
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('01/04/2019','DD/MM/YYYY'), TO_DATE('30/04/2019','DD/MM/YYYY')) ).to_be_false();
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019 00:00:01','DD/MM/YYYY hh24:mi:ss'), TO_DATE('01/04/2019','DD/MM/YYYY'), TO_DATE('01/05/2019','DD/MM/YYYY')) ).to_be_false();
  END dateInRange_02;

  PROCEDURE dateInRange_03 IS
  BEGIN
    ut.expect( UTILDATE.dateInRange(TO_DATE('01/05/2019','DD/MM/YYYY'), TO_DATE('30/05/2019','DD/MM/YYYY'), TO_DATE('01/04/2019','DD/MM/YYYY')) ).to_be_false();
  END dateInRange_03;

  PROCEDURE getEasterSunday_01 IS
  BEGIN
    ut.expect( UTILDATE.getEasterSunday(2019) ).to_equal(TO_DATE('21/04/2019', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getEasterSunday(2018) ).to_equal(TO_DATE('01/04/2018', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getEasterSunday(2015) ).to_equal(TO_DATE('05/04/2015', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getEasterSunday(2013) ).to_equal(TO_DATE('31/03/2013', 'DD/MM/YYYY'));
  END getEasterSunday_01;

  PROCEDURE getStartEasterHolidays_01 IS
  BEGIN
    ut.expect( UTILDATE.getStartEasterHolidays(2019) ).to_equal(TO_DATE('15/04/2019', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getStartEasterHolidays(2018) ).to_equal(TO_DATE('26/03/2018', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getStartEasterHolidays(2015) ).to_equal(TO_DATE('30/03/2015', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getStartEasterHolidays(2013) ).to_equal(TO_DATE('25/03/2013', 'DD/MM/YYYY'));
  END getStartEasterHolidays_01;

  PROCEDURE getEndEasterHolidays_01 IS
  BEGIN
    ut.expect( UTILDATE.getEndEasterHolidays(2019) ).to_equal(TO_DATE('28/04/2019', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getEndEasterHolidays(2018) ).to_equal(TO_DATE('08/04/2018', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getEndEasterHolidays(2015) ).to_equal(TO_DATE('12/04/2015', 'DD/MM/YYYY'));
    ut.expect( UTILDATE.getEndEasterHolidays(2013) ).to_equal(TO_DATE('07/04/2013', 'DD/MM/YYYY'));
  END getEndEasterHolidays_01;



END UT_UTILDATE;
/
SHOW ERRORS
