public with sharing class TrgOpportunityController {

    Map<Id, Opportunity> newOpps = new Map<Id, Opportunity>();
    Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>();

    public TrgOpportunityController() {

        newOpps = (Map<Id, Opportunity>) Trigger.newMap;
        oldOpps = (Map<Id, Opportunity>) Trigger.oldMap;

        Map<Id, Schema.RecordTypeInfo> recordTypeInfoMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
        
        Map<Id, Account> accsToInsert = new Map<Id, Account>();
        Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert = new Map<Id, ERUM_Direcciones_Envio__c>();
        Map<Id, Opportunity> oppsToInsert = new Map<Id, Opportunity>();
        Map<Id, Opportunity> oppsToUpdate = new Map<Id, Opportunity>();
        Map<Id, List<OpportunityLineItem>> linesToInsert = new Map<Id, List<OpportunityLineItem>>();
        Map<Id, List<OpportunityLineItem>> linesToUpdate = new Map<Id, List<OpportunityLineItem>>();
        List<OpportunityLineItem> oppItemsListInsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppItemsListUpdate = new List<OpportunityLineItem>();
        
        List<Id> accountIds = new List<Id>();
        List<Id> dirIds = new List<Id>();
        for (Opportunity newOpp : newOpps.values()) {
            accountIds.add(newOpp.AccountId);
            dirIds.add(newOpp.ERUM_Nombre_Direccion__c);
        }

        Map<String, Schema.RecordTypeInfo> recordTypeInfoMapAccount = Schema.SObjectType.Account.getRecordTypeInfosByName();
        List<Account> accounts = new List<Account>();
        accounts = [
            SELECT Id, ERUM_Estado__c, Name, ERUM_CIF_Europeo__c, Website, Phone, ERUM_Email__c, ERUM_Idioma__c, CurrencyIsoCode, IBAN__c, BillingStreet, BillingPostalCode, BillingCountry, ERUM_Terminos_de_pago__c, ERUM_Forma_de_pago__c, Grupo_Contable_Cliente__c, Grupo_contable_negocio__c, Grupo_registro_IVA_negocio__c, Num_Exp_CYC__c, Fecha_Exp_CYC__c, Dias_Asegurado_CYC__c, Limite_Credito_CYC__c, Clasificacion__c, ERUM_Importe_Concedido__c, ERUM_Importe_solicitado__c, ERUM_Codigo_cliente_ERP__c, Numero_cliente_ERP__c, ERUM_Activo_ERP__c, ERUM_Fecha_Activo_ERP__c
            FROM Account 
            WHERE Id IN: accountIds
        ];
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Account acc : accounts) {
            if (!accountMap.containsKey(acc.Id)) {
                accountMap.put(acc.Id, acc);
            }
        }

        List<ERUM_Direcciones_Envio__c> dirs = new List<ERUM_Direcciones_Envio__c>();
        dirs = [
            SELECT Id, ERUM_Nombre_comercial__c, ERUM_Num_de_Direccion_NAV__c, Name, ERUM_Calle__c, ERUM_Ciudad__c, ERUM_Codigo_postal__c, ERUM_Pais__c, ERUM_Country_RegionCOD__c, ERUM_Direccion_Principal_Envio__c, ERUM_Cod_de_Direccion_NAV__c, ERUM_Activa_ERP__c, ERUM_Fecha_Activa_ERP__c
            FROM ERUM_Direcciones_Envio__c
            WHERE Id IN: dirIds
        ];
        Map<Id, ERUM_Direcciones_Envio__c> dirMap = new Map<Id, ERUM_Direcciones_Envio__c>();
        for (ERUM_Direcciones_Envio__c dir : dirs) {
            if (!dirMap.containsKey(dir.Id)) {
                dirMap.put(dir.Id, dir);
            }
        }

        if (Trigger.isAfter && Trigger.isInsert) {
            for (Opportunity newOpp : newOpps.values()) {

                Account oppAccount = accountMap.get(newOpp.AccountId);
                ERUM_Direcciones_Envio__c oppDireccion = dirMap.get(newOpp.ERUM_Nombre_Direccion__c);

                if (oppAccount != null && oppDireccion != null && newOpp.RecordTypeId != null) {
                    
                    if (recordTypeInfoMap.get(newOpp.RecordTypeId).getName() == 'Pedido') {
                        
                        oppItemsListInsert = [
                            SELECT Id, TotalPrice, ERUM_Impuesto__c, ListPrice, ProductCode, Quantity, ServiceDate, Discount, ERUM_UM__c, Description, ERUM_Cantidad_entregada__c, ERUM_Activo_ERP__c, Opportunity.ERUM_Offer_Id_External__c, OpportunityId, Erum_Key_Linea__c, ERUM_Line_No__c, Opportunity.AccountId, Opportunity.Account.Numero_cliente_ERP__c, Product2.ERUM_External_ProductCode__c, Tarifa__c, UnitPrice
                            FROM OpportunityLineItem 
                            WHERE OpportunityId =: newOpp.Id AND ERUM_Activo_ERP__c =: false
                        ];

                        oppItemsListUpdate = [
                            SELECT Id, TotalPrice, ERUM_Impuesto__c, ListPrice, ProductCode, Quantity, ServiceDate, Discount, ERUM_UM__c, Description, ERUM_Cantidad_entregada__c, ERUM_Activo_ERP__c, Opportunity.ERUM_Offer_Id_External__c, OpportunityId, Erum_Key_Linea__c, ERUM_Line_No__c, Opportunity.AccountId, Opportunity.Account.Numero_cliente_ERP__c, Product2.ERUM_External_ProductCode__c, Tarifa__c, UnitPrice
                            FROM OpportunityLineItem 
                            WHERE OpportunityId =: newOpp.Id AND ERUM_Activo_ERP__c =: true
                        ];

                        if (String.isBlank(oppAccount.Numero_cliente_ERP__c)) {
                            accsToInsert.put(oppAccount.Id, oppAccount);
                        }

                        if (!oppDireccion.ERUM_Activa_ERP__c) {
                            dirsToInsert.put(oppDireccion.Id, oppDireccion);
                        }

                        oppsToInsert.put(newOpp.Id, newOpp);

                        if (oppItemsListInsert.size() > 0) {
                            linesToInsert.put(newOpp.Id, oppItemsListInsert);
                        }

                        if (oppItemsListUpdate.size() > 0) {
                            linesToUpdate.put(newOpp.Id, oppItemsListUpdate);
                        }
                    }
                }
            }
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            for (Opportunity newOpp : newOpps.values()) {

                Account oppAccount = accountMap.get(newOpp.AccountId);
                ERUM_Direcciones_Envio__c oppDireccion = dirMap.get(newOpp.ERUM_Nombre_Direccion__c);
                Opportunity oldOpp = oldOpps.get(newOpp.Id);

                if (oppAccount != null && oppDireccion != null && newOpp.RecordTypeId != null) {
                    
                    if (recordTypeInfoMap.get(newOpp.RecordTypeId).getName() == 'Pedido') {
                        
                        oppItemsListInsert = [
                            SELECT Id, TotalPrice, ERUM_Impuesto__c, ListPrice, ProductCode, Quantity, ServiceDate, Discount, ERUM_UM__c, Description, ERUM_Cantidad_entregada__c, ERUM_Activo_ERP__c, Opportunity.ERUM_Offer_Id_External__c, OpportunityId, Erum_Key_Linea__c, ERUM_Line_No__c, Opportunity.AccountId, Opportunity.Account.Numero_cliente_ERP__c, Product2.ERUM_External_ProductCode__c, Tarifa__c, UnitPrice
                            FROM OpportunityLineItem 
                            WHERE OpportunityId =: newOpp.Id AND ERUM_Activo_ERP__c =: false
                        ];

                        oppItemsListUpdate = [
                            SELECT Id, TotalPrice, ERUM_Impuesto__c, ListPrice, ProductCode, Quantity, ServiceDate, Discount, ERUM_UM__c, Description, ERUM_Cantidad_entregada__c, ERUM_Activo_ERP__c, Opportunity.ERUM_Offer_Id_External__c, OpportunityId, Erum_Key_Linea__c, ERUM_Line_No__c, Opportunity.AccountId, Opportunity.Account.Numero_cliente_ERP__c, Product2.ERUM_External_ProductCode__c, Tarifa__c, UnitPrice
                            FROM OpportunityLineItem 
                            WHERE OpportunityId =: newOpp.Id AND ERUM_Activo_ERP__c =: true
                        ];

                        if (String.isBlank(oppAccount.Numero_cliente_ERP__c)) {
                            accsToInsert.put(oppAccount.Id, oppAccount);
                        }

                        if (!oppDireccion.ERUM_Activa_ERP__c) {
                            dirsToInsert.put(oppDireccion.Id, oppDireccion);
                        }

                        if (!newOpp.ERUM_Activo_ERP__c) {
                            oppsToInsert.put(newOpp.Id, newOpp);
                        } else {
                            oppsToUpdate.put(newOpp.Id, newOpp);
                        }
                        
                        if (oppItemsListInsert.size() > 0) {
                            System.debug(Opportunity.ERUM_Offer_Id_External__c);
                            linesToInsert.put(newOpp.Id, oppItemsListInsert);
                        }

                        if (oppItemsListUpdate.size() > 0) {
                            System.debug(Opportunity.ERUM_Offer_Id_External__c);
                            linesToUpdate.put(newOpp.Id, oppItemsListUpdate);
                        }
                    }
                }
            }
        }

        System.debug(oppsToInsert);
        System.debug(oppsToUpdate);

        if (oppsToInsert.size() > 0 || oppsToUpdate.size() > 0) {
            Id jobId1 = System.enqueueJob(new QueueableOpportunity(accsToInsert, dirsToInsert, oppsToInsert, oppsToUpdate, linesToInsert, linesToUpdate));
            System.debug(jobId1);
        }
    }

    /**
     * ¿POR QUÉ QUEUABLE? 
     * LAS LÍNEAS DEPENDEN DE UNA CABECERA PARA PODER PASAR AL ERP. LOS MÉTODOS @FUTURE AL SER ASÍNCRONOS NO PUEDEN GARANTIZAR EL ORDEN DE EJECUCIÓN. UN QUEUABLE SÍ PUEDE.
     * NO DEBE OLVIDAR LA IMPLEMENTACIÓN A DATABASE.ALLOWSCALLOUTS PARA PODER REALIZAR LLAMADAS HTTP.
     */
    public class QueueableOpportunity implements Queueable, Database.AllowsCallouts {

        private Map<Id, Account> accsToInsert;
        private Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert;
        private Map<Id, Opportunity> oppsToInsert;
        private Map<Id, Opportunity> oppsToUpdate;
        private Map<Id, List<OpportunityLineItem>> linesToInsert;
        private Map<Id, List<OpportunityLineItem>> linesToUpdate;

        public QueueableOpportunity(Map<Id, Account> accsToInsert_x, Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert_x, Map<Id, Opportunity> oppsToInsert_x, Map<Id, Opportunity> oppsToUpdate_x, Map<Id, List<OpportunityLineItem>> linesToInsert_x, Map<Id, List<OpportunityLineItem>> linesToUpdate_x) {
            this.accsToInsert = accsToInsert_x;
            this.dirsToInsert = dirsToInsert_x;
            this.oppsToInsert = oppsToInsert_x;
            this.oppsToUpdate = oppsToUpdate_x;
            this.linesToInsert = linesToInsert_x;
            this.linesToUpdate = linesToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            if (accsToInsert.size() > 0) {
                WSAccount.insertAccount(JSON.serialize(accsToInsert));
            }
            Id jobId2 = Test.isRunningTest() ? null : System.enqueueJob(new WSQueueableOpp.QueueableDireccionInsert(dirsToInsert, oppsToInsert, oppsToUpdate, linesToInsert, linesToUpdate));
            System.debug(jobId2);
        }
    }
    
}