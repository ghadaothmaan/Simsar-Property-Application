package database;

/**
*
 * @author bayan
 */
public class Notification {
    
    public Integer notificationID;
    public Integer notificationAdID;
    public String notificationDate;
    public String notification;
    public String isViewed;
    public String viewDate;
    
    public Notification(){
        
    }
    
    public Notification(Integer notificationID, Integer notificationAdID, String notificationDate, String notification, String isViewed, String viewDate ){
        
        this.notificationID = notificationID;
        this.notificationAdID = notificationAdID;
        this.notificationDate = notificationDate;
        this.notification = notification;
        this.isViewed = isViewed; 
        this.viewDate = viewDate;
        
    }
    
    
}
