public class MyCaseControllerExt {

    private final Case caseObj;

    // get Case record from the standard controller and putting it in a member variable
    public MyCaseControllerExt (ApexPages.StandardController stdController) {
        this.caseObj = (Case)stdController.getRecord();
    }

    public PageReference save(){
        // TO DO
        return null;

    }

}