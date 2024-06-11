public with sharing class TrgControllerAccount {
    
    Map<Id, Account> newAccounts = new Map<Id, Account>();
    Map<Id, Account> oldAccounts = new Map<Id, Account>();
    
    public TrgControllerAccount() {

        newAccounts = (Map<Id, Account>) Trigger.newMap;
        oldAccounts = (Map<Id, Account>) Trigger.oldMap;

        Map<Id, Schema.RecordTypeInfo> recordTypeInfoMap = Schema.SObjectType.Account.getRecordTypeInfosById();

        Map<Id, Account> accounts = new Map<Id, Account>();

        /**
         * AL INSERTAR UNA CUENTA DE TIPO CLIENTE, SE REALIZARÁ UNA INSERCIÓN EN EL SISTEMA EXTERNO.
         */

        if (Trigger.isAfter && Trigger.isInsert) {
            for (Account newAccount : newAccounts.values()) {
                if (recordTypeInfoMap.get(newAccount.RecordTypeId).getName() == 'Cliente') {
                    accounts.put(newAccount.Id, newAccount);
                }
            }
        }

        /**
         * SI UNA CUENTA DE TIPO CLIENTE POTENCIAL PASA AL TIPO CLIENTE, SE REALIZARÁ UNA INSERCIÓN EN EL SISTEMA EXTERNO. 
         */

        if (Trigger.isAfter && Trigger.isUpdate) {
            for (Account newAccount : newAccounts.values()) {
                Account oldAccount = oldAccounts.get(newAccount.Id);
                if (recordTypeInfoMap.get(newAccount.RecordTypeId).getName() == 'Cliente' && recordTypeInfoMap.get(oldAccount.RecordTypeId).getName() == 'Cliente Potencial') {
                    accounts.put(newAccount.Id, newAccount);
                }
            }
        }

        if (accounts.size() > 0) {
            Id jobId1 = System.enqueueJob(new QueueableAccount(accounts));
            System.debug(jobId1);
        }
        
    }

    public class QueueableAccount implements Queueable, Database.AllowsCallouts {

        private Map<Id, Account> accsToInsert;

        public QueueableAccount(Map<Id, Account> accsToInsert_x) {
            this.accsToInsert = accsToInsert_x;
        }

        public void execute(System.QueueableContext context) {
            if (accsToInsert.size() > 0) {
                WSAccount.insertAccount(JSON.serialize(accsToInsert));
            }
        }
    }

}