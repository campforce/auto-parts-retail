public class Constant {

    public final static String GOOGLE_API_KEY {
        get {
            return get('GOOGLE_API_KEY');
        }
    }

    static String get(String key) {
        return Constant__mdt.getInstance(key)?.Value__c;
    }
}
