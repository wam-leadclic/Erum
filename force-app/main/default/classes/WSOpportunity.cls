public with sharing class WSOpportunity extends AitanaOrderLineWS {

    public static Map<Id, String> insertOpportunity(String opportunitiesJSON) {

        Map<Id, Opportunity> opportunities = (Map<Id, Opportunity>) JSON.deserialize(opportunitiesJSON, Map<Id, Opportunity>.class);

        wsSF_Pedidos_Port pedidosPort = new wsSF_Pedidos_Port();
        pedidosPort.inputHttpHeaders_x = new Map<String, String>();
        pedidosPort.outputHttpHeaders_x = new Map<String, String>();
        pedidosPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        pedidosPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        pedidosPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        pedidosPort.inputHttpHeaders_x.put('Accept', '*/*');
        pedidosPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        pedidosPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        pedidosPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        pedidosPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        List<Id> accountIds = new List<Id>();
        for (Opportunity opportunity_x : opportunities.values()) {
            if (!accountIds.contains(opportunity_x.AccountId)) {
                accountIds.add(opportunity_x.AccountId);
            }
        }

        Map<Id, Account> cuentas = new Map<Id, Account>();
        for (Account cuenta : [SELECT Id, Name, Numero_cliente_ERP__c FROM Account WHERE Id IN: accountIds]) {
            cuentas.put(cuenta.Id, cuenta);
        }

        Map<Id, Agencia_de_envio__c> agentes = new Map<Id, Agencia_de_envio__c>();
        for (Agencia_de_envio__c agente : [SELECT Id, Codigo__c FROM Agencia_de_envio__c]) {
            agentes.put(agente.Id, agente);
        }

        List<Id> direccionIds = new List<Id>();
        for (Opportunity opportunity_x : opportunities.values()) {
            if (!direccionIds.contains(opportunity_x.ERUM_Nombre_Direccion__c)) {
                direccionIds.add(opportunity_x.ERUM_Nombre_Direccion__c);
            }
        }

        Map<Id, ERUM_Direcciones_Envio__c> direcciones = new Map<Id, ERUM_Direcciones_Envio__c>();
        for (ERUM_Direcciones_Envio__c direccion : [SELECT Id, Name, ERUM_Num_de_Direccion_NAV__c FROM ERUM_Direcciones_Envio__c WHERE Id IN: direccionIds]) {
            direcciones.put(direccion.Id, direccion);
        }

        wsSF_Pedidos_List pedidosList = new wsSF_Pedidos_List();
        List<wsSF_Pedidos> pedidos = new List<wsSF_Pedidos>();
        for (Opportunity opportunity_x : opportunities.values()) {
            wsSF_Pedidos pedido = new wsSF_Pedidos();
            pedido.Order_Date = opportunity_x.ERUM_Fecha_pedido__c;
            pedido.Language_Code = opportunity_x.ERUM_Idioma__c;
            pedido.Currency_Code = opportunity_x.ERUM_Divisa__c == 'EUR' ?  null : opportunity_x.ERUM_Divisa__c;
            pedido.Ship_to_Code = direcciones.get(opportunity_x.ERUM_Nombre_Direccion__c) != null ? direcciones.get(opportunity_x.ERUM_Nombre_Direccion__c).ERUM_Num_de_Direccion_NAV__c : null;
            pedido.Your_Reference = opportunity_x.ERUM_Referencia_del_cliente__c;
            pedido.Payment_Terms_Code = opportunity_x.ERUM_Terminos_de_pago__c;
            pedido.Shipment_Method_Code = opportunity_x.ERUM_Incoterms__c;
            pedido.Payment_Method_Code = opportunity_x.ERUM_Forma_de_pago__c;
            pedido.Sell_to_Customer_No = cuentas.get(opportunity_x.AccountId) != null ? cuentas.get(opportunity_x.AccountId).Numero_cliente_ERP__c : null;
            pedido.External_Document_No = opportunity_x.ERUM_Pedido_del_cliente__c;
            pedido.Payment_Discount_Percent = opportunity_x.ERUM_Descuento_P_P__c;
            pedido.Shipping_Agent_Code = opportunity_x.Agencia_de_envio__c == null ? null : agentes.get(opportunity_x.Agencia_de_envio__c).Codigo__c;
            // pedido.Invoice_Discount_Calculation; -> ESTE CAMPO TODAVÍA NO ESTÁ PRESENTE
            // pedido.Prepayment_Percent; -> ESTE CAMPO TODAVÍA NO ESTÁ PRESENTE
            // pedido.Document_Type = 'Order';
            pedidos.add(pedido);
        }
        pedidosList.wsSF_Pedidos = pedidos;

        List<wsSF_Pedidos> pedidosResponse = new List<wsSF_Pedidos>();
        try {
            System.debug('Entrando en la llamada CreateMultiple de cabeceras.');
            pedidosResponse = pedidosPort.CreateMultiple(pedidosList).wsSF_Pedidos;
            System.debug('Acabo de salir de la llamada CreateMultiple de cabeceras.');

        } catch (CalloutException cEx1) {
            System.debug('Excepción producida al crear pedidos en el ERP: ' + cEx1.getMessage());
            GestionErrores.insertGestionErrores(cEx1.getMessage(), 'Salesforce', null, opportunities.values()[0].Id, null, 'Pedidos');
        }

        Map<Id, String> oppNos = new Map<Id, String>();
        if (pedidosResponse.size() > 0) {
            Map<String, wsSF_Pedidos> insertedPedidos = new Map<String, wsSF_Pedidos>();
            for (wsSF_Pedidos pedido : pedidosResponse) {
                insertedPedidos.put(pedido.Your_Reference, pedido);
            }
            for (Opportunity opp : opportunities.values()) {
                opp.ERUM_Key_Pedido__c = insertedPedidos.get(opp.ERUM_Referencia_del_cliente__c).Key;
                opp.ERUM_Offer_Id_External__c = insertedPedidos.get(opp.ERUM_Referencia_del_cliente__c).No;
                opp.ERUM_Activo_ERP__c = true;
                opp.ERUM_Fecha_Activo_ERP__c = System.today();
                if (!oppNos.containsKey(opp.Id)) {
                    oppNos.put(opp.Id, insertedPedidos.get(opp.ERUM_Referencia_del_cliente__c).No);
                }
                try {
                    TrgController.setDoNotRunTrigger();
                    Database.update(opp, true);
                } catch (DmlException dmlEx) {
                    System.debug('Excepción producida al traer de vuelta el id del pedido: ' + dmlEx.getMessage());
                    GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, opp.Id, null, 'Pedidos');
                    return null;
                }
            }
            return oppNos;
        } else {
            return null;
        }

    }

    public static void insertOpportunityLine(String opportunityLinesJSON, Map<Id, String> oppNos) {

        Map<Id, List<OpportunityLineItem>> opportunityLinesMap = (Map<Id, List<OpportunityLineItem>>) JSON.deserialize(opportunityLinesJSON, Map<Id, List<OpportunityLineItem>>.class);

        wsSF_LinPedido_Port lineasPedidoPort = new wsSF_LinPedido_Port();
        lineasPedidoPort.inputHttpHeaders_x = new Map<String, String>();
        lineasPedidoPort.outputHttpHeaders_x = new Map<String, String>();
        lineasPedidoPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        lineasPedidoPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        lineasPedidoPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        lineasPedidoPort.inputHttpHeaders_x.put('Accept', '*/*');
        lineasPedidoPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        lineasPedidoPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        lineasPedidoPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        lineasPedidoPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        for (Id oppId : opportunityLinesMap.keySet()) {
            wsSF_LinPedido_List lineasPedidoList = new wsSF_LinPedido_List();
            List<wsSF_LinPedido> lineasPedido = new List<wsSF_LinPedido>();
            Integer contadorLinea = (Database.countQuery('SELECT COUNT() FROM OpportunityLineItem WHERE ERUM_Activo_ERP__c = true AND OpportunityId=\''+ oppId + '\'') + 1) * 10000;
            for (OpportunityLineItem line : opportunityLinesMap.get(oppId)) {
                wsSF_LinPedido lineaPedido = new wsSF_LinPedido();

                System.debug('line.Opportunity.ERUM_Offer_Id_External__c: ' + line.Opportunity.ERUM_Offer_Id_External__c);
                System.debug('line.OpportunityId: ' + line.OpportunityId);
                System.debug('oppNos: ' + oppNos);

                lineaPedido.Document_No = String.isBlank(line.Opportunity.ERUM_Offer_Id_External__c) ? oppNos.get(line.OpportunityId) : line.Opportunity.ERUM_Offer_Id_External__c;
                lineaPedido.Line_No = contadorLinea;
                lineaPedido.Tariff_No = '180690';
                lineaPedido.Line_Discount_Percent = line.Discount;
                lineaPedido.Shipment_Date = line.ServiceDate;
                lineaPedido.Unit_of_Measure_Code = line.ERUM_UM__c;
                lineaPedido.Description = line.Description;
                lineaPedido.Quantity = line.Quantity;
                lineaPedido.Unit_Price = line.UnitPrice;
                // lineaPedido.Document_Type = 'Order';
                lineaPedido.No = line.Product2.ERUM_External_ProductCode__c;
                // lineaPedido.Sell_to_Customer_No = line.Opportunity.Account.Numero_cliente_ERP__c; -> READ ONLY
                lineaPedido.Cod_Homologacion = line.Tarifa__c;
                lineasPedido.add(lineaPedido);
                contadorLinea = contadorLinea + 10000;
            }
            lineasPedidoList.wsSF_LinPedido = lineasPedido;
            
            List<wsSF_LinPedido> lineasPedidoResponse = new List<wsSF_LinPedido>();
            try {
                lineasPedidoResponse = lineasPedidoPort.CreateMultiple(lineasPedidoList).wsSF_LinPedido;
            } catch (CalloutException cEx1) {
                System.debug('Excepción producida al crear líneas de pedido en el ERP: ' + cEx1.getMessage());
                GestionErrores.insertGestionErrores(cEx1.getMessage(), 'Salesforce', null, oppId, null, 'Líneas de Pedido');
                return;
            }

            if (lineasPedidoResponse.size() > 0) {
                Map<String, wsSF_LinPedido> insertedLineas = new Map<String, wsSF_LinPedido>();
                for (wsSF_LinPedido lineas : lineasPedidoResponse) {
                    insertedLineas.put(lineas.No, lineas);
                }
                for (OpportunityLineItem oppLine : opportunityLinesMap.get(oppId)) {
                    System.debug('lineasPedidoResponse: ' + lineasPedidoResponse);
                    System.debug('insertedLineas: ' + insertedLineas);
                    System.debug('Get description: ' + insertedLineas.get(oppLine.Product2.ERUM_External_ProductCode__c));
                    try {
                        oppLine.Erum_Key_Linea__c = String.valueOf(insertedLineas.get(oppLine.Product2.ERUM_External_ProductCode__c).Key);
                        oppLine.ERUM_Line_No__c = String.valueOf(insertedLineas.get(oppLine.Product2.ERUM_External_ProductCode__c).Line_No);
                    } catch (NullPointerException nEx) {
                        System.debug('La descripción del producto no coincide con la del ERP: ' + nEx.getMessage());
                        GestionErrores.insertGestionErrores(nEx.getMessage(), 'Salesforce', null, oppId, null, 'Líneas de Pedido');
                        return;
                    }

                    oppLine.ERUM_Activo_ERP__c = true;
                    try {
                        TrgController.setDoNotRunTrigger();
                        Database.update(oppLine, true);
                    } catch (DmlException dmlEx) {
                        System.debug('Excepción producida al traer de vuelta el id y key de la línea de pedido: ' + dmlEx.getMessage());
                        GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, oppId, null, 'Líneas de Pedido');
                        return;
                    }
                }
            }
        }
    
    }

    public static void updateOpportunity(String opportunitiesJSON) {

        Map<Id, Opportunity> opportunities = (Map<Id, Opportunity>) JSON.deserialize(opportunitiesJSON, Map<Id, Opportunity>.class);

        wsSF_Pedidos_Port pedidosPort = new wsSF_Pedidos_Port();
        pedidosPort.inputHttpHeaders_x = new Map<String, String>();
        pedidosPort.outputHttpHeaders_x = new Map<String, String>();
        pedidosPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        pedidosPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        pedidosPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        pedidosPort.inputHttpHeaders_x.put('Accept', '*/*');
        pedidosPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        pedidosPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        pedidosPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        pedidosPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        List<Id> accountIds = new List<Id>();
        for (Opportunity opportunity_x : opportunities.values()) {
            if (!accountIds.contains(opportunity_x.AccountId)) {
                accountIds.add(opportunity_x.AccountId);
            }
        }

        Map<Id, Account> cuentas = new Map<Id, Account>();
        for (Account cuenta : [SELECT Id, Name, Numero_cliente_ERP__c FROM Account WHERE Id IN: accountIds]) {
            cuentas.put(cuenta.Id, cuenta);
        }

        Map<Id, Agencia_de_envio__c> agentes = new Map<Id, Agencia_de_envio__c>();
        for (Agencia_de_envio__c agente : [SELECT Id, Codigo__c FROM Agencia_de_envio__c]) {
            agentes.put(agente.Id, agente);
        }

        List<Id> direccionIds = new List<Id>();
        for (Opportunity opportunity_x : opportunities.values()) {
            if (!direccionIds.contains(opportunity_x.ERUM_Nombre_Direccion__c)) {
                direccionIds.add(opportunity_x.ERUM_Nombre_Direccion__c);
            }
        }

        Map<Id, ERUM_Direcciones_Envio__c> direcciones = new Map<Id, ERUM_Direcciones_Envio__c>();
        for (ERUM_Direcciones_Envio__c direccion : [SELECT Id, Name, ERUM_Num_de_Direccion_NAV__c FROM ERUM_Direcciones_Envio__c WHERE Id IN: direccionIds]) {
            direcciones.put(direccion.Id, direccion);
        }

        wsSF_Pedidos_List pedidosList = new wsSF_Pedidos_List();
        List<wsSF_Pedidos> pedidos = new List<wsSF_Pedidos>();
        for (Opportunity opportunity_x : opportunities.values()) {
            wsSF_Pedidos pedido = new wsSF_Pedidos();
            pedido.Key = opportunity_x.ERUM_Key_Pedido__c;
            pedido.No = opportunity_x.ERUM_Offer_Id_External__c;
            pedido.Order_Date = opportunity_x.ERUM_Fecha_pedido__c;
            pedido.Language_Code = opportunity_x.ERUM_Idioma__c;
            pedido.Currency_Code = opportunity_x.ERUM_Divisa__c == 'EUR' ?  null : opportunity_x.ERUM_Divisa__c;
            pedido.Ship_to_Code = direcciones.get(opportunity_x.ERUM_Nombre_Direccion__c) != null ? direcciones.get(opportunity_x.ERUM_Nombre_Direccion__c).ERUM_Num_de_Direccion_NAV__c : null;
            pedido.Your_Reference = opportunity_x.ERUM_Referencia_del_cliente__c;
            pedido.Payment_Terms_Code = opportunity_x.ERUM_Terminos_de_pago__c;
            pedido.Shipment_Method_Code = opportunity_x.ERUM_Incoterms__c;
            pedido.Payment_Method_Code = opportunity_x.ERUM_Forma_de_pago__c;
            pedido.Sell_to_Customer_No = cuentas.get(opportunity_x.AccountId).Numero_cliente_ERP__c;
            pedido.External_Document_No = opportunity_x.ERUM_Pedido_del_cliente__c;
            pedido.Payment_Discount_Percent = opportunity_x.ERUM_Descuento_P_P__c;
            pedido.Shipping_Agent_Code = opportunity_x.Agencia_de_envio__c == null ? null : agentes.get(opportunity_x.Agencia_de_envio__c).Codigo__c;
            // pedido.Invoice_Discount_Calculation; -> NO ESTÁ PRESENTE
            // pedido.Prepayment_Percent; -> NO ESTÁ PRESENTE
            // pedido.Document_Type = 'Order';
            pedidos.add(pedido);
        }
        pedidosList.wsSF_Pedidos = pedidos;

        List<wsSF_Pedidos> pedidosResponse = new List<wsSF_Pedidos>();
        try {
            pedidosResponse = pedidosPort.UpdateMultiple(pedidosList).wsSF_Pedidos;
        } catch (CalloutException cEx1) {
            System.debug('Excepción producida al actualizar pedidos en el ERP: ' + cEx1.getMessage());
            GestionErrores.insertGestionErrores(cEx1.getMessage(), 'Salesforce', null, opportunities.values()[0].Id, null, 'Pedidos');
            return;
        }

        List<wsSF_Pedidos> wsSF_ReadMultipleResponse = new List<wsSF_Pedidos>();
        if (pedidosResponse.size() > 0) {
            List<wsSF_Pedidos_Filter> pedidosFilter = new List<wsSF_Pedidos_Filter>();
            for (wsSF_Pedidos pedido : pedidosResponse) {
                wsSF_Pedidos_Filter pedidoFilter = new wsSF_Pedidos_Filter();
                pedidoFilter.Field = 'No';
                pedidoFilter.Criteria = pedido.No;
                pedidosFilter.add(pedidoFilter);
            }
            try {
                wsSF_ReadMultipleResponse = pedidosPort.ReadMultiple(pedidosFilter, null, 100).wsSF_Pedidos;
            } catch (CalloutException cEx2) {
                System.debug('Excepción producida al recuperar pedidos del ERP: ' + cEx2.getMessage());
                GestionErrores.insertGestionErrores(cEx2.getMessage(), 'Salesforce', null, opportunities.values()[0].Id, null, 'Pedidos');
                return;
            }
        }

        if (wsSF_ReadMultipleResponse.size() > 0) {
            Map<String, wsSF_Pedidos> updatedPedidos = new Map<String, wsSF_Pedidos>();
            for (wsSF_Pedidos updatedPedido : wsSF_ReadMultipleResponse) {
                updatedPedidos.put(updatedPedido.No, updatedPedido);
            }
            for (Opportunity opp : opportunities.values()) {
                opp.ERUM_Key_Pedido__c = updatedPedidos.get(opp.ERUM_Offer_Id_External__c).Key;
                opp.ERUM_Activo_ERP__c = true;
                opp.ERUM_Fecha_Activo_ERP__c = System.today();
                try {
                    TrgController.setDoNotRunTrigger();
                    Database.update(opp, true);
                } catch (DmlException dmlEx) {
                    System.debug('Excepción producida al traer de vuelta la key del pedido en la actualización: ' + dmlEx.getMessage());
                    GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, opp.Id, null, 'Pedidos');
                    return;
                }
            }
        }

    }

    public static void updateOpportunityLine(String opportunityLinesJSON) {

        Map<Id, List<OpportunityLineItem>> opportunityLinesMap = (Map<Id, List<OpportunityLineItem>>) JSON.deserialize(opportunityLinesJSON, Map<Id, List<OpportunityLineItem>>.class);

        wsSF_LinPedido_Port lineasPedidoPort = new wsSF_LinPedido_Port();
        lineasPedidoPort.inputHttpHeaders_x = new Map<String, String>();
        lineasPedidoPort.outputHttpHeaders_x = new Map<String, String>();
        lineasPedidoPort.inputHttpHeaders_x.put('Authorization', 'Basic RVJVTUdST1VQXE5BVkRFVjozYVlySmxLcDZKTWZUM2lsNUJWZmoxQXBMTGFCYU9WM0RyR0RTb21qUThvPQ==');
        lineasPedidoPort.inputHttpHeaders_x.put('Content-Type', 'text/xml');
        lineasPedidoPort.inputHttpHeaders_x.put('SOAPAction', 'POST');
        lineasPedidoPort.inputHttpHeaders_x.put('Accept', '*/*');
        lineasPedidoPort.inputHttpHeaders_x.put('Accept-Encoding', 'gzip, deflate, br');
        lineasPedidoPort.inputHttpHeaders_x.put('Connection', 'keep-alive');
        lineasPedidoPort.outputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        lineasPedidoPort.outputHttpHeaders_x.put('Server', 'Microsoft-HTTPAPI/2.0');

        for (Id oppId : opportunityLinesMap.keySet()) {
            wsSF_LinPedido_List lineasPedidoList = new wsSF_LinPedido_List();
            List<wsSF_LinPedido> lineasPedido = new List<wsSF_LinPedido>();
            for (OpportunityLineItem line : opportunityLinesMap.get(oppId)) {
                wsSF_LinPedido lineaPedido = new wsSF_LinPedido();
                lineaPedido.Key = line.Erum_Key_Linea__c;
                lineaPedido.Document_No = line.Opportunity.ERUM_Offer_Id_External__c;
                lineaPedido.Line_No = Integer.valueOf(line.ERUM_Line_No__c);
                lineaPedido.Tariff_No = '180690';
                lineaPedido.Line_Discount_Percent = line.Discount;
                lineaPedido.Shipment_Date = line.ServiceDate;
                lineaPedido.Unit_of_Measure_Code = line.ERUM_UM__c;
                lineaPedido.Description = line.Description;
                lineaPedido.Quantity = line.Quantity;
                lineaPedido.Unit_Price = line.UnitPrice;
                lineaPedido.Document_Type = 'Order';
                lineaPedido.No = line.Product2.ERUM_External_ProductCode__c;
                lineaPedido.Cod_Homologacion = line.Tarifa__c;
                // lineaPedido.Sell_to_Customer_No = line.Opportunity.Account.Numero_cliente_ERP__c; -> READ ONLY
                lineasPedido.add(lineaPedido);
            }
            lineasPedidoList.wsSF_LinPedido = lineasPedido;
            
            List<wsSF_LinPedido> lineasPedidoResponse = new List<wsSF_LinPedido>();
            try {
                lineasPedidoResponse = lineasPedidoPort.UpdateMultiple(lineasPedidoList).wsSF_LinPedido;
            } catch (CalloutException cEx1) {
                System.debug('Excepción producida al actualizar líneas de pedido en el ERP: ' + cEx1.getMessage());
                GestionErrores.insertGestionErrores(cEx1.getMessage(), 'Salesforce', null, oppId, null, 'Líneas de Pedido');
                return;
            }

            List<wsSF_LinPedido> wsSF_ReadMultipleResponse = new List<wsSF_LinPedido>();
            if (lineasPedidoResponse.size() > 0) {
                List<wsSF_LinPedido_Filter> lineasFilter = new List<wsSF_LinPedido_Filter>();
                for (wsSF_LinPedido lineaPedido : lineasPedidoResponse) {
                    wsSF_LinPedido_Filter lineaPedidoFilter = new wsSF_LinPedido_Filter();
                    lineaPedidoFilter.Field = 'Document_No';
                    lineaPedidoFilter.Criteria = String.valueOf(lineaPedido.Document_No);
                    lineasFilter.add(lineaPedidoFilter);
                }
                try {
                    wsSF_ReadMultipleResponse = lineasPedidoPort.ReadMultiple(lineasFilter, null, 100).wsSF_LinPedido;
                } catch (CalloutException cEx2) {
                    System.debug('Excepción producida al recuperar líneas de pedido del ERP: ' + cEx2.getMessage());
                    GestionErrores.insertGestionErrores(cEx2.getMessage(), 'Salesforce', null, oppId, null, 'Líneas de Pedido');
                    return;
                }
            }

            if (wsSF_ReadMultipleResponse.size() > 0) {
                Map<String, wsSF_LinPedido> updatedLineas = new Map<String, wsSF_LinPedido>();
                for (wsSF_LinPedido updatedLinea : wsSF_ReadMultipleResponse) {
                    System.debug('updatedLinea: ' + updatedLinea);
                    updatedLineas.put(String.valueOf(updatedLinea.No), updatedLinea);
                }
                for (OpportunityLineItem line : opportunityLinesMap.get(oppId)) {
                    System.debug('updatedLineas.get: ' + updatedLineas.get(line.Product2.ERUM_External_ProductCode__c));
                    line.Erum_Key_Linea__c = updatedLineas.get(line.Product2.ERUM_External_ProductCode__c).Key;
                    line.ERUM_Activo_ERP__c = true;
                    try {
                        TrgController.setDoNotRunTrigger();
                        Database.update(line, true);
                    } catch (DmlException dmlEx) {
                        System.debug('Excepción producida al traer de vuelta la key de la línea de pedido en la actualización: ' + dmlEx.getMessage());
                        GestionErrores.insertGestionErrores(dmlEx.getMessage(), 'Salesforce', null, oppId, null, 'Líneas de Pedido');
                        return;
                    }
                }
            }

        }

    }

}