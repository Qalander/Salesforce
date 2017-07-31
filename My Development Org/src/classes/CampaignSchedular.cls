global class CampaignSchedular implements Schedulable {
	
	global static String sched = '0 1 * * * ?';
	
	global String scheduleMe() { 
        CampaignSchedular CS = new CampaignSchedular();  
		return System.schedule('Batch CampaignSchedular', sched, CS); 
    	
    }
	
	global void execute(SchedulableContext sc)
	{
		CampaignHandler handler = new CampaignHandler();
		handler.updateAllCampaigns();
	}
}