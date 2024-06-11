global class IntegrationUpsertTarifa extends IntegrationModels {
    
    webservice static Response upsertTarifa(RequestBodyTarifa tarifaObject) {
        
        Savepoint sp = Database.setSavepoint();
        
        try {
            
            Pricebook2 pb = new Pricebook2(
                Name = tarifaObject.nombre,
                Description = tarifaObject.descripcion,
                IsActive = tarifaObject.activa,
                ERUM_Moneda__c = tarifaObject.moneda,
                ERUM_Fecha_Inicio__c = tarifaObject.fechaInicio,
                ERUM_Fecha_Final__c = tarifaObject.fechaFin,
                ERUM_PB_Id_External__c = tarifaObject.externalId
            );
            try {
                Database.upsert(pb, Pricebook2.ERUM_PB_Id_External__c, true);
            } catch (DmlException dmlEx) {
                Database.rollback(sp);
                System.debug(dmlEx);
                GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Navision', 500, null, tarifaObject.externalId, 'Tarifas');
                ErrorResponse r = new ErrorResponse();
                r.message = dmlEx.getMessage();
                r.errorType = '500 - Error al insertar/editar la tarifa. Detalles de la excepción: ' + dmlEx.getMessage();
                return r;
            }

            /**
             * COMPRUEBA SI LA TARIFA ENVIADA CONTIENE LÍNEAS DE TARIFA. SI NO ES EL CASO, FINALIZA LA OPERACIÓN.
             */

            if (tarifaObject.entradas != null) {

                /**
                 * LISTA DE productNos.
                 */

                List<String> productNos = new List<String>();
                for (RequestBodyLineaTarifa entrada : tarifaObject.entradas) {
                    if (!productNos.contains(entrada.productNo)) {
                        productNos.add(entrada.productNo);
                    }
                }

                /**
                 * LISTA DE PRODUCTOS EXISTENTES ENTRE LOS productNos RECOPILADOS. SI NO HAY NINGUNO, INTERRUMPA LA OPERACIÓN.
                 */

                List<Product2> existingProducts = new List<Product2>();
                existingProducts = [
                    SELECT Id, ERUM_External_ProductCode__c
                    FROM Product2
                    WHERE ERUM_External_ProductCode__c IN: productNos
                ];
                if (existingProducts.size() == 0) {
                    Database.rollback(sp);
                    GestionErrores.insertGestionErrores('No se han encontrado ninguno de los productos que ha especificado.', 'Navision', 500, null, tarifaObject.externalId, 'Tarifas');
                    ErrorResponse r = new ErrorResponse();
                    r.errorType = '500 - No se han encontrado ninguno de los productos que ha especificado.';
                    return r;
                }

                /**
                 * MAPA DE PRODUCTOS EXISTENTES. TAMBIÉN UNA LISTA DE IDS DE PRODUCTOS EXISTENTES, QUE UTILIZAREMOS MÁS ADELANTE.
                 */

                Map<String, Product2> existingProductsMap = new Map<String, Product2>();
                List<Id> productIds = new List<Id>();
                for (Product2 existingProduct : existingProducts) {
                    if (existingProductsMap.get(existingProduct.ERUM_External_ProductCode__c) == null) {
                        existingProductsMap.put(existingProduct.ERUM_External_ProductCode__c, existingProduct);
                    }
                    if (!productIds.contains(existingProduct.Id)) {
                        productIds.add(existingProduct.Id);
                    }
                }

                /**
                 * LISTA DE IDS DE ENTRADAS DE LA LLAMADA
                 */
                List<Integer> entryExternalIds = new List<Integer>();
                for (RequestBodyLineaTarifa entrada : tarifaObject.entradas) {
                    if (!entryExternalIds.contains(entrada.idLineaTarifa)) {
                        entryExternalIds.add(entrada.idLineaTarifa);
                    }
                }

                /**
                 * LISTA DE ENTRADAS YA EXISTENTES DE LA TARIFA, CON LOS MISMOS IDS DE ENTRADA ESPECIFICADOS EN LA LLAMADA.
                 */

                List<PricebookEntry> existingEntries = new List<PricebookEntry>();
                existingEntries = [
                    SELECT Id, Id_LineaTarifa__c
                    FROM PricebookEntry 
                    WHERE Id_LineaTarifa__c IN: entryExternalIds
                ];
                
                /**
                 * MAPA DE ENTRADAS YA EXISTENTES.
                 */

                Map<Decimal, PricebookEntry> existingEntriesMap = new Map<Decimal, PricebookEntry>();
                if (existingEntries.size() > 0) {
                    for (PricebookEntry existingEntry : existingEntries) {
                        existingEntriesMap.put(existingEntry.Id_LineaTarifa__c, existingEntry);
                    }
                }

                /**
                 * MAPA DE ENTRADAS PERTENECIENTES A LA STANDARD PRICEBOOK, Y CON LOS PRODUCTOS DE LA LISTA DE IDS.
                 */

                Id standardPricebook2Id = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE IsStandard =: true][0].Id;
                List<PricebookEntry> standardEntries = [
                    SELECT Id, Product2Id, Product2.ERUM_External_ProductCode__c 
                    FROM PricebookEntry 
                    WHERE Pricebook2Id =: standardPricebook2Id 
                    AND Product2Id IN: productIds
                ];
                Map<String, PricebookEntry> standardEntriesMap = new Map<String, PricebookEntry>();
                for (PricebookEntry standardEntry : standardEntries) {
                    if (!standardEntriesMap.containsKey(standardEntry.Product2.ERUM_External_ProductCode__c)) {
                        standardEntriesMap.put(standardEntry.Product2.ERUM_External_ProductCode__c, standardEntry);
                    }
                }

                List<PricebookEntry> standardEntriesToInsert = new List<PricebookEntry>();
                List<PricebookEntry> entriesToUpsert = new List<PricebookEntry>();

                for (RequestBodyLineaTarifa entrada : tarifaObject.entradas) {

                    PricebookEntry entry = new PricebookEntry(
                        Id_LineaTarifa__c = entrada.idLineaTarifa,
                        ERUM_Tipo_de_venta__c = entrada.tipoVenta,
                        ERUM_Codigo_de_ventas__c = entrada.codVentas,
                        ERUM_Nombre_codigo_de_ventas__c = entrada.nombreCodVentas,
                        C_d_Unidad_de_medida__c = entrada.codUdMedida,
                        UnitPrice = entrada.precioVenta,
                        ERUM_Fecha_Inicial__c = entrada.fechaInicial,
                        ERUM_Fecha_Final__c = entrada.fechaFinal,
                        ERUM_Incluir_coste_contenedor__c = entrada.incluirCosteContenedor,
                        IsActive = true
                    );

                    if (!existingEntriesMap.containsKey(entrada.idLineaTarifa)) {
                        entry.CurrencyIsoCode = String.isBlank(entrada.divisa) ? 'EUR' : entrada.divisa;
                        entry.Pricebook2Id = pb.Id;
                        entry.Product2Id = existingProductsMap.get(entrada.productNo).Id;
                    }

                    if (!standardEntriesMap.containsKey(entrada.productNo)) {
                        PricebookEntry standardPbe = new PricebookEntry(
                            Pricebook2Id = standardPricebook2Id,
                            Product2Id = existingProductsMap.get(entrada.productNo).Id,
                            UnitPrice = entrada.precioVenta,
                            CurrencyIsoCode = String.isBlank(entrada.divisa) ? 'EUR' : entrada.divisa,
                            IsActive = true
                        );
                        standardEntriesToInsert.add(standardPbe);
                    }

                    entriesToUpsert.add(entry);
                    
                }

                if (standardEntriesToInsert.size() > 0) {
                    System.debug('Líneas de tarifa estándar: ' + standardEntriesToInsert);
                    try {
                        Database.insert(standardEntriesToInsert, true);
                    } catch (DmlException dmlEx1) {
                        Database.rollback(sp);
                        System.debug(dmlEx1);
                        GestionErrores.insertGestionErrores(dmlEx1.getMessage(), 'Navision', 500, null, tarifaObject.externalId, 'Tarifas');
                        ErrorResponse r = new ErrorResponse();
                        r.message = dmlEx1.getMessage();
                        r.errorType = '500 - No se han podido crear las líneas de tarifa estándar. Detalles de la excepción: ' + dmlEx1.getMessage();
                        return r;
                    }          
                }

                if (entriesToUpsert.size() > 0) {
                    try {
                        Database.upsert(entriesToUpsert, PricebookEntry.Id_LineaTarifa__c, true);
                    } catch (DmlException dmlEx2) {
                        Database.rollback(sp);
                        System.debug(dmlEx2);
                        GestionErrores.insertGestionErrores(dmlEx2.getMessage(), 'Navision', 500, null, tarifaObject.externalId, 'Tarifas');
                        ErrorResponse r = new ErrorResponse();
                        r.message = dmlEx2.getMessage();
                        r.errorType = '500 - No se han podido crear/editar las líneas de tarifa. Detalles de la excepción: ' + dmlEx2.getMessage();
                        return r;
                    }
                    System.debug('Líneas de tarifa insertadas/editadas: ' + entriesToUpsert);         
                }

                SuccessResponse r = new SuccessResponse();
                r.message = 'Tarifa y líneas de tarifa creadas/editadas con éxito: ' + pb.Id;
                r.Code = 'Success';
                return r;
            }

            SuccessResponse r = new SuccessResponse();
            r.message = 'Tarifa creada/editada con éxito: ' + pb.Id;
            r.Code = 'Success';
            return r;
            
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug(e);
            GestionErrores.insertGestionErrores(e.getMessage(), 'Navision', 500, null, null, 'Tarifas');
            ErrorResponse r = new ErrorResponse();
            r.message = e.getMessage();
            r.errorType = '500 - Error interno del servidor. Detalles de la excepción: ' + e.getMessage();
            return r;
        }
    }
}