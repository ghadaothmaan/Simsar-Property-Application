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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author menna
 */
@WebServlet(urlPatterns = {"/getAd"})
public class getAd extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            
            String adID = request.getParameter("ID");
            Integer adsID = Integer.parseInt(adID);

            String title = "", rentsell = "", description = "",
                    status = "", type = "", publishDate = "",
                    name = "", email = "", phone = "", city = "", region = "", country = "";

            Integer price = 0, userID = 0, active = 0, size = 0, floor = 0, rate = 0;
            float mapLat = 0, mapLng = 0;

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
            PreparedStatement statement = connection.prepareStatement("SELECT * FROM advertisement WHERE adsID = ?");
            statement.setInt(1, adsID);
            ResultSet result = statement.executeQuery();
            Ad ad = new Ad();

            while (result.next()) {
                title = result.getString("title");
                userID = result.getInt("userID");
                rentsell = result.getString("rentsell");
                size = result.getInt("size");
                description = result.getString("description");
                floor = result.getInt("floor");
                status = result.getString("status");
                type = result.getString("type");
                publishDate = result.getString("publishDate");
                price = result.getInt("price");
                mapLat = result.getFloat("mapLat");
                mapLng = result.getFloat("mapLng");
                rate = result.getInt("rate");
                city = result.getString("city");
                region = result.getString("region");
                country = result.getString("country");
                active = result.getInt("active");
                ad = new Ad(adsID, userID, title, rentsell, size, description, floor, status, type, price, publishDate, mapLat, mapLng, city, region, rate, country, active);
            }
            Gson gson = new Gson();
            String json = gson.toJson(ad);
            System.out.println("Ad: " + json);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
        }
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
            Logger.getLogger(getAd.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(getAd.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(getAd.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(getAd.class.getName()).log(Level.SEVERE, null, ex);
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
