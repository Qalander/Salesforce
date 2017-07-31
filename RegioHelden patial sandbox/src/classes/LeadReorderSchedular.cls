global class LeadReorderSchedular {
    
	global void execute(SchedulableContext sc)
	{
		LeadHandler.reorderLeads();
	}
}