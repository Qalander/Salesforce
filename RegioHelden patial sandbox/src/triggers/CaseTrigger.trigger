trigger CaseTrigger on Case (after delete, after insert, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(Case.sObjectType);
}