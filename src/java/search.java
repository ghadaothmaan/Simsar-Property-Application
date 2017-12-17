/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import database.Ad;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.util.Pair;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author menna
 */
@WebServlet(urlPatterns = {"/search"})
public class search extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        Integer sizeFrom, sizeTo, priceFrom, priceTo;
        if (request.getParameter("sizeFrom").equals("")) {
            sizeFrom = null;
            sizeTo = null;
        } else {
            sizeFrom = Integer.parseInt(request.getParameter("sizeFrom"));
            sizeTo = Integer.parseInt(request.getParameter("sizeTo"));
        }
        if (request.getParameter("priceFrom").equals("")) {
            priceFrom = null;
            priceTo = null;
        } else {
            priceFrom = Integer.parseInt(request.getParameter("priceFrom"));
            priceTo = Integer.parseInt(request.getParameter("priceTo"));
        }
        String country = request.getParameter("country");
        String city = request.getParameter("city");
        String type = request.getParameter("type");
        String rentOrsell = request.getParameter("rentOrsell");
        String status = request.getParameter("status");
        System.out.println(sizeFrom + " " + sizeTo + " " + priceFrom + " " + priceTo + " " + country + " " + city + " " + type + " " + rentOrsell);
        
        PrintWriter out = response.getWriter();
        
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
        int count = 0;
        String query = "SELECT * FROM advertisement "; // gets all
        if(country != null && !country.equals("")) {
            if (count == 0) query += "WHERE country = '" + country + "'";
            else query += " AND country = '" + country + "'";
            count++;
        }
        if(city != null && !city.equals("")) {
            if (count == 0) query += "WHERE city = '" + city + "'";
            else query += " AND city = '" + city + "'";
            count++;
        }
        if(type != null && !type.equals("")) {
            if (count == 0) query += "WHERE type ='" + type + "'";
            else query += " AND type = '" + type + "'";
            count++;
        }
        if(rentOrsell != null && !rentOrsell.equals("")) {
            if (count == 0) query += "WHERE rentsell = '" + rentOrsell + "'";
            else query += " AND rentsell = '" + rentOrsell + "'";
            count++;
        }
        if(sizeFrom != null) {
            if (count == 0) query += "WHERE size BETWEEN " + sizeFrom + " AND " + sizeTo;
            else query += " AND size BETWEEN " + sizeFrom + " AND " + sizeTo;
            count++;
        }
        if(sizeFrom != null) {
            if (count == 0) query += "WHERE price BETWEEN " + priceFrom + " AND " + priceTo;
            else query += " AND price BETWEEN " + priceFrom + " AND " + priceTo;
            count++;
        }
        if (status != null && !status.equals("")) {
            if (count == 0) query += "WHERE status ='" + status + "'";
            else query += " AND status = '" + status + "'";
            count++;
        }
        System.out.println(query);
        PreparedStatement statement = connection.prepareStatement(query);
        ResultSet result = statement.executeQuery();
        ArrayList<Ad> ads = new ArrayList();
        while (result.next()) {
            Integer adsID = result.getInt("adsID");
            String title = result.getString("title");
            String rentsell = result.getString("rentsell");
            Integer size = result.getInt("size");
            String description = result.getString("description");
            Integer floor = result.getInt("floor");
            String adstatus = result.getString("status");
            String adtype = result.getString("type");
            Integer price = result.getInt("price");
            String publishDate = result.getString("publishDate");
            Float mapLat = result.getFloat("mapLat");
            Float mapLng = result.getFloat("mapLng");
            String adcity = result.getString("city");
            String region = result.getString("region");
            Integer rate = result.getInt("rate");
            String adcountry = result.getString("country");
            Integer active = result.getInt("active");
            Ad ad = new Ad(adsID, userID, title, rentsell, size, description, floor, adstatus, adtype, price, publishDate, mapLat, mapLng, adcity, region, rate, adcountry, active);
            ads.add(ad);
        }
        request.setAttribute("ads", ads);
        
        RequestDispatcher rd = request.getRequestDispatcher("searchResult.jsp");
        rd.forward(request, response);
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(search.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(search.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(search.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(search.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
