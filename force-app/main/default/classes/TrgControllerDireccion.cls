public with sharing class TrgControllerDireccion {

    Map<Id, ERUM_Direcciones_Envio__c> newDirecciones = new Map<Id, ERUM_Direcciones_Envio__c>();

    public TrgControllerDireccion() {

        newDirecciones = (Map<Id, ERUM_Direcciones_Envio__c>) Trigger.newMap;

        Map<Id, Account> accountsToInsert = new Map<Id, Account>();
        Map<Id, ERUM_Direcciones_Envio__c> direccionesToInsert = new Map<Id, ERUM_Direcciones_Envio__c>();
        Map<Id, ERUM_Direcciones_Envio__c> direccionesToUpdate = new Map<Id, ERUM_Direcciones_Envio__c>();

        List<Id> accountIds = new List<Id>();
        for (ERUM_Direcciones_Envio__c newDireccion : newDirecciones.values()) {
            accountIds.add(newDireccion.ERUM_Nombre_comercial__c);
        }

        Map<String, Schema.RecordTypeInfo> recordTypeInfoMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        List<Account> accounts = new List<Account>();
        accounts = [
            SELECT Id, ERUM_Estado__c, Name, ERUM_CIF_Europeo__c, Website, Phone, ERUM_Email__c, ERUM_Idioma__c, CurrencyIsoCode, IBAN__c, BillingStreet, BillingPostalCode, BillingCountry, ERUM_Terminos_de_pago__c, ERUM_Forma_de_pago__c, Grupo_Contable_Cliente__c, Grupo_contable_negocio__c, Grupo_registro_IVA_negocio__c, Num_Exp_CYC__c, Fecha_Exp_CYC__c, Dias_Asegurado_CYC__c, Limite_Credito_CYC__c, Clasificacion__c, ERUM_Importe_Concedido__c, ERUM_Importe_solicitado__c, ERUM_Codigo_cliente_ERP__c, Numero_cliente_ERP__c, ERUM_Activo_ERP__c, ERUM_Fecha_Activo_ERP__c
            FROM Account 
            WHERE RecordTypeId =: recordTypeInfoMap.get('Cliente').getRecordTypeId() 
            AND Id IN: accountIds
        ];

        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Account acc : accounts) {
            if (!accountMap.containsKey(acc.Id)) {
                accountMap.put(acc.Id, acc);
            }
        }

        if (Trigger.isAfter && Trigger.isInsert) {
            for (ERUM_Direcciones_Envio__c newDireccion : newDirecciones.values()) {
                
                Account dirAccount = accountMap.get(newDireccion.ERUM_Nombre_comercial__c);
                
                if (dirAccount != null) {
                    
                    if (String.isBlank(dirAccount.Numero_cliente_ERP__c)) {
                        accountsToInsert.put(dirAccount.Id, dirAccount);
                    }
                    direccionesToInsert.put(newDireccion.Id, newDireccion);
                    
                }
            }
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            for (ERUM_Direcciones_Envio__c newDireccion : newDirecciones.values()) {
                
                Account dirAccount = accountMap.get(newDireccion.ERUM_Nombre_comercial__c);
                
                if (dirAccount != null) {
                    
                    if (String.isBlank(dirAccount.Numero_cliente_ERP__c)) {
                        accountsToInsert.put(dirAccount.Id, dirAccount);
                    }
                    if (newDireccion.ERUM_Activa_ERP__c) {
                        direccionesToUpdate.put(newDireccion.Id, newDireccion);
                    } else {
                        direccionesToInsert.put(newDireccion.Id, newDireccion);
                    }

                }
            }
        }

        if (direccionesToInsert.size() > 0 || direccionesToUpdate.size() > 0) {
            Id jobId1 = System.enqueueJob(new QueueableDireccion(accountsToInsert, direccionesToInsert, direccionesToUpdate));
            System.debug(jobId1);
        }
        
    }

    public class QueueableDireccion implements Queueable, Database.AllowsCallouts {

        private Map<Id, Account> accsToInsert;
        private Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert;
        private Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate;


        public QueueableDireccion(Map<Id, Account> accsToInsert_x, Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert_x, Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate_x) {
            this.accsToInsert = accsToInsert_x;
            this.dirsToInsert = dirsToInsert_x;
            this.dirsToUpdate = dirsToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            if (accsToInsert.size() > 0) {
                WSAccount.insertAccount(JSON.serialize(accsToInsert));
            }
            Id jobId2 = Test.isRunningTest() ? null : System.enqueueJob(new WSQueueableDireccion.QueueableDireccionInsert(dirsToInsert, dirsToUpdate));
            System.debug(jobId2);
        }
    }
}