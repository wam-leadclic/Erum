public with sharing class GestionErrores {
    
    public static void insertGestionErrores(String error, String origen, Integer codigoError, String codigoSalesforce, String codigoNavision, String integracion) {
        
        Gestion_de_errores__c gestion = new Gestion_de_errores__c(
            Descripcion__c = error, 
            Fecha_y_hora__c = System.now(), 
            Origen__c = origen, 
            Codigo_de_error__c = codigoError, 
            Codigo_Salesforce__c = codigoSalesforce, 
            Codigo_Navision__c = codigoNavision, 
            Integracion_fallida__c = integracion
        );

        if (String.isNotBlank(gestion.Codigo_Salesforce__c) && String.isNotBlank(gestion.Integracion_fallida__c)) {
            try {
                switch on gestion.Integracion_fallida__c {
                    when 'Clientes' {
                        gestion.Cuenta__c = [SELECT Id FROM Account WHERE Id =: gestion.Codigo_Salesforce__c LIMIT 1].Id;
                    }
                    when 'Direcciones' {
                        gestion.Direccion__c = [SELECT Id FROM ERUM_Direcciones_Envio__c WHERE Id =: gestion.Codigo_Salesforce__c LIMIT 1].Id;
                    }
                    when 'Pedidos' {
                        gestion.Pedido__c = [SELECT Id FROM Opportunity WHERE Id =: gestion.Codigo_Salesforce__c LIMIT 1].Id;
                    } when 'Líneas de Pedido' {
                        gestion.Pedido__c = [SELECT Id FROM Opportunity WHERE Id =: gestion.Codigo_Salesforce__c LIMIT 1].Id;
                    }
                    when else {
                        return;
                    }
                }
            } catch (QueryException qEx) {
                System.debug('Error al crear el objeto de gestión de errores. No se ha podido encontrar ninguna coincidencia para el registro de tipo ' + gestion.Integracion_fallida__c + ' con id ' + gestion.Codigo_Salesforce__c + '.');
            }
        } 
        
        else if(String.isNotBlank(gestion.Codigo_Navision__c) && String.isNotBlank(gestion.Integracion_fallida__c)) {
            try {
                switch on gestion.Integracion_fallida__c {
                    when 'Productos' {
                        gestion.Producto__c = [SELECT Id FROM Product2 WHERE Id =: gestion.Codigo_Navision__c LIMIT 1].Id;
                    }
                    when 'Tarifas' {
                        gestion.Tarifa__c = [SELECT Id FROM Pricebook2 WHERE Id =: gestion.Codigo_Navision__c LIMIT 1].Id;
                    }
                    when else {
                        return;
                    }
                }
            } catch (QueryException qEx) {
                System.debug('Error al crear el objeto de gestión de errores. No se ha podido encontrar ninguna coincidencia para el registro de tipo ' + gestion.Integracion_fallida__c + ' con id ' + gestion.Codigo_Salesforce__c + '.');
            }
        }

        try {
            Database.insert(gestion, true);
        } catch (DmlException dmlEx2) {
            System.debug('Error al crear el objeto de gestión de errores. Detalles de la excepción: ' + dmlEx2.getMessage());
        }
        
    }
}