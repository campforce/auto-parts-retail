trigger MailToTrigger on Container__c (after insert, after update) {
   
    MailToManagerTriggerHandler.SendEmailNotification(Trigger.new);
   
}
    