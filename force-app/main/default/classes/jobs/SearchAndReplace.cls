public class SearchAndReplace implements Database.Batchable<sObject>{

    public final String Query;
    public final String Entity;
    public final String Field;
    public final String Value;
 
    public SearchAndReplace(String q, String e, String f, String v){
 
       Query=q; Entity=e; Field=f;Value=v;
    }
 
    public Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope){
      for(sobject s : scope){
      s.put(Field,Value); 
      }
      update scope;
     }
 
    public void finish(Database.BatchableContext BC){
    }
 }