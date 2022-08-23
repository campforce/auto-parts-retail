public class StorageChargeCheckSchedulable implements Schedulable {
    public void execute(SchedulableContext sc){
        StorageChargeCheckBatch b = new StorageChargeCheckBatch();
        database.executeBatch(b);
    }
}