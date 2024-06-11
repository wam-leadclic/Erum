public with sharing class WSDireccion extends AitanaDireccionWS {
    
    public static void insertDireccion(String direccionesJSON) {

        Map<Id, ERUM_Direcciones_Envio__c> direcciones = (Map<Id, ERUM_Direcciones_Envio__c>) JSON.deserialize(direccionesJSON, Map<Id, ERUM_Direcciones_Envio__c>.class);
        wsSF_DireccionesEnvio_Port direccionesPort = new wsSF_DireccionesEnvio_Port();
        direccionesPort.inputHttpHeaders_x = new Map<String, String>();
        direccionesPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        direccionesPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        direccionesPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        direccionesPort.inputHttpHeaders_x.put('Accept', '*/*');
        direccionesPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        direccionesPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        direccionesPort.outputHttpHeaders_x = new Map<String, String>();
        direccionesPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        direccionesPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        wsSF_DireccionesEnvio_List direccionesEnvioList = new wsSF_DireccionesEnvio_List();
        List<wsSF_DireccionesEnvio> direccionesEnvio = new List<wsSF_DireccionesEnvio>();
        
        List<Id> accountIds = new List<Id>();
        for (ERUM_Direcciones_Envio__c direccion : direcciones.values()) {
            if (!accountIds.contains(direccion.ERUM_Nombre_comercial__c)) {
                accountIds.add(direccion.ERUM_Nombre_comercial__c);
            }
        }

        Map<Id, String> codigosCliente = new Map<Id, String>();
        for (Account account_x : [SELECT Id, Numero_cliente_ERP__c FROM Account WHERE Id IN: accountIds]) {
            if (!codigosCliente.containsKey(account_x.Id)) {
                codigosCliente.put(account_x.Id, account_x.Numero_cliente_ERP__c);
            }
        }
        
        for (ERUM_Direcciones_Envio__c direccion : direcciones.values()) {
            wsSF_DireccionesEnvio direccionEnvio = new wsSF_DireccionesEnvio();
            direccionEnvio.Code = direccion.ERUM_Num_de_Direccion_NAV__c;
            direccionEnvio.Customer_No = codigosCliente.get(direccion.ERUM_Nombre_comercial__c);
            direccionEnvio.Name = direccion.Name;
            if (String.isNotBlank(direccion.ERUM_Calle__c)) {
                direccionEnvio.Address = direccion.ERUM_Calle__c.length() > 50 ? direccion.ERUM_Calle__c.substring(0, 50) : direccion.ERUM_Calle__c;
                direccionEnvio.Address_2 = direccion.ERUM_Calle__c.length() > 50 ? direccion.ERUM_Calle__c.substring(51, direccion.ERUM_Calle__c.length()) : null;
            }
            direccionEnvio.City = direccion.ERUM_Ciudad__c;
            if (String.isNotBlank(direccion.ERUM_Codigo_postal__c)) {
                direccionEnvio.Post_Code = direccion.ERUM_Codigo_postal__c.startsWith(direccion.ERUM_Pais__c + '-') ? direccion.ERUM_Codigo_postal__c : 'ES-' + direccion.ERUM_Codigo_postal__c;
            }
            direccionEnvio.County = direccion.ERUM_Pais__c;
            direccionEnvio.Country_Region_Code = direccion.ERUM_Country_RegionCOD__c;
            direccionEnvio.Dir_envio_principal = direccion.ERUM_Direccion_Principal_Envio__c;
            direccionesEnvio.add(direccionEnvio);
        }
        direccionesEnvioList.wsSF_DireccionesEnvio = direccionesEnvio;

        wsSF_DireccionesEnvio_List direccionesEnvioResponse = new wsSF_DireccionesEnvio_List();
        try {
            direccionesEnvioResponse = direccionesPort.CreateMultiple(direccionesEnvioList);
        } catch (CalloutException cEx) {
            System.debug('Excepción producida al crear direcciones en el ERP: ' + cEx.getMessage());
            GestionErrores.insertGestionErrores(cEx.getMessage(), 'Salesforce', null, direcciones.values()[0].Id, null, 'Direcciones');
            return;
        }

        if (direccionesEnvioResponse.wsSF_DireccionesEnvio.size() > 0) {
            Map<String, wsSF_DireccionesEnvio> insertedDirecciones = new Map<String, wsSF_DireccionesEnvio>();
            for (wsSF_DireccionesEnvio insertedDireccion : direccionesEnvioResponse.wsSF_DireccionesEnvio) {
                insertedDirecciones.put(insertedDireccion.Name, insertedDireccion);
            }
            for (ERUM_Direcciones_Envio__c direccion : direcciones.values()) {
                direccion.ERUM_Cod_de_Direccion_NAV__c = insertedDirecciones.get(direccion.Name).Key;
                direccion.ERUM_Activa_ERP__c = true;
                direccion.ERUM_Fecha_Activa_ERP__c = System.today();
                
                try {
                    TrgController.setDoNotRunTrigger();
                    Database.update(direccion, true);
                } catch (DmlException dmlEx) {
                    System.debug('Excepción producida al traer de vuelta el id de la dirección: ' + dmlEx.getMessage());
                    GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, direccion.Id, null, 'Direcciones');
                    return;
                }
            }
        }
    }

    public static void updateDireccion(String direccionesJSON) {

        Map<Id, ERUM_Direcciones_Envio__c> direcciones = (Map<Id, ERUM_Direcciones_Envio__c>) JSON.deserialize(direccionesJSON, Map<Id, ERUM_Direcciones_Envio__c>.class);
        wsSF_DireccionesEnvio_Port direccionesPort = new wsSF_DireccionesEnvio_Port();
        direccionesPort.inputHttpHeaders_x = new Map<String, String>();
        direccionesPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        direccionesPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        direccionesPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        direccionesPort.inputHttpHeaders_x.put('Accept', '*/*');
        direccionesPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        direccionesPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        direccionesPort.outputHttpHeaders_x = new Map<String, String>();
        direccionesPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        direccionesPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        wsSF_DireccionesEnvio_List direccionesEnvioList = new wsSF_DireccionesEnvio_List();
        List<wsSF_DireccionesEnvio> direccionesEnvio = new List<wsSF_DireccionesEnvio>();
        
        List<Id> accountIds = new List<Id>();
        for (ERUM_Direcciones_Envio__c direccion : direcciones.values()) {
            if (!accountIds.contains(direccion.ERUM_Nombre_comercial__c)) {
                accountIds.add(direccion.ERUM_Nombre_comercial__c);
            }
        }

        Map<Id, String> codigosCliente = new Map<Id, String>();
        for (Account account_x : [SELECT Id, Numero_cliente_ERP__c FROM Account WHERE Id IN: accountIds]) {
            if (!codigosCliente.containsKey(account_x.Id)) {
                codigosCliente.put(account_x.Id, account_x.Numero_cliente_ERP__c);
            }
        }
        
        for (ERUM_Direcciones_Envio__c direccion : direcciones.values()) {
            wsSF_DireccionesEnvio direccionEnvio = new wsSF_DireccionesEnvio();
            direccionEnvio.Key = direccion.ERUM_Cod_de_Direccion_NAV__c;
            direccionEnvio.Customer_No = codigosCliente.get(direccion.ERUM_Nombre_comercial__c); 
            direccionEnvio.Name = direccion.Name;
            direccionEnvio.Address = String.isNotBlank(direccion.ERUM_Calle__c) ? (
                direccion.ERUM_Calle__c.length() > 50 ? direccion.ERUM_Calle__c.substring(0, 50) : direccion.ERUM_Calle__c
            ) : null;
            direccionEnvio.Address_2 = String.isNotBlank(direccion.ERUM_Calle__c) ? (
                direccion.ERUM_Calle__c.length() > 50 ? direccion.ERUM_Calle__c.substring(51, direccion.ERUM_Calle__c.length()) : null
            ) : null;
            direccionEnvio.City = direccion.ERUM_Ciudad__c;
            direccionEnvio.Post_Code = String.isNotBlank(direccion.ERUM_Codigo_postal__c) ? (
                direccion.ERUM_Codigo_postal__c.startsWith(direccion.ERUM_Pais__c + '-') ? direccion.ERUM_Codigo_postal__c : 'ES-' + direccion.ERUM_Codigo_postal__c
            ) : null;
            direccionEnvio.County = direccion.ERUM_Pais__c;
            direccionEnvio.Country_Region_Code = direccion.ERUM_Country_RegionCOD__c;
            direccionEnvio.Dir_envio_principal = direccion.ERUM_Direccion_Principal_Envio__c;
            direccionesEnvio.add(direccionEnvio);
        }
        direccionesEnvioList.wsSF_DireccionesEnvio = direccionesEnvio;

        wsSF_DireccionesEnvio_List direccionesEnvioResponse = new wsSF_DireccionesEnvio_List();
        try {
            direccionesEnvioResponse = direccionesPort.UpdateMultiple(direccionesEnvioList);
        } catch (CalloutException cEx) {
            System.debug('Excepción producida al actualizar direcciones en el ERP: ' + cEx.getMessage());
            GestionErrores.insertGestionErrores(cEx.getMessage(), 'Salesforce', null, direcciones.values()[0].Id, null, 'Direcciones');
            return;
        }

        /**
         * RECOGEMOS LAS DIRECCIONES OBTENIDAS EN LA LLAMADA UPDATE MULTIPLE PARA USARLAS MÁS ADELANTE EN LA LLAMADA READ MULTIPLE.
         */

        System.debug(direccionesEnvioResponse);

        List<wsSF_DireccionesEnvio> wsSF_ReadMultipleResponse = new List<wsSF_DireccionesEnvio>();
        if (direccionesEnvioResponse.wsSF_DireccionesEnvio.size() > 0) {
            List<wsSF_DireccionesEnvio_Filter> direccionesFilter = new List<wsSF_DireccionesEnvio_Filter>();
            for (wsSF_DireccionesEnvio direccion : direccionesEnvioResponse.wsSF_DireccionesEnvio) {
                wsSF_DireccionesEnvio_Filter direccionFilter = new wsSF_DireccionesEnvio_Filter();
                direccionFilter.Field = 'Code';
                direccionFilter.Criteria = direccion.Code;
                direccionesFilter.add(direccionFilter);
            }
            try {
                wsSF_ReadMultipleResponse = direccionesPort.ReadMultiple(direccionesFilter, null, 100).wsSF_DireccionesEnvio;
            } catch (CalloutException cEx2) {
                System.debug('Excepción producida al recuperar direcciones del ERP: ' + cEx2.getMessage());
                GestionErrores.insertGestionErrores(cEx2.getMessage(), 'Salesforce', null, direcciones.values()[0].Id, null, 'Direcciones');
                return;
            }
        }

        /**
         * RECOGEMOS LAS DIRECCIONES OBTENIDAS EN LA LLAMADA READ MULTIPLE Y ACTUALIZAMOS LOS VALORES EN SALESFORCE. ¡ASÍ TENEMOS LOS CÓDIGOS MÁS RECIENTES!
         */

        System.debug(wsSF_ReadMultipleResponse);

        if (wsSF_ReadMultipleResponse.size() > 0) {
            Map<String, wsSF_DireccionesEnvio> updatedDirecciones = new Map<String, wsSF_DireccionesEnvio>();
            for (wsSF_DireccionesEnvio updatedDireccion : wsSF_ReadMultipleResponse) {
                updatedDirecciones.put(updatedDireccion.Code, updatedDireccion);
            }
            for (ERUM_Direcciones_Envio__c direccion : direcciones.values()) {
                try {
                    direccion.ERUM_Cod_de_Direccion_NAV__c = updatedDirecciones.get(direccion.ERUM_Num_de_Direccion_NAV__c).Key;
                } catch (NullPointerException nEx) {
                    System.debug('No se ha podido encontrar la Key entre las direcciones actualizadas: ' + nEx.getMessage());
                    GestionErrores.insertGestionErrores(nEx.getMessage(), 'Salesforce', null, direccion.Id, null, 'Direcciones');
                    return;
                }
                
                direccion.ERUM_Activa_ERP__c = true;
                direccion.ERUM_Fecha_Activa_ERP__c = System.today();
                try {
                    TrgController.setDoNotRunTrigger();
                    Database.update(direccion, true);
                } catch (DmlException dmlEx) {
                    System.debug('Excepción producida al traer de vuelta el id de la dirección en la actualización: ' + dmlEx.getMessage());
                    GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, direccion.Id, null, 'Direcciones');
                    return;
                }
            }
        }
    }
}