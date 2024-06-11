@isTest
public class TestWSOpportunity {
    
    public class OppMock implements WebServiceMock {

        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            AitanaOrderWS.wsSF_Pedidos pedido = new AitanaOrderWS.wsSF_Pedidos();
            pedido.Key = 'test';
            pedido.No = 'test';
            pedido.Bill_to_Name = 'test';
            pedido.Order_Date = System.today();
            pedido.Language_Code = 'test';
            pedido.Currency_Code = 'test';
            pedido.Ship_to_Code = 'test';
            pedido.Ship_to_Address = 'test';
            pedido.Your_Reference = 'test';
            pedido.Shipping_Agent_Code = 'test';
            pedido.Payment_Terms_Code = 'test';
            pedido.Shipment_Method_Code = 'test';
            pedido.Payment_Method_Code = 'test';
            pedido.Invoice_Discount_Calculation = 'test';
            pedido.Ship_to_Post_Code = 'test';
            pedido.Ship_to_City = 'test';
            pedido.Ship_to_Country_Region_Code = 'test';
            pedido.Ship_to_Name = 'test';
            pedido.External_Document_No = 'test';
            pedido.Prepayment_Percent = 1.0;
            pedido.Payment_Discount_Percent = 1.0;
            pedido.Document_Type = 'test';
            pedido.No_Series = 'test';
            pedido.Sell_to_Customer_No = 'test';

            AitanaOrderLineWS.wsSF_LinPedido linea = new AitanaOrderLineWS.wsSF_LinPedido();
            linea.Key = 'test';
            linea.Document_No = 'test';
            linea.Line_No = 10000;
            linea.Sell_to_Customer_No = 'test';
            linea.Tariff_No = 'test';
            linea.Line_Discount_Percent = 1.0;
            linea.Shipment_Date = System.today();
            linea.Unit_of_Measure_Code = 'test';
            linea.Description = 'test';
            linea.Description_2 = 'test';
            linea.Unit_Price = 1.0;
            linea.Quantity = 1.0;
            linea.Qty_to_Ship = 1.0;
            linea.Document_Type = 'test';
            linea.No = 'no';

            List<AitanaOrderWS.wsSF_Pedidos> pedidos = new List<AitanaOrderWS.wsSF_Pedidos>();
            List<AitanaOrderLineWS.wsSF_LinPedido> lineas = new List<AitanaOrderLineWS.wsSF_LinPedido>();

            pedidos.add(pedido);
            lineas.add(linea);

            AitanaOrderWS.wsSF_Pedidos_List pedidosList = new AitanaOrderWS.wsSF_Pedidos_List();
            AitanaOrderLineWS.wsSF_LinPedido_List lineasList = new AitanaOrderLineWS.wsSF_LinPedido_List();

            pedidosList.wsSF_Pedidos = pedidos;
            lineasList.wsSF_LinPedido = lineas;

            if (soapAction.contains('wssf_pedidos')) {
                if (requestName == 'CreateMultiple') {
                    AitanaOrderWS.CreateMultiple_Result_element createResultPedidos = new AitanaOrderWS.CreateMultiple_Result_element();
                    createResultPedidos.wsSF_Pedidos_List = pedidosList;
                    response.put('response_x', createResultPedidos);
                } else if (requestName == 'UpdateMultiple') {
                    AitanaOrderWS.UpdateMultiple_Result_element updateResultPedidos = new AitanaOrderWS.UpdateMultiple_Result_element();
                    updateResultPedidos.wsSF_Pedidos_List = pedidosList;
                    response.put('response_x', updateResultPedidos);
                } else if (requestName == 'ReadMultiple') {
                    AitanaOrderWS.ReadMultiple_Result_element readResultPedidos = new AitanaOrderWS.ReadMultiple_Result_element();
                    readResultPedidos.ReadMultiple_Result = pedidosList;
                    response.put('response_x', readResultPedidos);
                } else {
                    response.put('response_x', null);
                }
            } else if (soapAction.contains('wssf_linpedido')) {
                if (requestName == 'CreateMultiple') {
                    AitanaOrderLineWS.CreateMultiple_Result_element createResultLineas = new AitanaOrderLineWS.CreateMultiple_Result_element();
                    createResultLineas.wsSF_LinPedido_List = lineasList;
                    response.put('response_x', createResultLineas);
                } else if (requestName == 'UpdateMultiple') {
                    AitanaOrderLineWS.UpdateMultiple_Result_element updateResultLineas = new AitanaOrderLineWS.UpdateMultiple_Result_element();
                    updateResultLineas.wsSF_LinPedido_List = lineasList;
                    response.put('response_x', updateResultLineas);
                } else if (requestName == 'ReadMultiple') {
                    AitanaOrderLineWS.ReadMultiple_Result_element readResultLineas = new AitanaOrderLineWS.ReadMultiple_Result_element();
                    readResultLineas.ReadMultiple_Result = lineasList;
                    response.put('response_x', readResultLineas);
                } else {
                    response.put('response_x', null);
                }
            }

        }

    }

    public class DireccionMock implements WebServiceMock {

        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            AitanaDireccionWS.wsSF_DireccionesEnvio direccion = new AitanaDireccionWS.wsSF_DireccionesEnvio();
            direccion.Key = 'test';
            direccion.Code = 'SF00100013'; // IMPORTANTE: AL SER UN AUTONUMBER, ESTE VALOR VA A CAMBIAR. MIRA EN LA DEV CONSOLE DE PRODUCCIÓN, EN DEBUGS HABRÁ UN CÓDIGO SIMILAR.
            direccion.Customer_No = 'test';
            direccion.Name = 'testy';
            direccion.Address = 'test';
            direccion.Address_2 = 'test';
            direccion.City = 'test';
            direccion.Post_Code = 'test';
            direccion.County = 'test';
            direccion.Country_Region_Code = 'test';
            direccion.Dir_envio_principal = true;

            List<AitanaDireccionWS.wsSF_DireccionesEnvio> direcciones = new List<AitanaDireccionWS.wsSF_DireccionesEnvio>();
            direcciones.add(direccion);

            AitanaDireccionWS.wsSF_DireccionesEnvio_List direccionesList = new AitanaDireccionWS.wsSF_DireccionesEnvio_List();
            direccionesList.wsSF_DireccionesEnvio = direcciones;

            if (requestName == 'CreateMultiple') {
                AitanaDireccionWS.CreateMultiple_Result_element createResult = new AitanaDireccionWS.CreateMultiple_Result_element();
                createResult.wsSF_DireccionesEnvio_List = direccionesList;
                response.put('response_x', createResult);
            } else {
                response.put('response_x', null);
            }

        }
    }

    @TestSetup
    static void makeData(){

        TrgController.setDoNotRunTrigger();

        Product2 productTest = new Product2(
            IsActive = true,
            DisplayUrl = 'foto',
            ERUM_External_ProductCode__c = 'no',
            Name = 'name',
            ERUM_Tipo__c = 'Inventario',
            ERUM_Bloqueado__c = false,
            QuantityUnitOfMeasure = 'unidadMedidaVenta',
            ERUM_Cod_categoria_producto__c = 'ALMACEN',
            ERUM_Cod_grupo_producto__c = 'ADZ',
            ERUM_Grupo_prod_Servicio__c = 'GR1',
            ERUM_Material_producto__c = 'PP',
            CurrencyIsoCode = 'EUR',
            ERUM_Volumen__c = 1.0,
            ERUM_Media_percha__c = 1.0,
            ERUM_Ancho_pala__c = 1.0,
            ERUM_Peso_neto__c = 1.0,
            ERUM_Peso_bruto__c = 1.0,
            ERUM_Grupo_contable_producto__c = 'ARANC CV',
            ERUM_Grupo_registro_IVA_prod__c = 'EXENTO',
            ERUM_Grupo_contable_inventario__c = 'ENVASES',
            ProductCode = 'codigoArancelario',
            ERUM_Tipo_palet__c = 'Europeo',
            ERUM_Cantidad_por_palet__c = 1.0,
            ERUM_Stock_disponible__c = 1.0,
            ERUM_Largo_embalaje__c = 1.0,
            ERUM_Ancho_embalaje__c = 1.0,
            ERUM_Alto_embalaje__c = 1.0,
            ERUM_Peso_embalaje__c = 1.0,
            ERUM_Volumen_embalaje__c = 1.0,
            ERUM_Unidad_embalaje__c = 1.0,
            ERUM_Tipo_de_material__c = 'PP',
            ERUM_Peso_neto_cantidad_embalada__c = 1.0,
            ERUM_Peso_bruto_cantidad_embalada__c = 1.0,
            ERUM_Tipo_de_materia_prima__c = 'No procede',
            ERUM_Nivel_tecnoligico__c = 'No procede',
            Family = 'tipoProducto',
            Description = 'descripcionProducto',
            ERUM_Enviada_ERP__c = false,
            Fecha_envio_ERP__c = System.today()
        );
        insert productTest;

        Pricebook2 tarifaTest = new Pricebook2(
            Name = 'nombre',
            Description = 'descripcion',
            IsActive = true,
            ERUM_Moneda__c = 1.0,
            ERUM_Fecha_Inicio__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_PB_Id_External__c = 'externalId'
        );
        insert tarifaTest;

        PricebookEntry standardEntryTest = new PricebookEntry(
            ERUM_Tipo_de_venta__c = 'Cliente',
            ERUM_Codigo_de_ventas__c = 'cvStandard',
            ERUM_Nombre_codigo_de_ventas__c = 'nombreCVS',
            C_d_Unidad_de_medida__c = 'CAJA',
            UnitPrice = 1.0,
            ERUM_Fecha_Inicial__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_Incluir_coste_contenedor__c = false,
            CurrencyIsoCode = 'EUR',
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productTest.Id,
            IsActive = true
        );
        insert standardEntryTest;

        PricebookEntry entryTest = new PricebookEntry(
            ERUM_Tipo_de_venta__c = 'Cliente',
            ERUM_Codigo_de_ventas__c = 'codVentas',
            ERUM_Nombre_codigo_de_ventas__c = 'nombreCV',
            C_d_Unidad_de_medida__c = 'CAJA',
            UnitPrice = 2.0,
            ERUM_Fecha_Inicial__c = System.today(),
            ERUM_Fecha_Final__c = System.today(),
            ERUM_Incluir_coste_contenedor__c = false,
            CurrencyIsoCode = 'EUR',
            Pricebook2Id = tarifaTest.Id,
            Product2Id = productTest.Id,
            IsActive = true
        );
        insert entryTest;

        Id clienteRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente').getRecordTypeId();
        Id pedidoRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pedido').getRecordTypeId();

        Account account_x = new Account(
            Name = 'testCuentay cuentaTesty',
            Phone = '12345678',
            RecordTypeId = clienteRecordType,
            ERUM_CIF_Europeo__c = 'test',
            ERUM_Idioma__c = 'ESP',
            ERUM_Estado__c = 'Activo',
            CurrencyIsoCode = 'EUR',
            BillingStreet = 'Calle Cánovas del Castillo, número 12, piso 3, puerta B Derecha',
            BillingPostalCode = '11003',
            BillingCountry = 'ES',
            Num_Exp_CYC__c = '1',
            Fecha_Exp_CYC__c = System.today(),
            Dias_Asegurado_CYC__c = 365,
            Limite_Credito_CYC__c = 125000,
            ERUM_Importe_Concedido__c = 25000,
            ERUM_Activo_ERP__c = true,
            ERUM_Codigo_cliente_ERP__c = 'test0',
            Numero_cliente_ERP__c = 'test',
            ERUM_Fecha_Activo_ERP__c = System.today()
        );

        insert account_x;

        ERUM_Direcciones_Envio__c direccion_x = new ERUM_Direcciones_Envio__c(
            ERUM_Nombre_comercial__c = account_x.Id,
            Name = 'test',
            ERUM_Calle__c = 'Calle Cánovas del Castillo, número 12, piso 3, puerta B Derecha',
            ERUM_Ciudad__c = 'Cádiz',
            ERUM_Codigo_postal__c = '11003',
            ERUM_Pais__c = 'ES',
            ERUM_Country_RegionCOD__c = 'ES',
            ERUM_Direccion_Principal_Envio__c = true,
            ERUM_Activa_ERP__c = true,
            ERUM_Fecha_Activa_ERP__c = System.today(),
            ERUM_Cod_de_Direccion_NAV__c = 'test0'
        );

        insert direccion_x;

        ERUM_Direcciones_Envio__c direccion_y = new ERUM_Direcciones_Envio__c(
            ERUM_Nombre_comercial__c = account_x.Id,
            Name = 'testy',
            ERUM_Calle__c = 'test',
            ERUM_Ciudad__c = 'test',
            ERUM_Codigo_postal__c = 'test',
            ERUM_Pais__c = 'test',
            ERUM_Country_RegionCOD__c = 'test',
            ERUM_Direccion_Principal_Envio__c = true,
            ERUM_Activa_ERP__c = false,
            ERUM_Fecha_Activa_ERP__c = null,
            ERUM_Cod_de_Direccion_NAV__c = null
        );

        insert direccion_y;

        Opportunity opportunity_x = new Opportunity(
            ERUM_Fecha_pedido__c = System.today(),
            ERUM_Nombre_Direccion__c = direccion_x.Id,
            ERUM_Referencia_del_cliente__c = 'test',
            ERUM_Terminos_de_pago__c = '0',
            ERUM_Incoterms__c = 'EXW',
            ERUM_Forma_de_pago__c = 'CONF',
            AccountId = account_x.Id,
            ERUM_Pedido_del_cliente__c = 'test',
            ERUM_Descuento_P_P__c = 10.0,
            RecordTypeId = pedidoRecordType,
            Name = 'testopp1',
            StageName = 'Activo',
            CloseDate = System.today().addYears(1),
            ERUM_Activo_ERP__c = false
        );

        insert opportunity_x;

        Opportunity opportunity_y = new Opportunity(
            ERUM_Fecha_pedido__c = System.today(),
            ERUM_Nombre_Direccion__c = direccion_x.Id,
            ERUM_Referencia_del_cliente__c = 'test',
            ERUM_Terminos_de_pago__c = '0',
            ERUM_Incoterms__c = 'EXW',
            ERUM_Forma_de_pago__c = 'CONF',
            AccountId = account_x.Id,
            ERUM_Pedido_del_cliente__c = 'test',
            ERUM_Descuento_P_P__c = 10.0,
            RecordTypeId = pedidoRecordType,
            Name = 'testopp2',
            StageName = 'Activo',
            CloseDate = System.today().addYears(1),
            ERUM_Activo_ERP__c = true,
            ERUM_Key_Pedido__c = 'test',
            ERUM_Offer_Id_External__c = 'test'
        );

        insert opportunity_y;

        Opportunity opportunity_z = new Opportunity(
            ERUM_Fecha_pedido__c = System.today(),
            ERUM_Nombre_Direccion__c = direccion_x.Id,
            ERUM_Referencia_del_cliente__c = 'test',
            ERUM_Terminos_de_pago__c = '0',
            ERUM_Incoterms__c = 'EXW',
            ERUM_Forma_de_pago__c = 'CONF',
            AccountId = account_x.Id,
            ERUM_Pedido_del_cliente__c = 'test',
            ERUM_Descuento_P_P__c = 10.0,
            RecordTypeId = pedidoRecordType,
            Name = 'testoppz',
            StageName = 'Activo',
            CloseDate = System.today().addYears(1),
            ERUM_Activo_ERP__c = false,
            Pricebook2Id = tarifaTest.Id
        );

        insert opportunity_z;

        OpportunityLineItem line_x = new OpportunityLineItem(
            OpportunityId = opportunity_z.Id,
            Product2Id = productTest.Id,
            TotalPrice = 1.0, 
            ERUM_Impuesto__c = 1.0, 
            Quantity = 1.0, 
            ServiceDate = System.today(), 
            Discount = 1.0, 
            ERUM_UM__c = 'line_x', 
            Description = 'line_x', 
            ERUM_Cantidad_entregada__c = 1.0, 
            ERUM_Activo_ERP__c = false, 
            Erum_Key_Linea__c = 'test', 
            ERUM_Line_No__c = '10000'
        );
        insert line_x;

        OpportunityLineItem line_y = new OpportunityLineItem(
            OpportunityId = opportunity_z.Id,
            Product2Id = productTest.Id,
            TotalPrice = 1.0, 
            ERUM_Impuesto__c = 1.0, 
            Quantity = 1.0, 
            ServiceDate = System.today(), 
            Discount = 1.0, 
            ERUM_UM__c = 'line_y', 
            Description = 'line_y', 
            ERUM_Cantidad_entregada__c = 1.0, 
            ERUM_Activo_ERP__c = true, 
            Erum_Key_Linea__c = 'test', 
            ERUM_Line_No__c = '10000'
        );
        insert line_y;
    }

    /**
     * TESTS TRIGGER ACCOUNT ON INSERT SIN LINEAS E INSERT EN ERP
     */

    @isTest(SeeAllData=false)
    public static void testTrgOpp_1() {
        Id pedidoRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pedido').getRecordTypeId();
        Opportunity test1 = new Opportunity(
            ERUM_Fecha_pedido__c = System.today(),
            ERUM_Nombre_Direccion__c = [SELECT Id FROM ERUM_Direcciones_Envio__c WHERE Name =: 'test' LIMIT 1].Id,
            ERUM_Referencia_del_cliente__c = 'test',
            ERUM_Terminos_de_pago__c = '0',
            ERUM_Incoterms__c = 'EXW',
            ERUM_Forma_de_pago__c = 'CONF',
            AccountId = [SELECT Id FROM Account WHERE Name =: 'testCuentay cuentaTesty' LIMIT 1].Id,
            ERUM_Pedido_del_cliente__c = 'test',
            ERUM_Descuento_P_P__c = 10.0,
            RecordTypeId = pedidoRecordType,
            Name = 'testopp1',
            StageName = 'Activo',
            CloseDate = System.today().addYears(1),
            ERUM_Activo_ERP__c = false
        );
        Test.setMock(WebServiceMock.class, new OppMock());
        Test.startTest();
        test1.ERUM_Terminos_de_pago__c = '10';
        Database.insert(test1, true);
        Test.stopTest();
    }
    

    @isTest(SeeAllData=false)
    public static void testWSOpp_1() {
        Opportunity test1 = [
            SELECT ERUM_Fecha_pedido__c, ERUM_Idioma__c, ERUM_Divisa__c, ERUM_Nombre_Direccion__c, ERUM_Referencia_del_cliente__c, ERUM_Terminos_de_pago__c, ERUM_Incoterms__c, ERUM_Forma_de_pago__c, AccountId, ERUM_Pedido_del_cliente__c, ERUM_Descuento_P_P__c, ERUM_Activo_ERP__c
            FROM Opportunity 
            WHERE Name =: 'testopp1'
            LIMIT 1
        ];
        Test.setMock(WebServiceMock.class, new OppMock());
        Test.startTest();
        Map<Id, Opportunity> oppsToInsert = new Map<Id, Opportunity>();
        oppsToInsert.put(test1.Id, test1);
        WSQueueableOpp.QueueableOppInsert job = new WSQueueableOpp.QueueableOppInsert(oppsToInsert, new Map<Id, Opportunity>(), new Map<Id, List<OpportunityLineItem>>(), new Map<Id, List<OpportunityLineItem>>());
        job.execute(null);
        Test.stopTest();
    }

    /**
     * TESTS TRIGGER ACCOUNT ON UPDATE SIN LINEAS Y UPDATE EN ERP
     */

    @isTest(SeeAllData=false)
    public static void testTrgOpp_2() {
        Opportunity test2 = [
            SELECT ERUM_Fecha_pedido__c, ERUM_Idioma__c, ERUM_Divisa__c, ERUM_Nombre_Direccion__c, ERUM_Referencia_del_cliente__c, ERUM_Terminos_de_pago__c, ERUM_Incoterms__c, ERUM_Forma_de_pago__c, AccountId, ERUM_Pedido_del_cliente__c, ERUM_Descuento_P_P__c, ERUM_Key_Pedido__c, ERUM_Offer_Id_External__c, ERUM_Activo_ERP__c
            FROM Opportunity 
            WHERE Name =: 'testopp2'
            LIMIT 1
        ];
        Test.startTest();
        test2.ERUM_Terminos_de_pago__c = '10';
        Database.update(test2, true);
        Test.stopTest();
    }

    @isTest(SeeAllData=false)
    public static void testWSOpp_2() {
        Opportunity test2 = [
            SELECT ERUM_Fecha_pedido__c, ERUM_Idioma__c, ERUM_Divisa__c, ERUM_Nombre_Direccion__c, ERUM_Referencia_del_cliente__c, ERUM_Terminos_de_pago__c, ERUM_Incoterms__c, ERUM_Forma_de_pago__c, AccountId, ERUM_Pedido_del_cliente__c, ERUM_Descuento_P_P__c, ERUM_Key_Pedido__c, ERUM_Offer_Id_External__c, ERUM_Activo_ERP__c
            FROM Opportunity 
            WHERE Name =: 'testopp2'
            LIMIT 1
        ];
        Map<Id, String> oppNos = new Map<Id, String>();
        oppNos.put(test2.Id, 'test2');
        Test.setMock(WebServiceMock.class, new OppMock());
        Test.startTest();
        Map<Id, Opportunity> oppsToUpdate = new Map<Id, Opportunity>();
        oppsToUpdate.put(test2.Id, test2);
        WSQueueableOpp.QueueableOppUpdate job = new WSQueueableOpp.QueueableOppUpdate(oppsToUpdate, new Map<Id, List<OpportunityLineItem>>(), new Map<Id, List<OpportunityLineItem>>(), oppNos);
        job.execute(null);
        Test.stopTest();
    }

    // INSERT EN ERP DE LINEAS
    @isTest(SeeAllData=false)
    public static void testWSLin_1() {
        Opportunity test1 = [
            SELECT Id, ERUM_Fecha_pedido__c, ERUM_Idioma__c, ERUM_Divisa__c, ERUM_Nombre_Direccion__c, ERUM_Referencia_del_cliente__c, ERUM_Terminos_de_pago__c, ERUM_Incoterms__c, ERUM_Forma_de_pago__c, AccountId, ERUM_Pedido_del_cliente__c, ERUM_Descuento_P_P__c, ERUM_Activo_ERP__c
            FROM Opportunity 
            WHERE Name =: 'testoppz'
            LIMIT 1
        ];
        OpportunityLineItem line = [
            SELECT Id, TotalPrice, ERUM_Impuesto__c, ListPrice, ProductCode, Quantity, ServiceDate, Discount, ERUM_UM__c, Description, ERUM_Cantidad_entregada__c, ERUM_Activo_ERP__c, Opportunity.ERUM_Offer_Id_External__c, OpportunityId, Erum_Key_Linea__c, ERUM_Line_No__c, Opportunity.AccountId, Product2.ERUM_External_ProductCode__c
            FROM OpportunityLineItem
            WHERE Description =: 'line_x'
        ];
        Map<Id, String> oppNos = new Map<Id, String>();
        oppNos.put(test1.Id, 'test1');
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        lines.add(line);
        Map<Id, List<OpportunityLineItem>> linesToInsert = new Map<Id, List<OpportunityLineItem>>();
        linesToInsert.put(test1.Id, lines);
        Test.setMock(WebServiceMock.class, new OppMock());
        Test.startTest();
        WSQueableLines.QueueableOpportunityLineInsert job = new WSQueableLines.QueueableOpportunityLineInsert(linesToInsert, new Map<Id, List<OpportunityLineItem>>(), oppNos);
        job.execute(null);
        Test.stopTest();
    }

    // UPDATE EN ERP DE LINEAS
    @isTest(SeeAllData=false)
    public static void testWSLin_2() {
        Opportunity test1 = [
            SELECT Id, ERUM_Fecha_pedido__c, ERUM_Idioma__c, ERUM_Divisa__c, ERUM_Nombre_Direccion__c, ERUM_Referencia_del_cliente__c, ERUM_Terminos_de_pago__c, ERUM_Incoterms__c, ERUM_Forma_de_pago__c, AccountId, ERUM_Pedido_del_cliente__c, ERUM_Descuento_P_P__c, ERUM_Activo_ERP__c
            FROM Opportunity 
            WHERE Name =: 'testoppz'
            LIMIT 1
        ];
        OpportunityLineItem line = [
            SELECT Id, TotalPrice, ERUM_Impuesto__c, ListPrice, ProductCode, Quantity, ServiceDate, Discount, ERUM_UM__c, Description, ERUM_Cantidad_entregada__c, ERUM_Activo_ERP__c, Opportunity.ERUM_Offer_Id_External__c, OpportunityId, Erum_Key_Linea__c, ERUM_Line_No__c, Opportunity.AccountId, Product2.ERUM_External_ProductCode__c
            FROM OpportunityLineItem
            WHERE Description =: 'line_y'
        ];
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        lines.add(line);
        Map<Id, List<OpportunityLineItem>> linesToUpdate = new Map<Id, List<OpportunityLineItem>>();
        linesToUpdate.put(test1.Id, lines);
        Test.setMock(WebServiceMock.class, new OppMock());
        Test.startTest();
        WSQueableLines.QueueableOpportunityLineUpdate job = new WSQueableLines.QueueableOpportunityLineUpdate(linesToUpdate);
        job.execute(null);
        Test.stopTest();
    }

    // UPDATE EN ERP DE DIRECCION
    @isTest(SeeAllData=false)
    public static void testWSDir() {
        ERUM_Direcciones_Envio__c direccion_y = [
            SELECT ERUM_Nombre_comercial__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c, ERUM_Cod_de_Direccion_NAV__c
            FROM ERUM_Direcciones_Envio__c
            WHERE Name =: 'testy'
            LIMIT 1
        ];
        Test.setMock(WebServiceMock.class, new DireccionMock());
        Test.startTest();
        Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert = new Map<Id, ERUM_Direcciones_Envio__c>();
        dirsToInsert.put(direccion_y.Id, direccion_y);
        WSQueueableOpp.QueueableDireccionInsert job = new WSQueueableOpp.QueueableDireccionInsert(dirsToInsert, new Map<Id, Opportunity>(), new Map<Id, Opportunity>(), new Map<Id, List<OpportunityLineItem>>(), new Map<Id, List<OpportunityLineItem>>());
        job.execute(null);
        Test.stopTest();
    }

}