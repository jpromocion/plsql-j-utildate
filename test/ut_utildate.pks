/**
 * Utplsql unit test for utildate
 * Autor: jpromocion (https://github.com/jpromocion) -> plsql-j-utildate
 */
CREATE OR REPLACE PACKAGE UT_UTILDATE AS

  --%suite(Test utildate)
  --%suitepath(test.plsql.j.utildate)

  --%beforeall
  PROCEDURE setNlsDateLanguage;

  --%test(today -> Check date of today)
  PROCEDURE today_01;

  --%test(daysBetweenDates -> Check number days dates positive)
  PROCEDURE daysBetweenDates_01;

  --%test(daysBetweenDates -> Check number days dates negative)
  PROCEDURE daysBetweenDates_02;

  --%test(daysBetweenDates -> Check number days same date)
  PROCEDURE daysBetweenDates_03;

  --%test(businessDaysBetweenDates -> Check number days dates)
  PROCEDURE businessDaysBetweenDates_01;

  --%test(businessDaysBetweenDates -> Check number days dates weekend)
  PROCEDURE businessDaysBetweenDates_02;

  --%test(nextDateBusinessDay -> New Date add bussines day)
  PROCEDURE nextDateBusinessDay_01;

  --%test(nextDateBusinessDay -> New Date add bussines day-negative)
  PROCEDURE nextDateBusinessDay_02;

  --%test(monthsBetweenDates -> Add more months)
  PROCEDURE monthsBetweenDates_01;

  --%test(monthsBetweenDates -> Minus months)
  PROCEDURE monthsBetweenDates_02;

  --%test(monthsBetweenDates -> same date)
  PROCEDURE monthsBetweenDates_03;

  --%test(yearsBetweenDates -> Add more years)
  PROCEDURE yearsBetweenDates_01;

  --%test(yearsBetweenDates -> Minus years)
  PROCEDURE yearsBetweenDates_02;

  --%test(yearsBetweenDates -> same date)
  PROCEDURE yearsBetweenDates_03;

  --%test(exactYearsBetweenDates -> Add more years)
  PROCEDURE exactYearsBetweenDates_01;

  --%test(exactYearsBetweenDates -> Minus years)
  PROCEDURE exactYearsBetweenDates_02;

  --%test(exactYearsBetweenDates -> same date)
  PROCEDURE exactYearsBetweenDates_03;

  --%test(age -> many ages)
  PROCEDURE age_01;

  --%test(age -> 0 years)
  PROCEDURE age_02;

  --%test(addYears -> add years)
  PROCEDURE addYears_01;

  --%test(addYears -> minus years)
  PROCEDURE addYears_02;

  --%test(addYears -> 0 years)
  PROCEDURE addYears_03;

  --%test(semesterDate -> semester ok)
  PROCEDURE semesterDate_01;

  --%test(trimesterDate -> trimester ok)
  PROCEDURE trimesterDate_01;

  --%test(numberToHour -> hour ok)
  PROCEDURE numberToHour_01;

  --%test(numberToHour -> hour invalid)
  --%throws(-01853)
  PROCEDURE numberToHour_02;

  --%test(hourToNumber -> hour ok)
  PROCEDURE hourToNumber_01;

  --%test(secondToDays -> num days ok)
  PROCEDURE secondToDays_01;

  --%test(secondToDays -> num days 0)
  PROCEDURE secondToDays_02;

  --%test(dateInRange -> date in range)
  PROCEDURE dateInRange_01;

  --%test(dateInRange -> date in not range)
  PROCEDURE dateInRange_02;

  --%test(dateInRange -> range invalid)
  PROCEDURE dateInRange_03;

  --%test(getEasterSunday -> easter sunday ok)
  PROCEDURE getEasterSunday_01;

  --%test(getStartEasterHolidays -> start easter holiday ok)
  PROCEDURE getStartEasterHolidays_01;

  --%test(getEndEasterHolidays -> end easter holiday ok)
  PROCEDURE getEndEasterHolidays_01;



END UT_UTILDATE;
/
SHOW ERRORS
