trigger Task_afterInsert_afterUpdate on Task (after insert, after update) {
    LastActivityManager acm = new LastActivityManager();
    acm.updateLastActivity(trigger.newMap.values(), false);
    
    CustomerHealthManager chm = new CustomerHealthManager();
    chm.updateLastCustomerContact(trigger.newMap.values(), false);
}