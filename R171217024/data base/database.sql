/*Table structure for table `booking` */
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `booking`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE `booking` (
  `Booking_No` INT(4) NOT NULL,
  `Pass_no` INT(4) DEFAULT NULL,
  `PassName` VARCHAR(25) DEFAULT NULL,
  `Bus_RegNo` VARCHAR(20) DEFAULT NULL,
  `SeatNo` INT(2) DEFAULT NULL,
  `Date_of_Travel` DATE DEFAULT NULL,
  `Time_of_Travel` VARCHAR(10) DEFAULT NULL,
  `Pass_From` VARCHAR(25) DEFAULT NULL,
  `Destination` VARCHAR(50) DEFAULT NULL,
  `Amount` DECIMAL(10,2) DEFAULT NULL,
  PRIMARY KEY (`Booking_No`),
  KEY `passno_fk11` (`Pass_no`),
  KEY `bus_regno_fk11` (`Bus_RegNo`),
  CONSTRAINT `passno_fk11` FOREIGN KEY (`Pass_no`) REFERENCES `passenger` (`Pass_No`) ON DELETE CASCADE,
  CONSTRAINT `bus_regno_fk11` FOREIGN KEY (`Bus_RegNo`) REFERENCES `buses` (`Bus_RegNo`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `buses` */
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `buses`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE `buses` (
  `Bus_RegNo` VARCHAR(50) NOT NULL,
  `BusNo` INT(50) DEFAULT NULL,
  `Model` VARCHAR(50) DEFAULT NULL,
  `Capacity` INT(3) DEFAULT NULL,
  `DateBought` DATE DEFAULT NULL,
  `Insurance_status` VARCHAR(100) DEFAULT NULL,
  `Date_Insured` DATE DEFAULT NULL,
  `Insurance_Expiry` DATE DEFAULT NULL,
  PRIMARY KEY (`Bus_RegNo`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `emp` */
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `emp`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE `emp` (
  `empNo` INT(4) NOT NULL,
  `Sname` VARCHAR(25) DEFAULT NULL,
  `Fname` VARCHAR(25) DEFAULT NULL,
  `Lname` VARCHAR(25) DEFAULT NULL,
  `Gender` VARCHAR(10) DEFAULT NULL,
  `DOB` DATE DEFAULT NULL,
  `Designation` VARCHAR(50) DEFAULT NULL,
  `Telephone` INT(10) DEFAULT NULL,
  `E_Mail` VARCHAR(50) DEFAULT NULL,
  `Address` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`empNo`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `passenger` */
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `passenger`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE `passenger` (
  `Pass_No` INT(4) NOT NULL,
  `Pass_Name` VARCHAR(100) DEFAULT NULL,
  `Address` VARCHAR(100) DEFAULT NULL,
  `Tel_no` INT(10) DEFAULT NULL,
  `Date_of_Travels` DATE DEFAULT NULL,
  `Depot` VARCHAR(25) DEFAULT NULL,
  `To_place` VARCHAR(50) DEFAULT NULL,
  `Pay_status` VARCHAR(25) DEFAULT NULL,
  `booked_status` VARCHAR(25) DEFAULT NULL,
  PRIMARY KEY (`Pass_No`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `payment` */
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `payment`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE `payment` (
  `Payment_no` INT(4) NOT NULL,
  `Pass_No` INT(4) DEFAULT NULL,
  `Pass_name` VARCHAR(50) DEFAULT NULL,
  `Payment_mode` VARCHAR(25) DEFAULT NULL,
  `Date_payment` DATE DEFAULT NULL,
  `amount_paid` DECIMAL(10,2) DEFAULT NULL,
  `received_by` VARCHAR(25) DEFAULT NULL,
  PRIMARY KEY (`Payment_no`),
  KEY `pass_no_fk` (`Pass_No`),
  CONSTRAINT `pass_no_fk` FOREIGN KEY (`Pass_No`) REFERENCES `passenger` (`Pass_No`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `route` */
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `route`;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE `route` (
  `Route_No` INT(4) NOT NULL,
  `RouteName` VARCHAR(100) DEFAULT NULL,
  `Depot` VARCHAR(100) DEFAULT NULL,
  `Destination` VARCHAR(100) DEFAULT NULL,
  `Distance` VARCHAR(20) DEFAULT NULL,
  `Fare_charged` DECIMAL(10,2) DEFAULT NULL,
  PRIMARY KEY (`Route_No`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `schedules` */

DROP TABLE IF EXISTS `schedules`;

CREATE TABLE `schedules` (
  `Bus_no` INT(5) DEFAULT NULL,
  `Bus_reg` VARCHAR(25) DEFAULT NULL,
  `Route_no` INT(4) DEFAULT NULL,
  `Route_name` VARCHAR(50) DEFAULT NULL,
  `empno` INT(4) DEFAULT NULL,
  `Driver_name` VARCHAR(50) DEFAULT NULL,
  `Trip_no` INT(4) DEFAULT NULL,
  `Date_Scheduled` DATE DEFAULT NULL,
  `Dept_time` VARCHAR(10) DEFAULT NULL,
  KEY `bus_regno_fk1` (`Bus_reg`),
  KEY `route_no_fk1` (`Route_no`),
  KEY `empno_fk1` (`empno`),
  KEY `trip_no_fk1` (`Trip_no`),
  CONSTRAINT `bus_regno_fk1` FOREIGN KEY (`Bus_reg`) REFERENCES `buses` (`Bus_RegNo`),
  CONSTRAINT `empno_fk1` FOREIGN KEY (`empno`) REFERENCES `emp` (`empNo`),
  CONSTRAINT `route_no_fk1` FOREIGN KEY (`Route_no`) REFERENCES `route` (`Route_No`)
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `trips` */

DROP TABLE IF EXISTS `trips`;

CREATE TABLE `trips` (
  `Trip_no` INT(5) NOT NULL,
  `Bus_RegNo` VARCHAR(50) DEFAULT NULL,
  `Route_no` INT(4) DEFAULT NULL,
  `S_Date` DATE DEFAULT NULL,
  PRIMARY KEY (`Trip_no`),
  KEY `Bus_RegNO_FK` (`Bus_RegNo`),
  CONSTRAINT `Bus_RegNO_FK` FOREIGN KEY (`Bus_RegNo`) REFERENCES `buses` (`Bus_RegNo`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `name` VARCHAR(100) DEFAULT NULL,
  `category` VARCHAR(20) DEFAULT NULL,
  `username` VARCHAR(50) DEFAULT NULL,
  `password` VARCHAR(50) DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/*Table structure for table `validator` */

DROP TABLE IF EXISTS `validator`;

CREATE TABLE `validator` (
  `Bus_No` VARCHAR(50) DEFAULT NULL,
  `DriverNo` VARCHAR(50) DEFAULT NULL,
  `RouteNo` VARCHAR(50) DEFAULT NULL,
  `Date_Schedule` DATE DEFAULT NULL,
  `Trip_No` INT(10) DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=latin1;

/* Trigger structure for table `route` */

DELIMITER $$

CREATE TRIGGER BUS_FARE_CHARGES_CHECK BEFORE INSERT ON ROUTE
    FOR EACH ROW BEGIN
           IF NEW.FARE_CHARGED < 0 THEN
               SET NEW.FARE_CHARGED = 0;
           ELSEIF NEW.FARE_CHARGED > 0 THEN
               SET NEW.FARE_CHARGED = NEW.FARE_CHARGED + (NEW.FARE_CHARGED*0.18);
           END IF;
       END;
$$

DELIMITER ;