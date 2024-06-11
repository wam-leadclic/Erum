global class IntegrationUpsertProduct extends IntegrationModels {
    
    webservice static Response upsertProduct(RequestBodyProduct productObject) {
        Savepoint sp = Database.setSavepoint();
        try {

            Product2 product = new Product2(
                IsActive = true,
                DisplayUrl = productObject.foto,
                ERUM_External_ProductCode__c = productObject.no,
                Name = productObject.descripcionProducto,
                ERUM_Tipo__c = productObject.tipo,
                ERUM_Bloqueado__c = productObject.bloqueado,
                QuantityUnitOfMeasure = productObject.unidadMedidaVenta,
                ERUM_Cod_categoria_producto__c = productObject.codigoCategoria,
                ERUM_Cod_grupo_producto__c = productObject.codigoGrupoProducto,
                ERUM_Grupo_prod_Servicio__c = productObject.grupoProductoServicio,
                ERUM_Material_producto__c = productObject.material,
                CurrencyIsoCode = productObject.divisa,
                ERUM_Volumen__c = productObject.volumen,
                ERUM_Media_percha__c = productObject.medidaPercha,
                ERUM_Ancho_pala__c = productObject.anchoPala,
                ERUM_Peso_neto__c = productObject.pesoNeto,
                ERUM_Peso_bruto__c = productObject.pesoBruto,
                ERUM_Grupo_contable_producto__c = productObject.grupoContable,
                ERUM_Grupo_registro_IVA_prod__c = productObject.grupoRegistroIVA,
                ERUM_Grupo_contable_inventario__c = productObject.grupoContableInventario,
                ProductCode = productObject.codigoArancelario,
                ERUM_Tipo_palet__c = productObject.tipoPalet,
                ERUM_Cantidad_por_palet__c = productObject.cantidadPorPalet,
                ERUM_Stock_disponible__c = productObject.stockDisponible,
                ERUM_Largo_embalaje__c = productObject.largoEmbalaje,
                ERUM_Ancho_embalaje__c = productObject.anchoEmbalaje,
                ERUM_Alto_embalaje__c = productObject.altoEmbalaje,
                ERUM_Peso_embalaje__c = productObject.pesoEmbalaje,
                ERUM_Volumen_embalaje__c = productObject.volumenEmbalaje,
                ERUM_Unidad_embalaje__c = productObject.unidadEmbalaje,
                ERUM_Tipo_de_material__c = productObject.tipoMaterial,
                ERUM_Peso_neto_cantidad_embalada__c = productObject.pesoNetoCantidadEmbalada,
                ERUM_Peso_bruto_cantidad_embalada__c = productObject.pesoBrutoCantidadEmbalada,
                ERUM_Tipo_de_materia_prima__c = productObject.tipoMateriaPrima,
                ERUM_Nivel_tecnoligico__c = productObject.nivelTecnologico,
                Family = productObject.tipoProducto,
                Description = productObject.descripcionProducto,
                ERUM_Enviada_ERP__c = productObject.enviadaERP,
                Fecha_envio_ERP__c = productObject.fechaEnvioERP
            );

            try {
                Database.upsert(product, Product2.ERUM_External_ProductCode__c, true);
            } catch (DmlException dmlEx) {
                Database.rollback(sp);
                System.debug(dmlEx);
                GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Navision', 500, null, productObject.no, 'Productos');
                ErrorResponse r = new ErrorResponse();
                r.message = dmlEx.getMessage();
                r.errorType = '500 - Error al insertar/editar el producto. Detalles de la excepción: ' + dmlEx.getMessage();
                return r;
            }

            SuccessResponse r = new SuccessResponse();
            r.message = 'Producto creado/editado con éxito: ' + product.Id;
            r.Code = 'Success';
            return r;
            
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(e);
            GestionErrores.insertGestionErrores(e.getMessage(), 'Navision', 500, null, productObject != null ? productObject.no : null, 'Productos');
            ErrorResponse r = new ErrorResponse();
            r.message = e.getMessage();
            r.errorType = '500 - Error interno del servidor. Detalles de la excepción: ' + e.getMessage();
            return r;
        }
    }
}