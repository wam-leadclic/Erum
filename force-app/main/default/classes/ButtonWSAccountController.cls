public with sharing class ButtonWSAccountController {

    public Account x_account {get; set;}
    public Boolean accountActivo {get; set;}
    public String accountCodigo {get; set;}
    
    public ButtonWSAccountController(ApexPages.StandardController controller) {
        x_account = (Account) controller.getRecord();
        accountActivo = x_account.ERUM_Activo_ERP__c;
        accountCodigo = x_account.ERUM_Codigo_cliente_ERP__c;
    }

    public PageReference upsertAccount() {
        Map<Id, Account> accounts = new Map<Id, Account>();
        accounts.put(x_account.Id, x_account);
        Id jobId1;
        if (accountActivo) {
            jobId1 = System.enqueueJob(new QueueableAccount(accounts, false));
        } else {
            jobId1 = System.enqueueJob(new QueueableAccount(accounts, true));
        }
        System.debug(jobId1);
        PageReference pageRef = new PageReference('/' + x_account.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public class QueueableAccount implements Queueable, Database.AllowsCallouts {

        private Map<Id, Account> accounts;
        Boolean isInsert;

        public QueueableAccount(Map<Id, Account> accounts_x, Boolean isInsert_x) {
            this.accounts = accounts_x;
            this.isInsert = isInsert_x;
        }

        public void execute(System.QueueableContext context) {
            if (isInsert) {
                WSAccount.insertAccount(JSON.serialize(accounts));
            } else {
                WSAccount.updateAccount(JSON.serialize(accounts));
            }
        }
    }
}