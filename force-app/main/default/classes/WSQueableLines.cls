public with sharing class WSQueableLines {
    
    public class QueueableOpportunityLineInsert implements Queueable, Database.AllowsCallouts {

        private Map<Id, List<OpportunityLineItem>> linesToInsert;
        private Map<Id, List<OpportunityLineItem>> linesToUpdate;
        private Map<Id, String> oppNos;

        public QueueableOpportunityLineInsert(Map<Id, List<OpportunityLineItem>> linesToInsert_x, Map<Id, List<OpportunityLineItem>> linesToUpdate_x, Map<Id, String> oppNos_x) {
            this.linesToInsert = linesToInsert_x;
            this.linesToUpdate = linesToUpdate_x;
            this.oppNos = oppNos_x;
        }

        public void execute(System.QueueableContext context) {
            if (linesToInsert.size() > 0) {
                WSOpportunity.insertOpportunityLine(JSON.serialize(linesToInsert), oppNos);
            }
            Id jobId6 = Test.isRunningTest() ? null : System.enqueueJob(new QueueableOpportunityLineUpdate(linesToUpdate));
            System.debug(jobId6);
        }
    }

    public class QueueableOpportunityLineUpdate implements Queueable, Database.AllowsCallouts {

        private Map<Id, List<OpportunityLineItem>> linesToUpdate;

        public QueueableOpportunityLineUpdate(Map<Id, List<OpportunityLineItem>> linesToUpdate_x) {
            this.linesToUpdate = linesToUpdate_x;
        }

        public void execute(System.QueueableContext context) {
            if (linesToUpdate.size() > 0) {
                WSOpportunity.updateOpportunityLine(JSON.serialize(linesToUpdate));
            }
        }
    }
}