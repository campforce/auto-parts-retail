public class Constant {

    public final static Integer GOOGLE_API_KEY {
        get {
            return Integer.valueOf(get('GOOGLE_API_KEY'));
        }
    }

    static String get(String key) {
        return Constant__mdt.getInstance(key)?.Value__c;
    }
}
