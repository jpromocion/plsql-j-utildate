/**
 * Util pack date
 * Autor: jpromocion (https://github.com/jpromocion) -> plsql-j-utildate
 */
CREATE OR REPLACE PACKAGE UTILDATE AS

  /**
   * Return current day truncate
   * @return
   */
  FUNCTION today RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(today, WNPS, RNPS, WNDS);

  /**
   * Return number of days between two dates
   * @param date1 Lower date
   * @param date2 Upper date
   * @return
   */
  FUNCTION daysBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(daysBetweenDates, WNPS, RNPS, WNDS);

  /**
   * Return number of business days between two dates
   * business day: Monday to Friday
   * @param date1 Lower date
   * @param date2 Upper date
   * @return
   */
  FUNCTION businessDaysBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(businessDaysBetweenDates, WNPS, RNPS, WNDS);

  /**
   * Return next date after add number of business days
   * business day: Monday to Friday
   * @param date1 Date
   * @param days days add. negative -> decrease
   * @return
   */
  FUNCTION nextDateBusinessDay(date1 DATE, days NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(nextDateBusinessDay, WNPS, RNPS, WNDS);

  /**
   * Return months between two dates
   * @param date1 Lower date
   * @param date2 Upper date
   * @return
   */
  FUNCTION monthsBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(monthsBetweenDates, WNPS, RNPS, WNDS);

  /**
   * Return years between two dates
   * @param date1 Lower date
   * @param date2 Upper date
   * @return
   */
  FUNCTION yearsBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(yearsBetweenDates, WNPS, RNPS, WNDS);

  /**
   * Return years (accuracy) between two dates
   * @param date1 Lower date
   * @param date2 Upper date
   * @return
   */
  FUNCTION exactYearsBetweenDates(date1 DATE, date2 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(exactYearsBetweenDates, WNPS, RNPS, WNDS);

  /**
   * Return age (integer) of person
   * @param birthDate birth date
   * @param checkDate check date. Defautl: today
   * @return Edad (entero)
   */
  FUNCTION age(birthDate DATE, checkDate DATE := SYSDATE)
  RETURN PLS_INTEGER;
    PRAGMA RESTRICT_REFERENCES(age, WNPS, RNPS, WNDS);

  /**
   * Return string date: DD of Mes of YYYY
   * @param date1 Date
   * @return Date like DD of Mes of YYYY
   */
  FUNCTION dateString(date1 DATE)
  RETURN VARCHAR2;
    PRAGMA RESTRICT_REFERENCES(dateString, WNPS, RNPS, WNDS);

  /**
   * Add years to date
   * @param date1 date
   * @param numYears Number of years
   * @return
   */
  FUNCTION addYears(date1 DATE, numYears NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(addYears, WNPS, RNPS, WNDS);

  /**
   * Return number of semester of a date
   * @param date1 Date
   * @return Semester number: 1,2
   */
  FUNCTION semesterDate(date1 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(semesterDate, WNPS, RNPS, WNDS);

  /**
   * Return number of trimester of a date
   * @param date1 Date
   * @return trimester number: 1,2,3,4
   */
  FUNCTION trimesterDate(date1 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(trimesterDate, WNPS, RNPS, WNDS);

  /**
   * Convert a decimal number to 24 hours
   * @param num Decimal number
   * @return Hour of day (2,5 > 02:30). Return like sysdate
   */
  FUNCTION numberToHour(num NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(numberToHour, WNPS, RNPS, WNDS);

  /**
   * Convert a 24 hours to decimal number
   * @param num Date with 24 hour
   * @return Decimal number(02:30 -> 2,5).
   */
  FUNCTION hourToNumber(date1 DATE)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(hourToNumber, WNPS, RNPS, WNDS);

  /**
   * Return numer of days for seconds
   * @param seconds seconds
   * @return
   */
  FUNCTION secondToDays(seconds NUMBER)
  RETURN NUMBER;
    PRAGMA RESTRICT_REFERENCES(secondToDays, WNPS, RNPS, WNDS);

  /**
   * Check a date in range
   * @param date1 Check date
   * @param starDate start date in range
   * @param endDate end date in range
   * @return TRUE if it's in a range, FALSE otherwise
   */
  FUNCTION dateInRange(date1 DATE, starDate DATE, endDate DATE)
  RETURN BOOLEAN;
    PRAGMA RESTRICT_REFERENCES(dateInRange, WNPS, RNPS, WNDS);

  /**
   * Return the Easter Sunday of Easter Holidays
   * for the parameter year
   * @param year year
   * @return
   */
  FUNCTION getEasterSunday(year NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(getEasterSunday, WNPS, RNPS, WNDS);

  /**
   * Return start date of Easter Holidays.
   * Monday before Easter Sunday.
   * @param year year
   * @return
   */
  FUNCTION getStartEasterHolidays(year NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(getStartEasterHolidays, WNPS, RNPS, WNDS);

  /**
   * Return end date of Easter Holidays.
   * Sunday after Easter Sunday.
   * @param year year
   * @return
   */
  FUNCTION getEndEasterHolidays(year NUMBER)
  RETURN DATE;
    PRAGMA RESTRICT_REFERENCES(getEndEasterHolidays, WNPS, RNPS, WNDS);


END UTILDATE;
/
SHOW ERRORS
