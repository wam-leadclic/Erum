@isTest
public class TestWSAccount {
    
    public class AccountMock implements WebServiceMock {

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
            
            AitanaAccountWS.wsSF_Clientes cliente = new AitanaAccountWS.wsSF_Clientes();
            cliente.Key = 'test';
            cliente.No = 'test';
            cliente.Name = 'test';
            cliente.VAT_Registration_No = 'test';
            cliente.Home_Page = 'test';
            cliente.Tipo_de_cliente = 'test';
            cliente.Currency_Code = 'test';
            cliente.Direccion_envio_principal = 'test';
            cliente.Usuario_alta = 'test';
            cliente.Address = 'test';
            cliente.Address_2 = 'test';
            cliente.Post_Code = 'test';
            cliente.Phone_No = 'test';
            cliente.Payment_Terms_Code = 'test';
            cliente.Salesperson_Code = 'test';
            cliente.Payment_Method_Code = 'test';
            cliente.Customer_Posting_Group = 'test';
            cliente.Gen_Bus_Posting_Group = 'test';
            cliente.VAT_Bus_Posting_Group = 'test';
            cliente.Blocked = 'test';
            cliente.E_Mail = 'test';
            cliente.Language_Code = 'test';
            cliente.vCCC_No = 'test';
            cliente.vSWIFT_Code = 'test';
            cliente.vIBAN = 'test';
            cliente.Num_Exped_CYC = 'test';
            cliente.Fecha_Expediente_CYC = 'test';
            cliente.Dias_Asegurado_CYC = 'test';
            cliente.Credit_Limit_LCY = 'test';
            cliente.vClasificacion = 'test';
            cliente.vImporteConcedido = 'test';

            List<AitanaAccountWS.wsSF_Clientes> clientes = new List<AitanaAccountWS.wsSF_Clientes>();
            clientes.add(cliente);

            AitanaAccountWS.wsSF_Clientes_List clientesList = new AitanaAccountWS.wsSF_Clientes_List();
            clientesList.wsSF_Clientes = clientes;

            if (requestName == 'CreateMultiple') {
                AitanaAccountWS.CreateMultiple_Result_element createResult = new AitanaAccountWS.CreateMultiple_Result_element();
                createResult.wsSF_Clientes_List = clientesList;
                response.put('response_x', createResult);
            } else if (requestName == 'UpdateMultiple') {
                AitanaAccountWS.UpdateMultiple_Result_element updateResult = new AitanaAccountWS.UpdateMultiple_Result_element();
                updateResult.wsSF_Clientes_List = clientesList;
                response.put('response_x', updateResult);
            } else if (requestName == 'ReadMultiple') {
                AitanaAccountWS.ReadMultiple_Result_element readResult = new AitanaAccountWS.ReadMultiple_Result_element();
                readResult.ReadMultiple_Result = clientesList;
                response.put('response_x', readResult);
            } else {
                response.put('response_x', null);
            }
            

        }
    }

    public class AccountMockError implements WebServiceMock {

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
            
            AitanaAccountWS.wsSF_Clientes cliente = new AitanaAccountWS.wsSF_Clientes();
            cliente.Key = 'test';
            cliente.No = 'Este número tiene más de 50 caracteres y debe dar error para que los tests unitarios 5 y 6 lancen una excepción.';
            cliente.Name = 'test';
            cliente.VAT_Registration_No = 'test';
            cliente.Home_Page = 'test';
            cliente.Tipo_de_cliente = 'test';
            cliente.Currency_Code = 'test';
            cliente.Direccion_envio_principal = 'test';
            cliente.Usuario_alta = 'test';
            cliente.Address = 'test';
            cliente.Address_2 = 'test';
            cliente.Post_Code = 'test';
            cliente.Phone_No = 'test';
            cliente.Payment_Terms_Code = 'test';
            cliente.Salesperson_Code = 'test';
            cliente.Payment_Method_Code = 'test';
            cliente.Customer_Posting_Group = 'test';
            cliente.Gen_Bus_Posting_Group = 'test';
            cliente.VAT_Bus_Posting_Group = 'test';
            cliente.Blocked = 'test';
            cliente.E_Mail = 'test';
            cliente.Language_Code = 'test';
            cliente.vCCC_No = 'test';
            cliente.vSWIFT_Code = 'test';
            cliente.vIBAN = 'test';
            cliente.Num_Exped_CYC = 'test';
            cliente.Fecha_Expediente_CYC = 'test';
            cliente.Dias_Asegurado_CYC = 'test';
            cliente.Credit_Limit_LCY = 'test';
            cliente.vClasificacion = 'test';
            cliente.vImporteConcedido = 'test';

            List<AitanaAccountWS.wsSF_Clientes> clientes = new List<AitanaAccountWS.wsSF_Clientes>();
            clientes.add(cliente);

            AitanaAccountWS.wsSF_Clientes_List clientesList = new AitanaAccountWS.wsSF_Clientes_List();
            clientesList.wsSF_Clientes = clientes;

            if (requestName == 'CreateMultiple') {
                AitanaAccountWS.CreateMultiple_Result_element createResult = new AitanaAccountWS.CreateMultiple_Result_element();
                createResult.wsSF_Clientes_List = clientesList;
                response.put('response_x', createResult);
            } else if (requestName == 'UpdateMultiple') {
                AitanaAccountWS.UpdateMultiple_Result_element updateResult = new AitanaAccountWS.UpdateMultiple_Result_element();
                updateResult.wsSF_Clientes_List = clientesList;
                response.put('response_x', updateResult);
            } else if (requestName == 'ReadMultiple') {
                AitanaAccountWS.ReadMultiple_Result_element readResult = new AitanaAccountWS.ReadMultiple_Result_element();
                readResult.ReadMultiple_Result = clientesList;
                response.put('response_x', readResult);
            } else {
                response.put('response_x', null);
            }
            

        }
    }

    @TestSetup
    static void makeData(){

        TrgController.setDoNotRunTrigger();
        
        Id clientePotencialRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Potencial').getRecordTypeId();
        Id clienteRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente').getRecordTypeId();

        Account account_x = new Account(
            Name = 'cuentaTestx testCuentax',
            Phone = '12345678',
            RecordTypeId = clientePotencialRecordType,
            ERUM_CIF_Europeo__c = 'test',
            ERUM_Idioma__c = 'ESP',
            ERUM_Estado__c = 'Nuevo',
            CurrencyIsoCode = 'EUR',
            BillingStreet = 'Calle Fernán Caballero, número 11, piso 2, puerta A Izquierda',
            BillingPostalCode = '11003',
            BillingCountry = 'ES',
            Num_Exp_CYC__c = '1',
            Fecha_Exp_CYC__c = System.today(),
            Dias_Asegurado_CYC__c = 365,
            Limite_Credito_CYC__c = 125000,
            ERUM_Importe_Concedido__c = 25000,
            ERUM_Activo_ERP__c = false,
            ERUM_Codigo_cliente_ERP__c = null,
            Numero_cliente_ERP__c = null,
            ERUM_Fecha_Activo_ERP__c = null,
            Clasificacion__c = null
        );

        insert account_x;

        Account account_y = new Account(
            Name = 'testCuentay cuentaTesty',
            Phone = '12345679',
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
            ERUM_Fecha_Activo_ERP__c = System.today(),
            Clasificacion__c = 'Asegurado'
        );

        insert account_y;
    }

    /**
     * TRIGGER ACCOUNT ON UPDATE
     */

    @isTest(SeeAllData=false)
    public static void testWSAccount_1() {
        Account test1 = [
            SELECT Id, RecordTypeId, ERUM_Estado__c, Name, ERUM_CIF_Europeo__c, Website, Phone, ERUM_Email__c, ERUM_Idioma__c, CurrencyIsoCode, IBAN__c, BillingStreet, BillingPostalCode, BillingCountry, ERUM_Terminos_de_pago__c, ERUM_Forma_de_pago__c, Num_Exp_CYC__c, Fecha_Exp_CYC__c, Dias_Asegurado_CYC__c, Limite_Credito_CYC__c, ERUM_Importe_Concedido__c 
            FROM Account 
            WHERE Name =: 'cuentaTestx testCuentax'
            LIMIT 1
        ];

        Test.setMock(WebServiceMock.class, new AccountMock());
        Test.startTest();
        test1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente').getRecordTypeId();
        Database.update(test1, true);
        Test.stopTest();
    }

    /**
     * TRIGGER ACCOUNT ON CREATE
     */

    @isTest(SeeAllData=false)
    public static void testWSAccount_2() {
        Account test2 = new Account(
            Name = 'test2 cuenta2',
            Phone = '12345677',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente').getRecordTypeId(),
            ERUM_CIF_Europeo__c = 'test',
            ERUM_Idioma__c = 'ESP',
            ERUM_Estado__c = 'Activo',
            CurrencyIsoCode = 'EUR',
            BillingStreet = 'Calle Enrique de las Marinas, número 13, piso 4, puerta C Derecha',
            BillingPostalCode = '11003',
            BillingCountry = 'ES',
            Num_Exp_CYC__c = '1',
            Fecha_Exp_CYC__c = System.today(),
            Dias_Asegurado_CYC__c = 365,
            Limite_Credito_CYC__c = 125000,
            ERUM_Importe_Concedido__c = 25000,
            ERUM_Activo_ERP__c = false,
            ERUM_Codigo_cliente_ERP__c = null,
            Numero_cliente_ERP__c = null,
            ERUM_Fecha_Activo_ERP__c = null,
            Clasificacion__c = null
        );
        Test.setMock(WebServiceMock.class, new AccountMock());
        Test.startTest();
        Database.insert(test2, true);
        Test.stopTest();
    }

    /**
     * BOTÓN PARA INSERTAR CLIENTE INACTIVO
     */

    @isTest(SeeAllData=false)
    public static void testWSAccount_3() {
        Account test3 = [SELECT Id, Phone, ERUM_CIF_Europeo__c, ERUM_Activo_ERP__c, ERUM_Codigo_cliente_ERP__c FROM Account WHERE Name =: 'cuentaTestx testCuentax' LIMIT 1];
        PageReference pRef = Page.ButtonWSAccountPage;
        Test.setMock(WebServiceMock.class, new AccountMock());
        Test.setCurrentPage(pRef);
        Test.startTest();
        ApexPages.StandardController sCtrl = new ApexPages.StandardController(test3);
        ButtonWSAccountController ctrl = new ButtonWSAccountController(sCtrl);
        ctrl.upsertAccount();
        Test.stopTest();
    }

    /**
     * BOTÓN PARA EDITAR CLIENTE ACTIVO
     */

    @isTest(SeeAllData=false)
    public static void testWSAccount_4() {
        Account test4 = [SELECT Id, Phone, ERUM_CIF_Europeo__c, ERUM_Activo_ERP__c, ERUM_Codigo_cliente_ERP__c FROM Account WHERE Name =: 'testCuentay cuentaTesty' LIMIT 1];
        PageReference pRef = Page.ButtonWSAccountPage;
        Test.setMock(WebServiceMock.class, new AccountMock());
        Test.setCurrentPage(pRef);
        Test.startTest();
        ApexPages.StandardController sCtrl = new ApexPages.StandardController(test4);
        ButtonWSAccountController ctrl = new ButtonWSAccountController(sCtrl);
        ctrl.upsertAccount();
        Test.stopTest();
    }

    
    /**
     * TRIGGER ACCOUNT ON UPDATE FAILURE
     */

    @isTest(SeeAllData=false)
    public static void testWSAccount_5() {
        Account test5 = [
            SELECT Id, RecordTypeId, ERUM_Estado__c, Name, ERUM_CIF_Europeo__c, Website, Phone, ERUM_Email__c, ERUM_Idioma__c, CurrencyIsoCode, IBAN__c, BillingStreet, BillingPostalCode, BillingCountry, ERUM_Terminos_de_pago__c, ERUM_Forma_de_pago__c, Num_Exp_CYC__c, Fecha_Exp_CYC__c, Dias_Asegurado_CYC__c, Limite_Credito_CYC__c, ERUM_Importe_Concedido__c 
            FROM Account 
            WHERE Name =: 'cuentaTestx testCuentax'
            LIMIT 1
        ];

        Test.setMock(WebServiceMock.class, new AccountMockError());
        Test.startTest();
        test5.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente').getRecordTypeId();
        Database.update(test5, true);
        Test.stopTest();
    }
 
    /**
     * BOTÓN PARA EDITAR CLIENTE ACTIVO FAILURE
     */
 
    @isTest(SeeAllData=false)
    public static void testWSAccount_6() {
        Account test6 = [SELECT Id, Phone, ERUM_CIF_Europeo__c, ERUM_Activo_ERP__c, ERUM_Codigo_cliente_ERP__c FROM Account WHERE Name =: 'testCuentay cuentaTesty' LIMIT 1];
        PageReference pRef = Page.ButtonWSAccountPage;
        Test.setMock(WebServiceMock.class, new AccountMockError());
        Test.setCurrentPage(pRef);
        Test.startTest();
        ApexPages.StandardController sCtrl = new ApexPages.StandardController(test6);
        ButtonWSAccountController ctrl = new ButtonWSAccountController(sCtrl);
        ctrl.upsertAccount();
        Test.stopTest();
    }

}