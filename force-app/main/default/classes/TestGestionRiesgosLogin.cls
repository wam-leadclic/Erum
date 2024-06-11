@isTest
public class TestGestionRiesgosLogin {
    
    @TestSetup
    static void makeData(){

        TrgController.setDoNotRunTrigger();

        Id clientePotencialRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Potencial').getRecordTypeId();

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
            Num_Exp_CYC__c = null,
            Fecha_Exp_CYC__c = null,
            Dias_Asegurado_CYC__c = null,
            Limite_Credito_CYC__c = null,
            ERUM_Importe_Concedido__c = null,
            ERUM_Activo_ERP__c = false,
            ERUM_Codigo_cliente_ERP__c = null,
            Numero_cliente_ERP__c = null,
            ERUM_Fecha_Activo_ERP__c = null
        );

        insert account_x;
        
    }
    
    @isTest(SeeAllData=false)
    public static void testGestionLogin_1() {
        PageReference pRef = Page.GestionRiesgosLoginPage;
        Test.setCurrentPage(pRef);
        Account account_x = [SELECT ERUM_CIF_Europeo__c FROM Account WHERE ERUM_CIF_Europeo__c =: 'test' LIMIT 1];
        ApexPages.currentPage().getParameters().put('cif', account_x.ERUM_CIF_Europeo__c);
        GestionRiesgosLoginController ctrl = new GestionRiesgosLoginController();
        ctrl.username = 'financiero';
        ctrl.password = 'financiero';
        ctrl.verificarCredenciales();

    }

    @isTest(SeeAllData=false)
    public static void testGestionLogin_3() {
        PageReference pRef = Page.GestionRiesgosLoginPage;
        Test.setCurrentPage(pRef);
        Account account_x = [SELECT ERUM_CIF_Europeo__c FROM Account WHERE ERUM_CIF_Europeo__c =: 'test' LIMIT 1];
        ApexPages.currentPage().getParameters().put('cif', account_x.ERUM_CIF_Europeo__c);
        GestionRiesgosLoginController ctrl = new GestionRiesgosLoginController();
        ctrl.username = 'financierooo';
        ctrl.password = 'financiero';
        ctrl.verificarCredenciales();

    }
}