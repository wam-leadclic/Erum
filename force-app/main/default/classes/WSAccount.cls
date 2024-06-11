public with sharing class WSAccount {

    public static void insertAccount(String accountsJSON) {

        Map<Id, Account> accounts = (Map<Id, Account>) JSON.deserialize(accountsJSON, (Map<Id, Account>.class));

        AitanaAccountWS.wsSF_Clientes_Port clientesPort = new AitanaAccountWS.wsSF_Clientes_Port();
        clientesPort.inputHttpHeaders_x = new Map<String, String>();
        clientesPort.outputHttpHeaders_x = new Map<String, String>();
        clientesPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        clientesPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        clientesPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        clientesPort.inputHttpHeaders_x.put('Accept', '*/*');
        clientesPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        clientesPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        clientesPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        clientesPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        AitanaAccountWS.wsSF_Clientes_List clientesList = new AitanaAccountWS.wsSF_Clientes_List();
        List<AitanaAccountWS.wsSF_Clientes> clientes = new List<AitanaAccountWS.wsSF_Clientes>();
        for (Account account_x : accounts.values()) {
            AitanaAccountWS.wsSF_Clientes cliente = new AitanaAccountWS.wsSF_Clientes();
            cliente.Blocked = account_x.ERUM_Estado__c == 'Activo' || account_x.ERUM_Estado__c == 'Nuevo' ? '_blank_' : 'All';
            cliente.Name = account_x.Name;
            cliente.VAT_Registration_No = account_x.ERUM_CIF_Europeo__c;
            cliente.Home_Page = account_x.Website;
            cliente.Phone_No = account_x.Phone;
            cliente.E_Mail = account_x.ERUM_Email__c;
            cliente.Language_Code = account_x.ERUM_Idioma__c;
            cliente.Currency_Code = account_x.CurrencyIsoCode == 'EUR' ?  null : account_x.CurrencyIsoCode;
            cliente.Salesperson_Code = 'IRENE'; // account_x.ERUM_Comercial_asignado__c;
            cliente.vCCC_No = account_x.ERUM_Numero_de_cuenta__c;
            cliente.vSWIFT_Code = account_x.ERUM_Codigo_SWIFT__c;
            cliente.vIBAN = account_x.IBAN__c;
            cliente.Tipo_de_cliente = '_blank_';
            if (account_x.BillingStreet != null) {
                cliente.Address = account_x.BillingStreet.length() > 50 ? account_x.BillingStreet.substring(0, 50) : account_x.BillingStreet;
                cliente.Address_2 = account_x.BillingStreet.length() > 50 ? account_x.BillingStreet.substring(51, account_x.BillingStreet.length()) : null;
            }
            if (account_x.BillingPostalCode != null && account_x.BillingCountry != null) {
                cliente.Post_Code = account_x.BillingPostalCode.startsWith(account_x.BillingCountry + '-') ? account_x.BillingPostalCode : account_x.BillingCountry + '-' + account_x.BillingPostalCode;
            }
            cliente.Payment_Terms_Code = account_x.ERUM_Terminos_de_pago__c;
            cliente.Payment_Method_Code = account_x.ERUM_Forma_de_pago__c;
            cliente.Customer_Posting_Group = account_x.Grupo_Contable_Cliente__c;
            cliente.Gen_Bus_Posting_Group = account_x.Grupo_contable_negocio__c;
            cliente.VAT_Bus_Posting_Group = account_x.Grupo_registro_IVA_negocio__c;
            cliente.vNumSuplemento = account_x.Num_Exp_CYC__c;
            DateTime vFechaExpedienteDt = account_x.Fecha_Exp_CYC__c != null ? DateTime.newInstance(account_x.Fecha_Exp_CYC__c.year(), account_x.Fecha_Exp_CYC__c.month(),account_x.Fecha_Exp_CYC__c.day()) : null;
            String vFechaExpedienteStr = vFechaExpedienteDt != null ? vFechaExpedienteDt.format('yyyy-MM-dd') : null;
            cliente.vFechaExpediente = vFechaExpedienteStr;
            System.debug('cliente.vFechaExpediente: ' + cliente.vFechaExpediente);
            cliente.Dias_Asegurado_CYC = String.valueOf(account_x.Dias_Asegurado_CYC__c);
            cliente.Credit_Limit_LCY = String.valueOf(account_x.Limite_Credito_CYC__c);
            cliente.vClasificacion = account_x.Clasificacion__c != null ? account_x.Clasificacion__c.toUpperCase() : null;
            cliente.vImporteConcedido = String.valueOf(account_x.ERUM_Importe_Concedido__c);
            cliente.vImporteSolicitado = account_x.ERUM_Importe_solicitado__c != null ? account_x.ERUM_Importe_solicitado__c.replace('.', '') : null;
            System.debug('cliente.vImporteConcedido: ' + cliente.vImporteConcedido);
            System.debug('cliente.vImporteSolicitado: ' + cliente.vImporteSolicitado);
            DateTime vFechaVtoDt = account_x.Fecha_Exp_CYC__c != null ? DateTime.newInstance(account_x.Fecha_Exp_CYC__c.year() + 1, account_x.Fecha_Exp_CYC__c.month(),account_x.Fecha_Exp_CYC__c.day()) : null;
            String vFechaVtoStr = vFechaVtoDt != null ? vFechaVtoDt.format('yyyy-MM-dd') : null;
            cliente.vFechaVto = vFechaVtoStr;
            System.debug('cliente.vFechaVto: ' + cliente.vFechaVto);
            clientes.add(cliente);
        }

        clientesList.wsSF_Clientes = clientes;
        List<AitanaAccountWS.wsSF_Clientes> wsSF_ClientesResponse = new List<AitanaAccountWS.wsSF_Clientes>();
        try {
            wsSF_ClientesResponse = clientesPort.CreateMultiple(clientesList).wsSF_Clientes;
        } catch (CalloutException cEx) {
            System.debug('Excepción producida al crear cuentas en el ERP: ' + cEx.getMessage());
            GestionErrores.insertGestionErrores(cEx.getMessage(), 'Salesforce', null, accounts.values()[0].Id, null, 'Clientes');
            return;
        }
        
        if (wsSF_ClientesResponse.size() > 0) {
            Map<String, AitanaAccountWS.wsSF_Clientes> insertedClientes = new Map<String, AitanaAccountWS.wsSF_Clientes>();
            for (AitanaAccountWS.wsSF_Clientes cliente : wsSF_ClientesResponse) {
                insertedClientes.put(cliente.VAT_Registration_No, cliente);
            }
            for (Account account : accounts.values()) {
                Account newInstanceOfAccount = new Account(
                    Id = account.Id,
                    ERUM_Codigo_cliente_ERP__c = insertedClientes.get(account.ERUM_CIF_Europeo__c).Key,
                    Numero_cliente_ERP__c = insertedClientes.get(account.ERUM_CIF_Europeo__c).No,
                    ERUM_Activo_ERP__c = true,
                    ERUM_Fecha_Activo_ERP__c = System.today()
                );
                try {
                    TrgController.setDoNotRunTrigger();
                    Database.update(newInstanceOfAccount, true);
                } catch (DmlException dmlEx) {
                    System.debug('Excepción producida al traer de vuelta el id de la cuenta en la inserción: ' + dmlEx.getMessage());
                    GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, account.Id, null, 'Clientes');
                    return;
                }
            }
        }
        
    }

    public static void updateAccount(String accountsJSON) {

        Map<Id, Account> accounts = (Map<Id, Account>) JSON.deserialize(accountsJSON, (Map<Id, Account>.class));

        AitanaAccountWS.wsSF_Clientes_Port clientesPort = new AitanaAccountWS.wsSF_Clientes_Port();
        clientesPort.inputHttpHeaders_x = new Map<String, String>();
        clientesPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        clientesPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        clientesPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        clientesPort.inputHttpHeaders_x.put('Accept', '*/*');
        clientesPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        clientesPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        clientesPort.outputHttpHeaders_x = new Map<String, String>();
        clientesPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        clientesPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        AitanaAccountWS.wsSF_Clientes_List clientesList = new AitanaAccountWS.wsSF_Clientes_List();
        List<AitanaAccountWS.wsSF_Clientes> clientes = new List<AitanaAccountWS.wsSF_Clientes>();
        for (Account account_x : accounts.values()) {
            AitanaAccountWS.wsSF_Clientes cliente = new AitanaAccountWS.wsSF_Clientes();
            cliente.Key = account_x.ERUM_Codigo_cliente_ERP__c;
            cliente.No = account_x.Numero_cliente_ERP__c;
            cliente.Blocked = account_x.ERUM_Estado__c == 'Activo' || account_x.ERUM_Estado__c == 'Nuevo' ? '_blank_' : 'All';
            cliente.Name = account_x.Name;
            cliente.VAT_Registration_No = account_x.ERUM_CIF_Europeo__c;
            cliente.Home_Page = account_x.Website;
            cliente.Phone_No = account_x.Phone;
            cliente.E_Mail = account_x.ERUM_Email__c;
            cliente.Language_Code = account_x.ERUM_Idioma__c;
            cliente.Currency_Code = account_x.CurrencyIsoCode == 'EUR' ?  null : account_x.CurrencyIsoCode;
            cliente.Salesperson_Code = 'IRENE'; // account_x.ERUM_Comercial_asignado__c;
            /*
            cliente.vCCC_No = account_x.ERUM_Numero_de_cuenta__c;
            cliente.vSWIFT_Code = account_x.ERUM_Codigo_SWIFT__c;
            cliente.vIBAN = account_x.IBAN__c;
            */
            cliente.Tipo_de_cliente = '_blank_';
            if (account_x.BillingStreet != null) {
                cliente.Address = account_x.BillingStreet.length() > 50 ? account_x.BillingStreet.substring(0, 50) : account_x.BillingStreet;
                cliente.Address_2 = account_x.BillingStreet.length() > 50 ? account_x.BillingStreet.substring(51, 100) : null;
            }
            if (account_x.BillingPostalCode != null && account_x.BillingCountry != null) {
                cliente.Post_Code = account_x.BillingPostalCode.startsWith(account_x.BillingCountry + '-') ? account_x.BillingPostalCode : account_x.BillingCountry + '-' + account_x.BillingPostalCode;
            }
            cliente.Payment_Terms_Code = account_x.ERUM_Terminos_de_pago__c;
            cliente.Payment_Method_Code = account_x.ERUM_Forma_de_pago__c;
            cliente.Customer_Posting_Group = account_x.Grupo_Contable_Cliente__c;
            cliente.Gen_Bus_Posting_Group = account_x.Grupo_contable_negocio__c;
            cliente.VAT_Bus_Posting_Group = account_x.Grupo_registro_IVA_negocio__c;
            cliente.vNumSuplemento = account_x.Num_Exp_CYC__c;
            DateTime vFechaExpedienteDt = account_x.Fecha_Exp_CYC__c != null ? DateTime.newInstance(account_x.Fecha_Exp_CYC__c.year(), account_x.Fecha_Exp_CYC__c.month(),account_x.Fecha_Exp_CYC__c.day()) : null;
            String vFechaExpedienteStr = vFechaExpedienteDt != null ? vFechaExpedienteDt.format('yyyy-MM-dd') : null;
            cliente.vFechaExpediente = vFechaExpedienteStr;
            System.debug('cliente.vFechaExpediente: ' + cliente.vFechaExpediente);
            cliente.Dias_Asegurado_CYC = String.valueOf(account_x.Dias_Asegurado_CYC__c);
            // cliente.Credit_Limit_LCY = String.valueOf(account_x.Limite_Credito_CYC__c); -> SÓLO EN EL ALTA
            cliente.vClasificacion = account_x.Clasificacion__c != null ? account_x.Clasificacion__c.toUpperCase() : null;
            cliente.vImporteConcedido = String.valueOf(account_x.ERUM_Importe_Concedido__c);
            cliente.vImporteSolicitado = account_x.ERUM_Importe_solicitado__c != null ? account_x.ERUM_Importe_solicitado__c.replace('.', '') : null;
            System.debug('cliente.vImporteConcedido: ' + cliente.vImporteConcedido);
            System.debug('cliente.vImporteSolicitado: ' + cliente.vImporteSolicitado);
            DateTime vFechaVtoDt = account_x.Fecha_Exp_CYC__c != null ? DateTime.newInstance(account_x.Fecha_Exp_CYC__c.year() + 1, account_x.Fecha_Exp_CYC__c.month(),account_x.Fecha_Exp_CYC__c.day()) : null;
            String vFechaVtoStr = vFechaVtoDt != null ? vFechaVtoDt.format('yyyy-MM-dd') : null;
            cliente.vFechaVto = vFechaVtoStr;
            System.debug('cliente.vFechaVto: ' + cliente.vFechaVto);
            clientes.add(cliente);
        }
        clientesList.wsSF_Clientes = clientes;

        /**
         * RECOGEMOS LAS CUENTAS OBTENIDAS DEL TRIGGER Y LAS USAMOS EN LA LLAMADA UPDATE MULTIPLE.
         */

        List<AitanaAccountWS.wsSF_Clientes> wsSF_ClientesResponse = new List<AitanaAccountWS.wsSF_Clientes>();
        try {
            wsSF_ClientesResponse = clientesPort.UpdateMultiple(clientesList).wsSF_Clientes;
        } catch (CalloutException cEx) {
            System.debug('Excepción producida al actualizar cuentas en el ERP: ' + cEx.getMessage());
            GestionErrores.insertGestionErrores(cEx.getMessage(), 'Salesforce', null, accounts.values()[0].Id, null, 'Clientes');
            return;
        }

        /**
         * RECOGEMOS LAS CUENTAS OBTENIDAS EN LA LLAMADA UPDATE MULTIPLE PARA USARLAS MÁS ADELANTE EN LA LLAMADA READ MULTIPLE.
         */

        System.debug(wsSF_ClientesResponse);

        List<AitanaAccountWS.wsSF_Clientes> wsSF_ReadMultipleResponse = new List<AitanaAccountWS.wsSF_Clientes>();
        if (wsSF_ClientesResponse.size() > 0) {
            List<AitanaAccountWS.wsSF_Clientes_Filter> clientesFilter = new List<AitanaAccountWS.wsSF_Clientes_Filter>();
            for (AitanaAccountWS.wsSF_Clientes cliente : wsSF_ClientesResponse) {
                AitanaAccountWS.wsSF_Clientes_Filter clienteFilter = new AitanaAccountWS.wsSF_Clientes_Filter();
                clienteFilter.Field = 'No';
                clienteFilter.Criteria = cliente.No;
                clientesFilter.add(clienteFilter);
            }
            try {
                wsSF_ReadMultipleResponse = clientesPort.ReadMultiple(clientesFilter, null, 100).wsSF_Clientes;
            } catch (CalloutException cEx2) {
                System.debug('Excepción producida al recuperar cuentas del ERP: ' + cEx2.getMessage());
                GestionErrores.insertGestionErrores(cEx2.getMessage(), 'Salesforce', null, accounts.values()[0].Id, null, 'Clientes');
                return;
            }
        }

        /**
         * RECOGEMOS LAS CUENTAS OBTENIDAS EN LA LLAMADA READ MULTIPLE Y ACTUALIZAMOS LOS VALORES EN SALESFORCE. ¡ASÍ TENEMOS LOS CÓDIGOS MÁS RECIENTES!
         */

        System.debug(wsSF_ReadMultipleResponse);

        if (wsSF_ReadMultipleResponse.size() > 0) {
            Map<String, AitanaAccountWS.wsSF_Clientes> updatedClientes = new Map<String, AitanaAccountWS.wsSF_Clientes>();
            for (AitanaAccountWS.wsSF_Clientes cliente : wsSF_ReadMultipleResponse) {
                updatedClientes.put(cliente.VAT_Registration_No, cliente);
            }
            for (Account account : accounts.values()) {
                Account newInstanceOfAccount = new Account(
                    Id = account.Id,
                    ERUM_Codigo_cliente_ERP__c = updatedClientes.get(account.ERUM_CIF_Europeo__c).Key,
                    Numero_cliente_ERP__c = updatedClientes.get(account.ERUM_CIF_Europeo__c).No,
                    ERUM_Activo_ERP__c = true,
                    ERUM_Fecha_Activo_ERP__c = System.today()
                );
                try {
                    TrgController.setDoNotRunTrigger();
                    Database.update(newInstanceOfAccount, true);
                } catch (DmlException dmlEx) {
                    System.debug('Excepción producida al traer de vuelta el id de la cuenta en la actualización: ' + dmlEx.getMessage());
                    GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, account.Id, null, 'Clientes');
                    return;
                }
            }
        }

    }
}