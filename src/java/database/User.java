package database;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Salma-Hassan
 */
public class User {
    public Integer id;
    public String name;
    public String email;
    public String username;
    public String password;
    public String address;
    public String phone;
    
    public User() {
        
    }
    public User(Integer id, String name, String email, String username, String password, String address, String phone) {
        this.id = id;
        this.username = username;
        this.name = name;
        this.password = password;
        this.address = address;
        this.phone = phone;
        this.email = email;
    }
    public User(String name, String email, String phone) {
        this.name = name;
        this.email = email;
        this.phone = phone;
    }
    public User(Integer userID, String username, String password) {
        this.id = userID;
        this.username = username;
        this.password = password;
    }
    
}
