/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author bayan
 */
@WebServlet(urlPatterns = {"/UpdateUserAd"})
public class UpdateUserAd extends HttpServlet {

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
            
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");

            String title, description, status, type, floor, rentsell, map_lat, map_lng, city, region, adID, country, size, price;

            adID = request.getParameter("adID");
            HttpSession session = request.getSession();
            Integer userID = (Integer) session.getAttribute("userID");
            
            title = request.getParameter("title");
            description = request.getParameter("description");
            status = request.getParameter("status");
            type = request.getParameter("type");
            floor = request.getParameter("floor");
            rentsell = request.getParameter("rentOrsell");
            size = request.getParameter("size");
            price = request.getParameter("price");
            city = request.getParameter("city");
            region = request.getParameter("region");
            map_lat = request.getParameter("map_lat");
            map_lng = request.getParameter("map_lng");
            country = request.getParameter("country");

            int priceInt = 0;
            if (!price.equals(""))
                priceInt = Integer.parseInt(price);
            
            double mapLat = 0, mapLng = 0;
            if (!map_lat.equals("") && !map_lng.equals("")){
                mapLat = Double.parseDouble(map_lat); 
                mapLng = Double.parseDouble(map_lng);
            }

            PreparedStatement statement = connection.prepareStatement("UPDATE advertisement SET title = ?, rentsell = ?, size = ?, description = ?, floor = ?, status = ?, type = ?, price = ?, mapLat = ?, mapLng = ?, city = ?, region = ?, country = ? WHERE adsID = ? AND userID = ? ");
            statement.setString(1, title);
            statement.setString(2, rentsell);
            statement.setString(3, size);
            statement.setString(4, description);
            statement.setString(5, floor);
            statement.setString(6, status);
            statement.setString(7, type);
            statement.setString(8, price);
            statement.setDouble(9, mapLat);
            statement.setDouble(10, mapLng);
            statement.setString(11, city);
            statement.setString(12, region);
            statement.setString(13, country);
            statement.setString(14, adID);
            statement.setString(15, userID.toString());

            statement.execute();

            connection.close();

            response.sendRedirect("viewAd.jsp?ID=" + adID);
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
            Logger.getLogger(UpdateUserAd.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateUserAd.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(UpdateUserAd.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateUserAd.class.getName()).log(Level.SEVERE, null, ex);
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
