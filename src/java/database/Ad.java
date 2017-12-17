/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database;

/**
 *
 * @author menna
 */
public class Ad {
    public int adsID;
    public int userID;
    public String title;
    public String rentsell;
    public int size;
    public String description;
    public int floor;
    public String status;
    public String type;
    public int price;
    public String publishDate;
    public float mapLat;
    public float mapLng;
    public String city;
    public String region;
    public int rate;
    public String country;
    public int active;
    
    public Ad() {
        
    }
    public Ad(Integer adsID, Integer userID, String title, String rentsell, Integer size, String description, int floor, String status, String type, int price, String publishDate, float mapLat, float mapLng, String city, String region, int rate, String country, int active) {
        this.adsID = adsID;
        this.userID = userID;
        this.title = title;
        this.rentsell = rentsell;
        this.size = size;
        this.description = description;
        this.floor = floor;
        this.status = status;
        this.type = type;
        this.price = price;
        this.publishDate = publishDate;
        this.mapLat = mapLat;
        this.mapLng = mapLng;
        this.city = city;
        this.region = region;
        this.rate = rate;
        this.country = country;
        this.active = active;
    }
    
    
}
