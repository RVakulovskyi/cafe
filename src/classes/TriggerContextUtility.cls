public class TriggerContextUtility {

    private static boolean firstRun = true;

    public static boolean isFirstRun() {
        return firstRun;
    }
    public static void setFirstRunFalse(){
        firstRun = false;
    }
    public static void setFirstRunTrue(){
        firstRun = true;
    }
}