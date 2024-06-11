public with sharing class TrgController {
    public static Boolean doNotRunTrigger = false;

    public static void setDoNotRunTrigger(){
        doNotRunTrigger = true;
    }
    
    public static Boolean shouldRunTrigger() {
        return !doNotRunTrigger;
    }
}