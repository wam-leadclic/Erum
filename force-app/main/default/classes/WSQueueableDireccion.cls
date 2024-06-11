public with sharing class WSQueueableDireccion {
    
    public class QueueableDireccionInsert implements Queueable, Database.AllowsCallouts {

        private Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert;
        private Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate;

        public QueueableDireccionInsert(Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert_x, Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate_x) {
            this.dirsToInsert = dirsToInsert_x;
            this.dirsToUpdate = dirsToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            if (dirsToInsert.size() > 0) {
                WSDireccion.insertDireccion(JSON.serialize(dirsToInsert));
            }
            Id jobId3 = Test.isRunningTest() ? null : System.enqueueJob(new QueueableDireccionUpdate(dirsToUpdate));
            System.debug(jobId3);
        }
    }

    public class QueueableDireccionUpdate implements Queueable, Database.AllowsCallouts {

        private Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate;

        public QueueableDireccionUpdate(Map<Id, ERUM_Direcciones_Envio__c> dirsToUpdate_x) {
            this.dirsToUpdate = dirsToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            if (dirsToUpdate.size() > 0) {
                WSDireccion.updateDireccion(JSON.serialize(dirsToUpdate));
            }
        }
    }
}