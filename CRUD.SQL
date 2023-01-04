
-- https://github.com/kevinmartintech/sp_CRUDGen/blob/main/sp_CRUDGen.sql
-- 2023-01-02
-- Version 1.0.0.0 


use CrudSql

Drop Table [co_detFactura]
Drop Table [co_cabFactura]
Drop Table tm_Producto
Drop Table tm_Cliente

Drop PROCEDURE [spu_Consulta_Cliente_Td]
Drop PROCEDURE [spu_Consulta_Producto_Td]
Drop PROCEDURE [spu_Consulta_CabFactura_Td]
Drop PROCEDURE [spu_Consulta_DetFactura_Td]
---------------------------------------------------------------------------------------

CREATE TABLE tm_Cliente(
	[id_tmc_Cliente] [int] IDENTITY(1,1) NOT NULL, -- Id de Cliente
	[ds_tmc_Cliente] [varchar](100) NULL,		   -- Descripcion del cliente
	[tmc_ruc] [char](12) NULL,					   -- Numero de Ruc del Cliente
	[tmc_Direccion] [varchar](100) NULL,			   -- Direccion del Cliente
	[tmc_FechaRegistro] datetime				   -- Fecha de registro del Sistema
)
-- Crear un indice de la tabla
ALTER TABLE tm_Cliente
   ADD CONSTRAINT PK_tm_Cliente PRIMARY KEY CLUSTERED ([id_tmc_Cliente] ASC);
---------------------------------------------------------------------------------------

CREATE TABLE [tm_Producto] (
  [id_tmp_Producto] [int] IDENTITY(1,1) NOT NULL,  -- Id del producto 
  [ds_tmp_Producto] varchar(50),				   -- Descripcion del Producto
  [ds_tmp_Precio] decimal(10,3)					   -- Precio del Producto
)
ALTER TABLE tm_Producto
   ADD CONSTRAINT PK_tm_Producto PRIMARY KEY CLUSTERED ([id_tmp_Producto] ASC);
---------------------------------------------------------------------------------------

CREATE TABLE [co_cabFactura] (
  [id_co_cabFactura]  [int] IDENTITY(1,1) NOT NULL, -- Id de la cabecera de la factura
  [cocf_doc_serie] char(4),							-- Serie Doc. Comprobante
  [cocf_doc_tipo] char(2),							-- Tipo Doc. Comprobante
  [cocf_doc_num] char(10),							-- Num. Doc. Comprobante
  [id_tmc_Cliente] int,								-- Id del Cliente
  [cocf_FechaRegistro] datetime						-- Fecha de Registro 
)
ALTER TABLE [co_cabFactura]
   ADD CONSTRAINT PK_co_cabFactura PRIMARY KEY CLUSTERED ([id_co_cabFactura] ASC);
---------------------------------------------------------------------------------------

CREATE TABLE [co_detFactura] (
  [id_co_detFactura]  [int] IDENTITY(1,1) NOT NULL,  -- Id del detalle del comprobante
  [id_co_cabFactura] int,							 -- Id del la cabecera de la factura 
  [id_tmp_Producto] int,							 -- Id del producto 
  [codf_CantUnidades] decimal(13,2),				 -- Cantidad en Unidades
  [codf_Precio] decimal(13,2),						 -- Precio del Producto 
  [codf_TotalIGV] decimal(13,2),					 -- Total del IGV 
  [codf_Total] decimal(13,2)						 -- Total del Cant*Prec / IGV
)
ALTER TABLE [co_detFactura]
   ADD CONSTRAINT PK_co_detFactura PRIMARY KEY CLUSTERED ([id_co_detFactura] ASC);
---------------------------------------------------------------------------------------

-- Relacion Foranea 
ALTER TABLE [co_cabFactura] ADD FOREIGN KEY ([id_tmc_Cliente]) REFERENCES [tm_Cliente] ([id_tmc_Cliente])
ALTER TABLE [co_detFactura] ADD FOREIGN KEY ([id_tmp_Producto]) REFERENCES [tm_Producto] ([id_tmp_Producto])
ALTER TABLE [co_detFactura] ADD FOREIGN KEY ([id_co_cabFactura]) REFERENCES [co_cabFactura] ([id_co_cabFactura])


-- Select * from [tm_Cliente]

Insert into [tm_Cliente] ( ds_tmc_Cliente,	tmc_Direccion,	tmc_ruc, tmc_FechaRegistro)
Values ('Rímac Seguros','Av. Paseo de la República 3505, San Isidro. Lima','20100055600',getdate() ),
('Interbank','Av. Carlos Villarán N° 140, Urb. Santa Catalina','20100033448',getdate()),
('Minera Antamina','Av. El Derby 55, Santiago de Surco','20100021243',getdate()),
('Ferreyros S.A.','Jr. CRISTOBAL DE PERALTA NRO. 820 URB. SAN IDELFONSO','20100028698',getdate()),
('Alicorp S.A.','AV. ARGENTINA NRO. 4793 URB. PARQUE INDUSTRIAL','20100055237',getdate())

-- Alter table [tm_Cliente] alter column [ds_tmc_Cliente] varchar(100) 
-- Alter table [tm_Cliente] alter column [tmc_Direccion] varchar(100) 

--Select * from tm_Producto
Insert into tm_Producto ( ds_tmp_Producto,	ds_tmp_Precio )
Values
('Fibras sintéticas',  9.16),
('Productos de fieltro natural',  5.17),
('Tinción, estampado y acabado',  2.18),
('Generos textiles no tejidos',  3.21),
('Tejido y tricotado',  7.23),
('Alfombras y moquetas',  10.25)


-- Select * from [co_cabFactura]
Insert into [co_cabFactura] ( cocf_doc_serie, cocf_doc_tipo, cocf_doc_num, id_tmc_Cliente, cocf_FechaRegistro )
Values
( '0001', 'FA', '0000001', 1, GETDATE() ),
( '0001', 'FA', '0000002', 2, GETDATE() ),
( '0001', 'FA', '0000003', 3, GETDATE() ),
( '0001', 'FA', '0000004', 4, GETDATE() ),
( '0001', 'FA', '0000005', 5, GETDATE() ),
( '0001', 'FA', '0000006', 1, GETDATE() )


-- Select * from [co_detFactura]

Insert into [co_detFactura]
( id_co_cabFactura, id_tmp_Producto, codf_CantUnidades, codf_Precio, codf_TotalIGV, codf_Total )
Values
( 1,1,3,1,1,1),
( 1,3,4,1,1,1),
( 2,6,2,1,1,1),
( 2,2,1,1,1,1),
( 3,4,2,1,1,1),
( 3,5,3,1,1,1),
( 3,1,4,1,1,1),
( 4,3,3,1,1,1),
( 4,2,2,1,1,1),
( 5,4,1,1,1,1),
( 5,5,2,1,1,1),
( 6,6,3,1,1,1),
( 6,1,2,1,1,1)

go

--------------------------------------
-- STORED PROCEDURES DE CONSULTAS 
--------------------------------------

-- Exec [spu_Sel_Cliente_Td]
CREATE PROCEDURE [spu_Sel_Cliente_Td]
AS
	BEGIN
		Select id_tmc_Cliente, ds_tmc_Cliente,	tmc_ruc,	tmc_Direccion  from tm_Cliente
	End 
go
-- Exec [spu_Sel_Producto_Td]
CREATE PROCEDURE [spu_Sel_Producto_Td]
AS
	BEGIN
		Select id_tmp_Producto,	ds_tmp_Producto, ds_tmp_Precio  from tm_Producto
	End 
go
-- Exec [spu_Sel_CabFactura_Td]
CREATE PROCEDURE [spu_Sel_CabFactura_Td]
AS
	BEGIN
	
		Select 
		cFac.cocf_doc_serie, 
		cFac.cocf_doc_tipo, 
		cFac.cocf_doc_num,
		mCli.ds_tmc_Cliente
		from co_cabFactura cFac
		inner join tm_Cliente mCli on mCli.id_tmc_Cliente = cFac.id_tmc_Cliente

	End 

go
-- Exec [spu_Sel_DetFactura_Td]
CREATE PROCEDURE [spu_Sel_DetFactura_Td]
AS
	BEGIN

		Select 
		dFac.id_co_detFactura, 
		cFac.cocf_doc_serie+'-'+cFac.cocf_doc_tipo+'-'+cFac.cocf_doc_num as Documento,
		mPro.id_tmp_Producto,
		mPro.ds_tmp_Producto,	
		dFac.codf_CantUnidades,
		dFac.codf_Precio,
		dFac.codf_TotalIGV,
		dFac.codf_Total
		from co_detFactura dFac
		inner join co_cabFactura cFac
		on cFac.id_co_cabFactura = dFac.id_co_cabFactura
		inner join tm_Producto mPro on mPro.id_tmp_Producto = dFac.id_tmp_Producto
	End 
go


-- exec spu_ins_tm_Cliente 'Papelera Naciona S.A.','Calle Luisa Beasujeur 2450, LIma','20100047641'

CREATE PROCEDURE [dbo].[spu_ins_tm_Cliente] (  
     @ds_tmc_Cliente varchar(100) = NULL  
    ,@tmc_ruc char(12) = NULL  
    ,@tmc_Direccion varchar(100) = NULL  
    ,@tmc_FechaRegistro datetime = NULL  
)  
AS  
    BEGIN  
        SET NOCOUNT, XACT_ABORT ON;  
  
        /* Create temporary table to store the output */  
        CREATE TABLE #Output (  
             [id_tmc_Cliente] int NULL  
            ,[ds_tmc_Cliente] varchar(100) NULL  
            ,[tmc_ruc] char(12) NULL  
            ,[tmc_Direccion] varchar(100) NULL  
            ,[tmc_FechaRegistro] datetime NULL  
        );  
  
        /* Perform the create (insert) */  
        INSERT INTO [dbo].[tm_Cliente] (  
                [ds_tmc_Cliente]  
               ,[tmc_ruc]  
               ,[tmc_Direccion]  
               ,[tmc_FechaRegistro]  
        )  
        OUTPUT  
                Inserted.[id_tmc_Cliente]  
               ,Inserted.[ds_tmc_Cliente]  
               ,Inserted.[tmc_ruc]  
               ,Inserted.[tmc_Direccion]  
               ,Inserted.[tmc_FechaRegistro]  
        INTO #Output (  
                [id_tmc_Cliente]  
               ,[ds_tmc_Cliente]  
               ,[tmc_ruc]  
               ,[tmc_Direccion]  
               ,[tmc_FechaRegistro]  
        )  
        VALUES (  
                @ds_tmc_Cliente  
               ,@tmc_ruc  
               ,@tmc_Direccion  
               ,@tmc_FechaRegistro  
        );  
  
        /* Select the inserted row from the output temporary table to return */  
        SELECT  
             [id_tmc_Cliente]  
            ,[ds_tmc_Cliente]  
            ,[tmc_ruc]  
            ,[tmc_Direccion]  
            ,[tmc_FechaRegistro]  
        FROM  
            #Output;  
  
    END;  


CREATE PROCEDURE [dbo].[spu_ins_tm_Producto] (  
     @ds_tmp_Producto varchar(50) = NULL  
    ,@ds_tmp_Precio decimal(10, 3) = NULL  
)  
AS  
    BEGIN  
        SET NOCOUNT, XACT_ABORT ON;  
  
        /* Create temporary table to store the output */  
        CREATE TABLE #Output (  
             [id_tmp_Producto] int NULL  
            ,[ds_tmp_Producto] varchar(50) NULL  
            ,[ds_tmp_Precio] decimal(10, 3) NULL  
        );  
  
        /* Perform the create (insert) */  
        INSERT INTO [dbo].[tm_Producto] (  
                [ds_tmp_Producto]  
               ,[ds_tmp_Precio]  
        )  
        OUTPUT  
                Inserted.[id_tmp_Producto]  
               ,Inserted.[ds_tmp_Producto]  
               ,Inserted.[ds_tmp_Precio]  
        INTO #Output (  
                [id_tmp_Producto]  
               ,[ds_tmp_Producto]  
               ,[ds_tmp_Precio]  
        )  
        VALUES (  
                @ds_tmp_Producto  
               ,@ds_tmp_Precio  
        );  
  
        /* Select the inserted row from the output temporary table to return */  
        SELECT  
             [id_tmp_Producto]  
            ,[ds_tmp_Producto]  
            ,[ds_tmp_Precio]  
        FROM  
            #Output;  
  
    END;  
    
    
    
CREATE PROCEDURE [dbo].[spu_del_tm_Cliente] (  
     @id_tmc_Cliente int  
)  
AS  
    BEGIN  
  
        SET NOCOUNT, XACT_ABORT ON;  
  
        DELETE FROM  
            [dbo].[tm_Cliente]  
        WHERE  
            [id_tmc_Cliente] = @id_tmc_Cliente;  
    END;  
    
    

CREATE PROCEDURE [dbo].[spu_del_tm_Producto] (  
     @id_tmp_Producto int  
)  
AS  
    BEGIN  
  
        SET NOCOUNT, XACT_ABORT ON;  
  
        DELETE FROM  
            [dbo].[tm_Producto]  
        WHERE  
            [id_tmp_Producto] = @id_tmp_Producto;  
    END;      
