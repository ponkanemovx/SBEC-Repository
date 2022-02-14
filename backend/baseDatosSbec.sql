-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema bd_sbec
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bd_sbec` ;

-- -----------------------------------------------------
-- Schema bd_sbec
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bd_sbec` DEFAULT CHARACTER SET utf8 ;
USE `bd_sbec` ;

-- -----------------------------------------------------
-- Table `bd_sbec`.`domicilio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`domicilio` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`domicilio` (
  `id_domicilio` INT(11) NOT NULL,
  `calle` VARCHAR(25) NOT NULL,
  `numero_exterior` SMALLINT(5) NOT NULL,
  `colonia` VARCHAR(25) NOT NULL,
  `municipio` VARCHAR(25) NOT NULL,
  `ciudad` VARCHAR(25) NOT NULL,
  `estado` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id_domicilio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`informacionpersonal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`informacionpersonal` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`informacionpersonal` (
  `id_informacion` INT(11) NOT NULL,
  `curp` VARCHAR(20) NOT NULL,
  `nombres` VARCHAR(20) NOT NULL,
  `apellido_paterno` VARCHAR(15) NOT NULL,
  `apellido_materno` VARCHAR(15) NOT NULL,
  `rfc` VARCHAR(14) NOT NULL,
  `nss` BIGINT(12) NOT NULL,
  `fecha_nacimiento` DATETIME NOT NULL,
  `telefono` INT(11) NULL DEFAULT NULL,
  `correo` VARCHAR(45) NULL DEFAULT NULL,
  `Domicilio_id_domicilio` INT(11) NOT NULL,
  PRIMARY KEY (`id_informacion`),
  CONSTRAINT `fk_InformacionPersonal_Domicilio1`
    FOREIGN KEY (`Domicilio_id_domicilio`)
    REFERENCES `bd_sbec`.`domicilio` (`id_domicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`roles` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`roles` (
  `id_rol` TINYINT(2) NOT NULL,
  `nombre_rol` VARCHAR(15) NULL DEFAULT NULL,
  PRIMARY KEY (`id_rol`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`usuarios` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`usuarios` (
  `nombre_usuario` VARCHAR(15) NOT NULL,
  `contrasena` VARCHAR(30) NOT NULL,
  `estado` ENUM('activa', 'inactiva') NULL DEFAULT NULL,
  `InformacionPersonal_id_informacion` INT(11) NOT NULL,
  `roles_id_rol` TINYINT(2) NOT NULL,
  PRIMARY KEY (`nombre_usuario`),
  CONSTRAINT `fk_Usuarios_InformacionPersonal1`
    FOREIGN KEY (`InformacionPersonal_id_informacion`)
    REFERENCES `bd_sbec`.`informacionpersonal` (`id_informacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuarios_roles1`
    FOREIGN KEY (`roles_id_rol`)
    REFERENCES `bd_sbec`.`roles` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`clientes` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`clientes` (
  `id_cliente` INT(11) NOT NULL,
  `id_usuario` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id_usuario`, `id_cliente`),
  CONSTRAINT `fk_clientes_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `bd_sbec`.`usuarios` (`nombre_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`cuentas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`cuentas` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`cuentas` (
  `id_cuenta` INT(11) NOT NULL,
  `saldo` DECIMAL(10,0) NULL DEFAULT NULL,
  `tipo_cuenta` VARCHAR(10) NULL DEFAULT NULL,
  `clientes_id_cliente` INT(11) NOT NULL,
  PRIMARY KEY (`id_cuenta`, `clientes_id_cliente`),
  CONSTRAINT `fk_cuentas_clientes1`
    FOREIGN KEY (`clientes_id_cliente`)
    REFERENCES `bd_sbec`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`empleados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`empleados` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`empleados` (
  `id_empleado` INT(11) NOT NULL,
  `id_usuario` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id_empleado`, `id_usuario`),
  CONSTRAINT `fk_empleados_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `bd_sbec`.`usuarios` (`nombre_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bd_sbec`.`movimientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bd_sbec`.`movimientos` ;

CREATE TABLE IF NOT EXISTS `bd_sbec`.`movimientos` (
  `id_movimiento` INT(11) NOT NULL,
  `monto` DECIMAL(10,0) NULL DEFAULT NULL,
  `tipo` VARCHAR(15) NULL DEFAULT NULL,
  `fecha` DATETIME NULL DEFAULT NULL,
  `Cuentas_id_cuenta` INT(11) NOT NULL,
  PRIMARY KEY (`id_movimiento`),
  CONSTRAINT `fk_Movimientos_Cuentas1`
    FOREIGN KEY (`Cuentas_id_cuenta`)
    REFERENCES `bd_sbec`.`cuentas` (`id_cuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
