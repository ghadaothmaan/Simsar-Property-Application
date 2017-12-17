/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.google.gson.Gson;
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
@WebServlet(urlPatterns = {"/getUserAds"})
public class getUserAds extends HttpServlet {

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
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");
        PreparedStatement statement = connection.prepareStatement("SELECT * FROM advertisement WHERE userID = " + userID);
        ResultSet result = statement.executeQuery();
        String title = "";
        Integer adsID = -1;
        ArrayList<Pair> activeAds = new ArrayList();
        ArrayList<Ad> userAds = new ArrayList();

        while (result.next()) {
            adsID = result.getInt("adsID");
            title = result.getString("title");
            String rentsell = result.getString("rentsell");
            Integer size = result.getInt("size");
            String description = result.getString("description");
            Integer floor = result.getInt("floor");
            String status = result.getString("status");
            String type = result.getString("type");
            Integer price = result.getInt("price");
            String publishDate = result.getString("publishDate");
            Float mapLat = result.getFloat("mapLat");
            Float mapLng = result.getFloat("mapLng");
            String city = result.getString("city");
            String region = result.getString("region");
            Integer rate = result.getInt("rate");
            String country = result.getString("country");
            Integer active = result.getInt("active");
            Ad ad = new Ad(adsID, userID, title, rentsell, size, description, floor, status, type, price, publishDate, mapLat, mapLng, city, region, rate, country, active);
            userAds.add(ad);
        }

        Gson gson = new Gson();
        String json = gson.toJson(userAds);
        System.out.println(json);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);

        connection.close();
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
        } catch (SQLException ex) {
            Logger.getLogger(getActiveAds.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(getActiveAds.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (SQLException ex) {
            Logger.getLogger(getActiveAds.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(getActiveAds.class.getName()).log(Level.SEVERE, null, ex);
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
