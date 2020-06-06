/*
    NOTA: Se puede ejecutar el SCRIPT completo, este archivo contiene todo el script para crear la base, poblar las tablas y realizar las consultas.
*/

/* 
    Requerimientos:
    Necesitamos registrar la facturación de los productos de la zapatería "El zapato roto". Necesitamos poder registrar productos, clientes, facturas e inventario.

    Los productos tendrán como mínimo: Nombre, presentación, valor.
    Los clientes tendrán como mínimo: Identificación, nombre, país.
    El inventario tendrá como mínimo: producto, tipo de movimiento (entrada o salida), fecha, cantidad.
    La facturación debe tener como mínimo: la información del cliente, los productos comprados, impuestos, descuentos, valor a pagar.

    |____________productos__________________|___________________clientes________________|_________________________inventario________________________________|_________________________________________________________facturación_______________________________________________________________________________|
    |Nombre  |   Presentación    |   Valor  |   Identificación  |   nombre  |   país    |   producto(nombre, tipo mov, fecha, cantidad)    |   tipo de movimiento  |   fecha   |   cantidad    |   Identificación(cliente)  |   nombre(cliente)  |   país(cliente)    |    Nombre(Producto)    |   impuestos   |   descuentos  |   valor a pagar   |


    ************************************************************************************************************************************************************************
    Primera Forma Normal (FN1)
    Se deben "atomizar" los datos lo mayor posible, esto es que, los datos (columnas) que se puedan dividir en otros datos individuales, se deben dividir
    Evitar repetir datos (columnas) separando los datos que son dependientes entre sí en tablas independientes. 
        "Aislamiento de los datos repetitivos de una tabla en otra independiente"

    
    1) Las tablas originales divididas quedan de la siguiente forma

    |____________productos__________________|
    |Nombre  |   Presentación    |   Valor  |

    //Se agrega una tabla catálogo adicional para la presentación 
    |_________________________TipoPresentacion__________________|
    |   Número de Presentación   |   Descripción de Presentación|

    |___________________clientes________________|
    |   Identificación  |   nombre  |   país    |

    //Se agrega una tabla catalogo adicional para país
    |__________________Pais_____________|
    |   IdPais   |   Descripción de Pais|



    |_________________________inventario________________________________|
    |   idProducto    |   tipo de movimiento  |   fecha   |   cantidad    |


    |_________________________________________________________facturación_______________________________________________________________________________|
    |   Identificación(cliente)  |   nombre(cliente)  |   país(cliente)    |    Nombre(Producto)    |   impuestos   |   descuentos  |   valor a pagar   |


    2) Dividiendo los datos que se pueden dividir quedan de la siguiente forma:

    |_____________productos____________________|
    |   Nombre  |   Presentación    |   Valor  |

    |_________________________TipoPresentacion__________________|
    |   Número de Presentación   |   Descripción de Presentación|


    |_______________________________clientes______________________________________|
    |   Identificación  |   nombre  |   Apellido 1  |   Apellido 2    |   país    |

    |__________________Pais_____________|
    |   IdPais   |   Descripción de Pais|



    |_________________________inventario________________________________|
    |   idProducto    |   tipo de movimiento  |   fecha   |   cantidad    |

    //Se agrega una tabla catálogo adicional para el tipo de movimiento que es variable 
    |___________________________TipoMovimiento______________________________|
    |   Número de Tipo de Movimiento   |   Descripción de Tipo de Movimiento|


    |_________________________________________________________facturación_______________________________________________________________________________|
    |   Identificación(cliente)  |   nombre(cliente)  |   país(cliente)    |    Nombre(Producto)    |   impuestos   |   descuentos  |   valor a pagar   |




    ************************************************************************************************************************************************************************
    Segunda Forma Normal (FN2)
    Que no existan dependencias funcionales parciales: todos los valores de las columnas de una fila deben depender de la clave primaria de dicha fila

    
    |_________________________productos________________________|
    |   IdProducto  |   Nombre  |   Presentación    |   Valor  |

    |_________________TipoPresentacion______________________|
    |   IdTipoPresentación   |   Descripción de Presentación|

    |______________________________________clientes_______________________________________________|
    |   IdCliente   |   Identificación  |   nombre  |   Apellido 1  |   Apellido 2    |   país    |

    |__________________Pais_____________|
    |   IdPais   |   Descripción de Pais|



    |______________________inventario_____________________________________|
    |   IdProducto    |   tipo de movimiento  |   fecha   |   cantidad    |

    |___________________________TipoMovimiento____________________________|
    |   IdTipoMovimientoMovimiento   |   Descripción de Tipo de Movimiento|


    |__________________________________________facturación______________________________________________|
    |   IdFactura  |   IdCliente  |   IdProducto    |   impuestos   |   descuentos  |   valor a pagar   |



    ************************************************************************************************************************************************************************
    Tercera Forma Normal (FN3)
    No deben existir dependencias transitivas entre las columnas de una tabla
    Las columnas que no forman parte de la clave primaria deben depender sólo de la clave, nunca de otra columna no clave. 

    |_________________________productos__________________________|
    |   IdProducto  |   Nombre  |   IdPresentación    |   Valor  |

    |_________________TipoPresentacion______________________|
    |   IdTipoPresentación   |   Descripción de Presentación|


    |______________________________________clientes_______________________________________________|
    |   IdCliente   |   Identificación  |   nombre  |   Apellido 1  |   Apellido 2    |   país    |

    |__________________Pais_____________|
    |   IdPais   |   Descripción de Pais|



    |____________________________inventario_______________________________|
    |   IdProducto    |   tipo de movimiento  |   fecha   |   cantidad    |

    |___________________________tipoMovimiento____________________________|
    |   IdTipoMovimientoMovimiento   |   Descripción de Tipo de Movimiento|


    |__________________________________________facturación______________________________________________|
    |   IdFactura  |   IdCliente  |   IdProducto    |   impuestos   |   descuentos  |   valor a pagar   |

    Ademas se agrega una tabla relacional Muchos a Muchos para vincular el registro de facturas con el inventario (debido a que una factura puede tener mas de un producto y los productos pueden estar en varias facturas dependiendo del movimiento realizado)


    
*/

-- ***************************************************************************************************************
-- ***************************************************************************************************************
-- ************************************** QUERY PARA CREAR LA BASE DE DATOS***************************************
-- ***************************************************************************************************************
-- ***************************************************************************************************************

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema elZapatoRoto
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `elZapatoRoto` ;

-- -----------------------------------------------------
-- Schema elZapatoRoto
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `elZapatoRoto` DEFAULT CHARACTER SET utf8 ;
USE `elZapatoRoto` ;

-- -----------------------------------------------------
-- Table `elZapatoRoto`.`tipoPresentacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`tipoPresentacion` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`tipoPresentacion` (
  `idTipoPresentacion` INT NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  PRIMARY KEY (`idTipoPresentacion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`productos` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`productos` (
  `idProducto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL,
  `idTipoPresentacion` INT NOT NULL,
  `valor` DECIMAL(20,2) NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  PRIMARY KEY (`idProducto`),
  INDEX `idTipoPresentacion_idx` (`idTipoPresentacion` ASC) VISIBLE,
  CONSTRAINT `idTipoPresentacionfk`
    FOREIGN KEY (`idTipoPresentacion`)
    REFERENCES `elZapatoRoto`.`tipoPresentacion` (`idTipoPresentacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`pais`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`pais` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`pais` (
  `idPais` INT NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  PRIMARY KEY (`idPais`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`clientes` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`clientes` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `identificacion` VARCHAR(45) NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido1` VARCHAR(45) NULL,
  `apellido2` VARCHAR(45) NULL,
  `idPais` INT NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  PRIMARY KEY (`idCliente`),
  INDEX `idPais_idx` (`idPais` ASC) VISIBLE,
  CONSTRAINT `idPaisfk`
    FOREIGN KEY (`idPais`)
    REFERENCES `elZapatoRoto`.`pais` (`idPais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`tipoMovimiento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`tipoMovimiento` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`tipoMovimiento` (
  `idTipoMovimiento` INT NOT NULL,
  `descripcion` VARCHAR(45) NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  PRIMARY KEY (`idTipoMovimiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`inventario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`inventario` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`inventario` (
  `idInventario` INT NOT NULL AUTO_INCREMENT,
  `idProducto` INT NOT NULL,
  `idTipoMovimiento` INT NULL,
  `fecha` DATETIME NULL,
  `cantidad` INT NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  INDEX `idTipoMovimiento_idx` (`idTipoMovimiento` ASC) INVISIBLE,
  PRIMARY KEY (`idInventario`),
  CONSTRAINT `idTipoMovimientofk`
    FOREIGN KEY (`idTipoMovimiento`)
    REFERENCES `elZapatoRoto`.`tipoMovimiento` (`idTipoMovimiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idProductofk`
    FOREIGN KEY (`idProducto`)
    REFERENCES `elZapatoRoto`.`productos` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`facturacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`facturacion` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`facturacion` (
  `idFactura` INT NOT NULL AUTO_INCREMENT,
  `claveFactura` VARCHAR(45) NOT NULL,
  `idCliente` INT NOT NULL,
  `idProducto` INT NOT NULL,
  `impuestos` DECIMAL(20,2) NOT NULL,
  `descuentos` DECIMAL(20,2) NULL,
  `valorPago` DECIMAL(10,2) NOT NULL,
  `fechaCreacion` DATETIME NULL,
  `fechaModificacion` DATETIME NULL,
  PRIMARY KEY (`idFactura`),
  INDEX `idCliente_idx` (`idCliente` ASC) VISIBLE,
  INDEX `idProducto_idx` (`idProducto` ASC) VISIBLE,
  CONSTRAINT `idClientefk`
    FOREIGN KEY (`idCliente`)
    REFERENCES `elZapatoRoto`.`clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idProductoFacfk`
    FOREIGN KEY (`idProducto`)
    REFERENCES `elZapatoRoto`.`productos` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elZapatoRoto`.`facturacionSalidaInventario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `elZapatoRoto`.`facturacionSalidaInventario` ;

CREATE TABLE IF NOT EXISTS `elZapatoRoto`.`facturacionSalidaInventario` (
  `idInventario` INT NOT NULL,
  `idFactura` INT NOT NULL,
  INDEX `INDEX` (`idFactura` ASC, `idInventario` ASC) VISIBLE,
  INDEX `idInventariofk_idx` (`idInventario` ASC) VISIBLE,
  CONSTRAINT `idInventariofk`
    FOREIGN KEY (`idInventario`)
    REFERENCES `elZapatoRoto`.`inventario` (`idInventario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idFacturarfk`
    FOREIGN KEY (`idFactura`)
    REFERENCES `elZapatoRoto`.`facturacion` (`idFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- procedure sp_registra_venta
-- -----------------------------------------------------
USE `elzapatoroto`;
DROP procedure IF EXISTS `elzapatoroto`.`sp_registra_venta`;

DELIMITER $$
USE `elzapatoroto`$$
CREATE PROCEDURE `sp_registra_venta`(IN p_idCliente INT, IN p_idProducto INT, IN p_impuestos DECIMAL, IN p_descuentos DECIMAL, IN p_fecha DATETIME, IN p_cantidad INT, IN p_claveFactura VARCHAR(100))
BEGIN

	DECLARE inventarioId, facturacionId INT;
	DECLARE valorProd, precioSinDescuento, precioPago DECIMAL(20,2);

  

	DECLARE exit handler for sqlexception 
	BEGIN
	-- ERROR
	-- ------------------------------------------------------------------------------------ 
	-- select "error message '%s' and errorno '%d'"------- this part in not working
	-- ------------------------------------------------------------------------------------ 
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
	ROLLBACK;
	END;

	START TRANSACTION;
		INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(p_idProducto,2,p_fecha,p_cantidad,now());
		-- Obtener el ultimo ID ingresado
		SET inventarioId = LAST_INSERT_ID();
		
		SELECT valor INTO valorProd from productos where idProducto = p_idProducto;
		
		SET precioSinDescuento = p_cantidad * valorProd;
		SET precioPago = precioSinDescuento - p_descuentos;
		INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE(p_claveFactura,p_idCliente,p_idProducto,p_impuestos,p_descuentos, precioPago,now());
		-- Obtener el ultimo ID ingresado
		SET facturacionId = LAST_INSERT_ID();
		
		INSERT INTO facturacionSalidaInventario (idInventario, idFactura) VALUE(inventarioId, facturacionId);
	COMMIT;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;







-- ***************************************************************************************************************
-- ***************************************************************************************************************
-- ************************************** QUERYS PARA DML (POBLADO DE LA BASE DE DATOS)***************************
-- ***************************************************************************************************************
-- ***************************************************************************************************************


-- INSERTS tipoPresentacion
INSERT INTO tipoPresentacion(idTipoPresentacion, descripcion, fechaCreacion) VALUE(1, 'BOTA', now());
INSERT INTO tipoPresentacion(idTipoPresentacion, descripcion, fechaCreacion) VALUE(2, 'ZAPATO', now());
INSERT INTO tipoPresentacion(idTipoPresentacion, descripcion, fechaCreacion) VALUE(3, 'TENIS', now());
INSERT INTO tipoPresentacion(idTipoPresentacion, descripcion, fechaCreacion) VALUE(4, 'TACON', now());


-- INSERTS productos
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('NIKE',1,20,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('NIKE',2,30,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('NIKE',3,40,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('NIKE',4,10,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('DOROTHY GAYNOR',1,60,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('DOROTHY GAYNOR',2,70,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('DOROTHY GAYNOR',3,80,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('DOROTHY GAYNOR',4,90,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CONVERSE',1,20,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CONVERSE',2,30,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CONVERSE',3,40,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CONVERSE',4,50,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CHARLY',1,60,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CHARLY',2,70,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CHARLY',3,20,now());
INSERT INTO productos (nombre,idTipoPresentacion,valor,fechaCreacion) VALUE('CHARLY',4,20,now());
-- select * from productos;

-- INSERT pais
INSERT INTO pais(idPais, descripcion, fechaCreacion) value(52,'MEXICO',now());
INSERT INTO pais(idPais, descripcion, fechaCreacion) value(1,'CANADA',now());
INSERT INTO pais(idPais, descripcion, fechaCreacion) value(34,'ESPAÑA',now());


-- INSERT clientes
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX140301HDF','ANGEL','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX240302HDF','JOSE','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX340303HDF','LUIS','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX440304HDF','ALBERTO','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX540305HDF','RAMON','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX640306HDF','RAUL','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX740307HDF','JORGE','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX840308HDF','SAUL','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX940309HDF','DIEGO','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX120311HDF','RICARDO','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('MX130312HDF','FABIAN','RUEDA','MANZANO',52,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('CA760301HDF','OLIVIA','RUEDA','MANZANO',1,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('CA760302HDF','EMMA','RUEDA','MANZANO',1,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('CA760303HDF','EMILY','RUEDA','MANZANO',1,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('CA760304HDF','AVA','RUEDA','MANZANO',1,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('CA760305HDF','ABIGAIL','RUEDA','MANZANO',1,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('ES340301HDF','GEORGE','RUEDA','MANZANO',34,now());
INSERT INTO clientes(identificacion,nombre,apellido1,apellido2,idPais,fechaCreacion) VALUE('ES340302HDF','MISAEL','RUEDA','MANZANO',34,now());


-- INSERT tipoMovimiento
INSERT INTO tipoMovimiento(idTipoMovimiento,descripcion,fechaCreacion) VALUE(1,'ENTRADA',NOW());
INSERT INTO tipoMovimiento(idTipoMovimiento,descripcion,fechaCreacion) VALUE(2,'SALIDA',NOW());



-- INSERT inventario
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(1,1,'2020-01-11 15:30',30,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(1,2,'2020-01-18 15:30',22,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(2,1,'2020-01-11 15:30',33,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(2,1,'2020-01-13 15:30',31,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(2,1,'2020-01-14 15:30',20,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(2,2,'2020-01-18 15:30',80,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(2,1,'2020-01-22 15:30',19,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(3,1,'2020-01-11 15:30',39,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(3,2,'2020-02-12 15:30',39,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,1,'2020-01-18 15:30',40,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,2,'2020-02-12 15:30',10,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,1,'2020-02-13 15:30',33,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,2,'2020-03-12 15:30',34,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,1,'2020-03-18 15:30',89,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,2,'2020-03-12 15:30',45,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,1,'2020-04-16 15:30',30,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(4,2,'2020-04-01 15:30',8,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(5,1,'2020-03-18 15:30',67,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(5,2,'2020-04-18 15:30',34,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,1,'2020-01-18 15:30',68,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,2,'2020-01-12 15:30',35,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,1,'2020-02-11 15:30',34,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,2,'2020-02-12 15:30',24,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,1,'2020-02-13 15:30',73,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,1,'2020-02-27 15:30',94,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,2,'2020-02-27 15:30',35,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,2,'2020-02-27 15:30',38,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,1,'2020-02-27 15:30',56,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(6,1,'2020-02-27 15:30',36,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(7,1,'2020-01-18 15:30',84,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(7,1,'2020-01-20 15:30',98,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(7,2,'2020-01-21 15:30',67,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(7,2,'2020-01-29 15:30',37,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(8,1,'2020-01-18 15:30',87,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(8,2,'2020-02-11 15:30',66,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(8,1,'2020-02-14 15:30',33,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(8,1,'2020-02-28 15:30',21,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(8,2,'2020-02-28 15:30',11,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(9,1,'2020-02-22 15:30',22,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(9,1,'2020-03-18 15:30',33,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(9,2,'2020-03-19 15:30',44,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(9,1,'2020-04-18 15:30',55,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(9,2,'2020-04-20 15:30',10,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(10,1,'2020-01-18 15:30',77,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(10,1,'2020-01-20 15:30',88,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(10,2,'2020-02-16 15:30',99,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(10,1,'2020-03-12 15:30',65,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(10,2,'2020-04-14 15:30',12,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(10,2,'2020-04-17 15:30',23,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,1,'2020-02-19 15:30',34,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,1,'2020-03-28 15:30',45,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,2,'2020-04-20 15:30',56,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,1,'2020-04-22 15:30',67,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,2,'2020-04-22 15:30',78,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,1,'2020-04-26 15:30',89,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,2,'2020-04-27 15:30',90,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(11,1,'2020-04-28 15:30',21,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(12,1,'2020-03-07 15:30',32,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(12,1,'2020-04-02 15:30',34,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(12,1,'2020-04-05 15:30',54,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,1,'2020-03-03 15:30',65,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,1,'2020-03-15 15:30',76,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,2,'2020-03-16 15:30',87,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,1,'2020-03-20 15:30',98,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,2,'2020-04-03 15:30',9,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,1,'2020-04-07 15:30',63,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(13,2,'2020-04-08 15:30',74,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(14,1,'2020-04-03 15:30',75,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(14,1,'2020-04-17 15:30',96,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(14,2,'2020-04-26 15:30',7,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(14,1,'2020-04-26 15:30',46,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(14,2,'2020-04-27 15:30',47,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-01-11 15:30',35,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-02-24 15:30',69,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-03-12 15:30',54,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-03-24 15:30',44,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-04-23 15:30',54,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-04-23 15:30',35,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-04-24 15:30',64,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-04-25 15:30',86,now());
INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(15,1,'2020-04-27 15:30',97,now());

INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(16,1,'2020-02-23 15:30',52,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(16,2,'2020-03-13 15:30',14,now());
-- INSERT INTO inventario(idProducto,idTipoMovimiento,fecha,cantidad,fechaCreacion) VALUE(16,2,'2020-04-18 15:30',15,now());





-- INSERTS 
/*
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE1',1,1,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE2',2,2,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE3',3,3,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE4',4,4,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE5',5,4,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE6',6,4,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE7',6,4,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE8',1,5,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE9',3,6,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE10',2,6,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE11',4,6,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE12',7,6,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE13',8,7,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE14',9,7,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE15',10,8,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE16',11,8,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE17',12,9,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE18',13,9,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE19',14,10,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE20',15,10,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE21',16,10,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE22',11,11,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE23',12,11,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE24',14,11,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE25',11,13,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE26',11,13,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE27',12,13,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE28',16,14,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE29',1,14,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE30',12,16,10.22,1.22,9,now());
INSERT INTO facturacion(claveFactura,idCliente,idProducto,impuestos,descuentos,valorPago,fechaCreacion) VALUE('CLAVE31',16,16,10.22,1.22,9,now());
*/




-- select * from facturacion;
-- select * from inventario;

-- INSERTS 
CALL sp_registra_venta(1, 1, 1,0,'2020-01-18 15:30', 22, 'CLAVE1');
CALL sp_registra_venta(2, 12, 2,0,'2020-01-18 15:30', 80, 'CLAVE2');
CALL sp_registra_venta(3, 3, 1,0,'2020-02-12 15:30', 39, 'CLAVE3');
CALL sp_registra_venta(4, 4, 1,1,'2020-02-12 15:30', 3, 'CLAVE4');
CALL sp_registra_venta(5, 4, 1,1,'2020-03-12 15:30', 30, 'CLAVE5');
CALL sp_registra_venta(6, 4, 1,0,'2020-03-12 15:30', 45, 'CLAVE6');
CALL sp_registra_venta(6, 4, 1,1,'2020-04-01 15:30', 8, 'CLAVE7');
CALL sp_registra_venta(1, 5, 2,1,'2020-04-18 15:30', 34, 'CLAVE8');
CALL sp_registra_venta(3, 6, 1,0,'2020-01-12 15:30', 35, 'CLAVE9');
CALL sp_registra_venta(2, 6, 1,1,'2020-02-12 15:30', 24, 'CLAVE10');
CALL sp_registra_venta(4, 6, 1,1,'2020-02-27 15:30', 35, 'CLAVE11');
CALL sp_registra_venta(7, 6, 4,1,'2020-02-27 15:30', 38, 'CLAVE12');
CALL sp_registra_venta(8, 7, 1,0,'2020-01-21 15:30', 67, 'CLAVE13');
CALL sp_registra_venta(9, 8, 1,1,'2020-01-29 15:30', 37, 'CLAVE14');
CALL sp_registra_venta(10, 8, 1,1,'2020-02-11 15:30', 66, 'CLAVE15');
CALL sp_registra_venta(11, 8, 1,1,'2020-02-28 15:30', 11, 'CLAVE16');
CALL sp_registra_venta(12, 9, 1,1,'2020-03-19 15:30', 44, 'CLAVE17');
CALL sp_registra_venta(13, 9, 1,1,'2020-04-20 15:30', 10, 'CLAVE18');
CALL sp_registra_venta(14, 10, 1,1,'2020-02-16 15:30', 99, 'CLAVE19');
CALL sp_registra_venta(15, 10, 1,1,'2020-04-14 15:30', 12, 'CLAVE20');
CALL sp_registra_venta(16, 10, 1,1,'2020-04-17 15:30', 23, 'CLAVE21');
CALL sp_registra_venta(11, 11, 1,1,'2020-04-20 15:30', 56, 'CLAVE22');
CALL sp_registra_venta(12, 11, 1,1,'2020-04-22 15:30', 78, 'CLAVE23');
CALL sp_registra_venta(14, 11, 1,1,'2020-04-27 15:30', 90, 'CLAVE24');
CALL sp_registra_venta(11, 13, 1,1,'2020-03-16 15:30', 87, 'CLAVE25');
CALL sp_registra_venta(11, 13, 1,1,'2020-04-03 15:30', 9, 'CLAVE26');
CALL sp_registra_venta(12, 13, 1,1,'2020-04-08 15:30', 74, 'CLAVE27');
CALL sp_registra_venta(16, 14, 1,1,'2020-04-26 15:30', 7, 'CLAVE28');
CALL sp_registra_venta(1, 14, 1,1,'2020-04-27 15:30', 47, 'CLAVE29');
CALL sp_registra_venta(12, 16, 1,1,'2020-03-13 15:30', 14, 'CLAVE30');
CALL sp_registra_venta(16, 16, 1,1,'2020-04-18 15:30', 15, 'CLAVE31');





-- ***************************************************************************************************************
-- ***************************************************************************************************************
-- ************************************** CONSULTAS SOLICITADAS **************************************************
-- ***************************************************************************************************************
-- ***************************************************************************************************************


/*
    1) Pobla la base de datos con suficiente información para realizar algunas consultas y crea las siguientes:

    2) Consulta la facturación de un cliente en específico.
    3) Consulta la facturación de un producto en específico.
    4) Consulta la facturación de un rango de fechas.
    5) De la facturación, consulta los clientes únicos (es decir, se requiere el listado de los clientes que han comprado por lo menos una vez, pero en el listado no se deben repetir los clientes)
    Cubo de información (opcional): Si tienes experiencia en cubos de información, diseña un cubo con la base de datos anterior donde se tenga toda la información de facturación.
*/



-- 2) Consulta la facturación de un cliente en específico.
SELECT * 
FROM 
	facturacion fact
WHERE
	fact.idCliente = 1;


-- 3) Consulta la facturación de un producto en específico.
SELECT * 
FROM 
	facturacion fact
WHERE
	fact.idProducto = 1;


-- 4) Consulta la facturación de un rango de fechas.
SELECT * 
FROM 
	facturacion fact -- Consulta principal a Facturacion
    INNER JOIN facturacionSalidaInventario factInv ON fact.idFactura = factInv.idFactura -- Vinculo a la tabla relacion hacia el Inventario que tiene la fecha 
	INNER JOIN inventario inv ON inv.idInventario = factInv.idInventario -- Vinculo a la tabla de inventario
WHERE
	DATE(inv.fecha) >= '2020-02-01' AND DATE(inv.fecha) <= '2020-03-12 15:30:00' -- Condiciones del rango d efecha
ORDER BY DATE(inv.fecha) ASC; -- Ordenamiento ascendente


-- De la facturación, consulta los clientes únicos (es decir, se requiere el listado de los clientes que han comprado por lo menos una vez, pero en el listado no se deben repetir los clientes)

-- 5) Se busca la informacion completa de los clientes; dentro del listado de clientes que han facturado
select 
    * 
from 
    clientes 
where idCliente in -- Busqueda dentro del CONJUNTO de los clientes que han facturado (es un cruce de los elementos de ambos conjuntos)
(
	-- se obtienen los clientes que han facturado
	select distinct idCliente from facturacion
);







