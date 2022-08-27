public with sharing class DismantledCarsMonthlyReportSchedulable implements Schedulable{
    public void execute(System.SchedulableContext sc) {
        Date firstDate = Date.today().toStartOfMonth();
        Date lastDate = firstDate.addMonths(1).toStartofMonth().addDays(-1);
        Integer count = [Select Count() From Car__c Where Dismantled_Date__c >= :firstDate AND Dismantled_Date__c <= :lastDate];

        Messaging.reserveSingleEmailCapacity(2);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddresses = new String[] {'derbolb@gmail.com'};
            
        mail.setToAddresses(toAddresses);

        mail.setSenderDisplayName('Erbol');

        mail.setSubject('Monthly Dismantled Cars Report');

        if (count == 0){
            mail.setHtmlBody('In this month cars was not dismantled');
        }
        else if (count == 1){
            mail.setHtmlBody('In this month ' + count + ' car was dismantled');
        }
        else if (count > 1){
            mail.setHtmlBody('In this month ' + count + ' cars were dismantled');
        }

        Messaging.sendEmail(new Messaging.Email[] { mail });
    }
}