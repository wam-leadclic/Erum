public with sharing class WSQueueableOpp {
    
    public class QueueableDireccionInsert implements Queueable, Database.AllowsCallouts {

        private Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert;
        private Map<Id, Opportunity> oppsToInsert;
        private Map<Id, Opportunity> oppsToUpdate;
        private Map<Id, List<OpportunityLineItem>> linesToInsert;
        private Map<Id, List<OpportunityLineItem>> linesToUpdate;

        public QueueableDireccionInsert(Map<Id, ERUM_Direcciones_Envio__c> dirsToInsert_x, Map<Id, Opportunity> oppsToInsert_x, Map<Id, Opportunity> oppsToUpdate_x, Map<Id, List<OpportunityLineItem>> linesToInsert_x, Map<Id, List<OpportunityLineItem>> linesToUpdate_x) {
            this.dirsToInsert = dirsToInsert_x;
            this.oppsToInsert = oppsToInsert_x;
            this.oppsToUpdate = oppsToUpdate_x;
            this.linesToInsert = linesToInsert_x;
            this.linesToUpdate = linesToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            if (dirsToInsert.size() > 0) {
                WSDireccion.insertDireccion(JSON.serialize(dirsToInsert));
            }
            Id jobId3 = Test.isRunningTest() ? null : System.enqueueJob(new QueueableOppInsert(oppsToInsert, oppsToUpdate, linesToInsert, linesToUpdate));
            System.debug(jobId3);
        }
    }

    public class QueueableOppInsert implements Queueable, Database.AllowsCallouts {

        private Map<Id, Opportunity> oppsToInsert;
        private Map<Id, Opportunity> oppsToUpdate;
        private Map<Id, List<OpportunityLineItem>> linesToInsert;
        private Map<Id, List<OpportunityLineItem>> linesToUpdate;

        public QueueableOppInsert(Map<Id, Opportunity> oppsToInsert_x, Map<Id, Opportunity> oppsToUpdate_x, Map<Id, List<OpportunityLineItem>> linesToInsert_x, Map<Id, List<OpportunityLineItem>> linesToUpdate_x) {
            this.oppsToInsert = oppsToInsert_x;
            this.oppsToUpdate = oppsToUpdate_x;
            this.linesToInsert = linesToInsert_x;
            this.linesToUpdate = linesToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            Map<Id, String> oppNos = null;
            if (oppsToInsert.size() > 0) {
                oppNos = WSOpportunity.insertOpportunity(JSON.serialize(oppsToInsert));
            }
            Id jobId4 = Test.isRunningTest() ? null : System.enqueueJob(new QueueableOppUpdate(oppsToUpdate, linesToInsert, linesToUpdate, oppNos));
            System.debug(jobId4);
        }
    }

    public class QueueableOppUpdate implements Queueable, Database.AllowsCallouts {

        private Map<Id, Opportunity> oppsToUpdate;
        private Map<Id, List<OpportunityLineItem>> linesToInsert;
        private Map<Id, List<OpportunityLineItem>> linesToUpdate;
        Map<Id, String> oppNos;

        public QueueableOppUpdate(Map<Id, Opportunity> oppsToUpdate_x, Map<Id, List<OpportunityLineItem>> linesToInsert_x, Map<Id, List<OpportunityLineItem>> linesToUpdate_x, Map<Id, String> oppNos_x) {
            this.oppsToUpdate = oppsToUpdate_x;
            this.linesToInsert = linesToInsert_x;
            this.linesToUpdate = linesToUpdate_x;
            this.oppNos = oppNos_x;
        }

        public void execute(System.QueueableContext context) {
            if (oppsToUpdate.size() > 0) {
                WSOpportunity.updateOpportunity(JSON.serialize(oppsToUpdate));
            }
            Id jobId5 = Test.isRunningTest() ? null : System.enqueueJob(new WSQueableLines.QueueableOpportunityLineInsert(linesToInsert, linesToUpdate, oppNos));
            System.debug(jobId5);
        }
    }

}