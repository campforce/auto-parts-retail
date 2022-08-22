global class ScheduleStorageChargeCheckBatch implements Schedulable{
    global void execute(SchedulableContext sc){

        StorageChargeCheckBatch b = new StorageChargeCheckBatch();
        database.executeBatch(b);
        
    }
}
