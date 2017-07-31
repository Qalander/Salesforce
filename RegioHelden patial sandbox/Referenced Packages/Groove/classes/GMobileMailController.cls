/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GMobileMailController {
    global GMobileMailController() {

    }
    @RemoteAction
    global static void changeThreadLabels(String threadId, List<String> addLabelIds, List<String> removeLabelIds) {

    }
    @RemoteAction
    global static List<List<SObject>> contactLeadUserSearch(String q) {
        return null;
    }
    @RemoteAction
    global static DaScoopComposer.GMobileMailController.ContextualData getContextualData(String email) {
        return null;
    }
    @RemoteAction
    global static DaScoopComposer.GMobileEmailObjects.EmailMessage getEmailMessage(String messageId) {
        return null;
    }
    @RemoteAction
    global static List<DaScoopComposer.GMobileEmailObjects.EmailMessage> getEmailThread(String threadId) {
        return null;
    }
    @RemoteAction
    global static List<DaScoopComposer.GMobileEmailObjects.EmailThread> getEmailThreads2(String bucket) {
        return null;
    }
    @RemoteAction
    global static List<DaScoopComposer.GMobileEmailObjects.EmailThread> getEmailThreads(String bucket) {
        return null;
    }
    @RemoteAction
    global static DaScoopComposer.GMobileMailController.FolderSet getFoldersList() {
        return null;
    }
    @RemoteAction
    global static String gmailAuthProviderUrl() {
        return null;
    }
    @RemoteAction
    global static Boolean logInboundEmail(String fromEmail, String to, String cc, String subject, String textBody, String htmlBody, String messageId, String rfcMessageId, String whoId, String whatId) {
        return null;
    }
    @RemoteAction
    global static Boolean sendEmail(String to, String cc, String subject, String textBody, String htmlBody, String threadId, String inReplyToId, String whoId, String whatId, String templateId, Boolean isTracked) {
        return null;
    }
global class ContextualData {
    global ContextualData() {

    }
}
global class FolderSet {
    global FolderSet() {

    }
}
}
