/** Owner Copy
* @Author: Tarek Schmidt
* @Description: Copy´s the Account Owner into a Custom field for Formula proposes
* @Param: Account
* @return: void
**/

trigger OwnerCopy on Account (before insert, before update)
{
	/*
        for (Account a : Trigger.new)
    {
            a.Owner_Copy__c = a.OwnerId;
    }
    */
}