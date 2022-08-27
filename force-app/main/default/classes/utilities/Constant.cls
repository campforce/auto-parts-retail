public class Constant {

    public final static String GOOGLE_API_KEY {
        get {
            return get('GOOGLE_API_KEY');
        }
    }
    public final static String CURRENCY_API_KEY {
        get {
            return get('CURRENCY_API_KEY');
        }
    }

    static String get(String key) {
        return Constant__mdt.getInstance(key)?.Value__c;
    }
}
