trigger Task_afterDelete  on Task (after delete) {
    CustomerHealthManager chm = new CustomerHealthManager();
    chm.updateLastCustomerContact(trigger.oldMap.values(), true);

}