@isTest
public class TestWSDireccion {
    
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
            direccion.Name = 'test';
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
            } else if (requestName == 'UpdateMultiple') {
                AitanaDireccionWS.UpdateMultiple_Result_element updateResult = new AitanaDireccionWS.UpdateMultiple_Result_element();
                updateResult.wsSF_DireccionesEnvio_List = direccionesList;
                response.put('response_x', updateResult);
            } else if (requestName == 'ReadMultiple') {
                AitanaDireccionWS.ReadMultiple_Result_element readResult = new AitanaDireccionWS.ReadMultiple_Result_element();
                readResult.ReadMultiple_Result = direccionesList;
                response.put('response_x', readResult);
            } else {
                response.put('response_x', null);
            }

        }
    }

    public class DireccionMockError implements WebServiceMock {

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
            direccion.Key = 'Este número tiene un montón de caracteres y debe dar error para que los tests unitarios 3 y 4 lancen una excepción.';
            direccion.Code = 'SF00100013'; // IMPORTANTE: AL SER UN AUTONUMBER, ESTE VALOR VA A CAMBIAR. MIRA EN LA DEV CONSOLE DE PRODUCCIÓN, EN DEBUGS HABRÁ UN CÓDIGO SIMILAR.
            direccion.Customer_No = 'test';
            direccion.Name = 'test';
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
            } else if (requestName == 'UpdateMultiple') {
                AitanaDireccionWS.UpdateMultiple_Result_element updateResult = new AitanaDireccionWS.UpdateMultiple_Result_element();
                updateResult.wsSF_DireccionesEnvio_List = direccionesList;
                response.put('response_x', updateResult);
            } else if (requestName == 'ReadMultiple') {
                AitanaDireccionWS.ReadMultiple_Result_element readResult = new AitanaDireccionWS.ReadMultiple_Result_element();
                readResult.ReadMultiple_Result = direccionesList;
                response.put('response_x', readResult);
            } else {
                response.put('response_x', null);
            }

        }
    }

    @TestSetup
    static void makeData() {

        TrgController.setDoNotRunTrigger();

        Id clienteRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente').getRecordTypeId();

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
    }

    /**
     * TRIGGER DIRECCION ON UPDATE
     */
    @isTest(SeeAllData=false)
    public static void testTrg_1() {
        ERUM_Direcciones_Envio__c test1 = [
            SELECT Id, ERUM_Num_de_Direccion_NAV__c, ERUM_Nombre_comercial__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c, ERUM_Cod_de_Direccion_NAV__c
            FROM ERUM_Direcciones_Envio__c 
            WHERE Name =: 'test' 
            LIMIT 1
        ];
        Test.startTest();
        test1.ERUM_Country_RegionCOD__c = '11';
        Database.update(test1, true);
        Test.stopTest();
    }

    /**
     * TRIGGER DIRECCION ON INSERT
     */
    @isTest(SeeAllData=false)
    public static void testTrg_2() {
        ERUM_Direcciones_Envio__c test2 = new ERUM_Direcciones_Envio__c(
            ERUM_Nombre_comercial__c = [SELECT Id FROM Account WHERE Name =: 'testCuentay cuentaTesty' LIMIT 1].Id,
            Name = 'test',
            ERUM_Calle__c = 'Calle Enrique de las Marinas, número 13, piso 4, puerta C Derecha',
            ERUM_Ciudad__c = 'Cádiz',
            ERUM_Codigo_postal__c = '11003',
            ERUM_Pais__c = 'ES',
            ERUM_Country_RegionCOD__c = '11',
            ERUM_Direccion_Principal_Envio__c = false,
            ERUM_Activa_ERP__c = false,
            ERUM_Fecha_Activa_ERP__c = null,
            ERUM_Cod_de_Direccion_NAV__c = null
        );
        Test.startTest();
        Database.insert(test2, true);
        Test.stopTest();
    }

    /**
     * QUEUEABLE DIRECCION ON UPDATE
     */
    @isTest(SeeAllData=false)
    public static void testQueueableWS_1() {
        ERUM_Direcciones_Envio__c test1 = [
            SELECT Id, ERUM_Num_de_Direccion_NAV__c, ERUM_Nombre_comercial__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c, ERUM_Cod_de_Direccion_NAV__c
            FROM ERUM_Direcciones_Envio__c 
            WHERE Name =: 'test' 
            LIMIT 1
        ];
        System.debug(test1.ERUM_Num_de_Direccion_NAV__c);
        Test.setMock(WebServiceMock.class, new DireccionMock());
        Test.startTest();
        Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate = new Map<Id, ERUM_Direcciones_Envio__c>();
        dirsToUpdate.put(test1.Id, test1);
        WSQueueableDireccion.QueueableDireccionUpdate job = new WSQueueableDireccion.QueueableDireccionUpdate(dirsToUpdate);
        job.execute(null);
        Test.stopTest();
    }

    /**
     * QUEUEABLE DIRECCION ON INSERT
     */
    @isTest(SeeAllData=false)
    public static void testQueueableWS_2() {
        ERUM_Direcciones_Envio__c test2 = [
            SELECT Id, ERUM_Num_de_Direccion_NAV__c, ERUM_Nombre_comercial__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c, ERUM_Cod_de_Direccion_NAV__c
            FROM ERUM_Direcciones_Envio__c 
            WHERE Name =: 'test' 
            LIMIT 1
        ];
        System.debug(test2.ERUM_Num_de_Direccion_NAV__c);
        Test.setMock(WebServiceMock.class, new DireccionMock());
        Test.startTest();
        Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert = new Map<Id, ERUM_Direcciones_Envio__c>();
        dirsToInsert.put(test2.Id, test2);
        WSQueueableDireccion.QueueableDireccionInsert job = new WSQueueableDireccion.QueueableDireccionInsert(dirsToInsert, new Map<Id, ERUM_Direcciones_Envio__c>());
        job.execute(null);
        Test.stopTest();
    }

    /**
     * QUEUEABLE DIRECCION ON UPDATE FAILURE
     */
    @isTest(SeeAllData=false)
    public static void testQueueableWS_3() {
        ERUM_Direcciones_Envio__c test3 = [
            SELECT Id, ERUM_Num_de_Direccion_NAV__c, ERUM_Nombre_comercial__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c, ERUM_Cod_de_Direccion_NAV__c
            FROM ERUM_Direcciones_Envio__c 
            WHERE Name =: 'test' 
            LIMIT 1
        ];
        System.debug(test3.ERUM_Num_de_Direccion_NAV__c);
        Test.setMock(WebServiceMock.class, new DireccionMockError());
        Test.startTest();
        Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate = new Map<Id, ERUM_Direcciones_Envio__c>();
        dirsToUpdate.put(test3.Id, test3);
        WSQueueableDireccion.QueueableDireccionUpdate job = new WSQueueableDireccion.QueueableDireccionUpdate(dirsToUpdate);
        job.execute(null);
        Test.stopTest();
    }

    /**
     * QUEUEABLE DIRECCION ON INSERT FAILURE
     */
    @isTest(SeeAllData=false)
    public static void testQueueableWS_4() {
        ERUM_Direcciones_Envio__c test2 = [
            SELECT Id, ERUM_Num_de_Direccion_NAV__c, ERUM_Nombre_comercial__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c, ERUM_Cod_de_Direccion_NAV__c
            FROM ERUM_Direcciones_Envio__c 
            WHERE Name =: 'test' 
            LIMIT 1
        ];
        System.debug(test2.ERUM_Num_de_Direccion_NAV__c);
        Test.setMock(WebServiceMock.class, new DireccionMockError());
        Test.startTest();
        Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert = new Map<Id, ERUM_Direcciones_Envio__c>();
        dirsToInsert.put(test2.Id, test2);
        WSQueueableDireccion.QueueableDireccionInsert job = new WSQueueableDireccion.QueueableDireccionInsert(dirsToInsert, null);
        job.execute(null);
        Test.stopTest();
    }

}