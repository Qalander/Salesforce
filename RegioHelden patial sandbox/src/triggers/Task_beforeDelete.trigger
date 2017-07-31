trigger Task_beforeDelete on Task (before delete) {
    LastActivityManager acm = new LastActivityManager();
    acm.updateLastActivity(trigger.oldMap.values(), true);
}