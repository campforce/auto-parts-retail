public with sharing class MapController {
    
    /**
     * Controller for map to get Auction address.
     * 
     * @param accountId
     * @author belekomurzakov
     */
    @AuraEnabled(cacheable=true)
    public static Account getAccountById(Id accountId){
        return [SELECT BillingStreet, BillingCity, BillingCountry FROM Account WHERE Id =: accountId];
    }
}
