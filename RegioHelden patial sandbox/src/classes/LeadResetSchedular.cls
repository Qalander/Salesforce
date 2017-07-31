global class LeadResetSchedular implements Schedulable {
	
	global void execute(SchedulableContext sc)
	{
		LeadHandler.resetLeads();
	}
}