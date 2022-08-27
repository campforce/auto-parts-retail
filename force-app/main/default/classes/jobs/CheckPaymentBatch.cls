public class CheckPaymentBatch implements Database.Batchable<Sobject>, Schedulable {

    public void execute(SchedulableContext sc) {
        CheckPaymentBatch batch = new CheckPaymentBatch();
        Database.executeBatch(batch, 10);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name, Is_Paid__c, Penalty_Cost__c, Purchase_Date__c FROM Car__c where Is_Paid__c=FALSE');
    }

    public void execute(Database.BatchableContext bc, List<Car__c> records) {
        List<Car__c> newCarList = new List<Car__c>();
        for (Car__c c : records) {
            if (System.today().daysBetween(Date.valueOf(c.Purchase_Date__c)) > 10) {
                c.Penalty_Cost__c = 300;
                newCarList.add(c);
            } else if (System.today().daysBetween(Date.valueOf(c.Purchase_Date__c)) > 3) {
                c.Penalty_Cost__c = 50;
                newCarList.add(c);
            }
        }
        update newCarList;
    }

    public void finish(Database.BatchableContext bc) {
    }
}
