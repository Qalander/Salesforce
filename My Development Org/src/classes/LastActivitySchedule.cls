/**
 * Scheduler for daily update of last activity field
 */
global with sharing class LastActivitySchedule implements Schedulable {
	
	/**
	 * Schedules last activity update for every hour
	 */
    global static String cron_exp = '0 0 * * * ?';
    
	global String startSchedule() {
		//String cron_exp = '0 0 * * * ?';
		return System.schedule('name', cron_exp, this);
	}
	
/*
    global String scheduleMe() { 
        CampaignSchedular CS = new CampaignSchedular();  
		return System.schedule('Batch CampaignSchedular', sched, CS); 
    	
    }
*/
	/**
	 * Executes batch job for update of last activity field for every account and every lead
	 */
	global void execute(SchedulableContext sc) {
		LastActivityBatch batch = new LastActivityBatch();
		Database.executeBatch(batch);
	}

}