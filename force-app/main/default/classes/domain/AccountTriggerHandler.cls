public class AccountTriggerHandler extends TriggerHandler {

    private List<Account> newAccountList;
    private List<Account> oldAccountList;
    private Map<Id, Account> newAccountMap;
    private Map<Id, Account> oldAccountMap;

    public AccountTriggerHandler() {
        this.newAccountList = (List<Account>) Trigger.new;
        this.oldAccountList = (List<Account>) Trigger.old;
        this.newAccountMap = (Map<Id, Account>) Trigger.newMap;
        this.oldAccountMap = (Map<Id, Account>) Trigger.oldMap;
    }

    public override void beforeUpdate() {
        AccountService.demonstrativeMethod(oldAccountMap, newAccountMap);
    }
    public override void BeforeInsert() {
        
        AccountService.beforeInsert(this.newAccountList);   
    }
    
    public override void afterInsert() {
        
        System.enqueueJob(new GeolocationQueueable(newAccountList));
        
    }
    public override void afterupdate() { 
        System.enqueueJob(new GeolocationQueueable(newAccountList));
    }
}
