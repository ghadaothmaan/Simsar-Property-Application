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
import java.sql.ResultSet;
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
@WebServlet(urlPatterns = {"/addUserInterest"})
public class addUserInterest extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @throws java.lang.ClassNotFoundException
     * @throws java.sql.SQLException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            String country = "", city = "", type = "", rentOrsell = "", status = "";

            if (request.getParameter("country") == null) {
                country = "";
            } else {
                country = request.getParameter("country");
            }

            if (request.getParameter("city") == null) {
                city = "";
            } else {
                city = request.getParameter("city");
            }

            if (request.getParameter("type") == null) {
                type = "";
            } else {
                type = request.getParameter("type");
            }

            if (request.getParameter("rentOrsell") == null) {
                rentOrsell = "";
            } else {
                rentOrsell = request.getParameter("rentOrsell");
            }

            if (request.getParameter("status") == null) {
                status = "";
            } else {
                status = request.getParameter("status");
            }

            Integer sizeFrom, sizeTo, priceFrom, priceTo, userID = -1;

            if (request.getParameter("sizeFrom") == null) {
                sizeFrom = -1;
                sizeTo = -1;
            } else {

                if (request.getParameter("sizeFrom").equals("")) {
                    sizeFrom = -1;
                    sizeTo = -1;
                } else {
                    sizeFrom = Integer.parseInt(request.getParameter("sizeFrom"));
                    sizeTo = Integer.parseInt(request.getParameter("sizeTo"));
                }
            }

            if (request.getParameter("priceFrom") == null) {
                priceFrom = -1;
                priceTo = -1;
            } else {

                if (request.getParameter("priceFrom").equals("")) {

                    priceFrom = -1;
                    priceTo = -1;

                } else {
                    priceFrom = Integer.parseInt(request.getParameter("priceFrom"));
                    priceTo = Integer.parseInt(request.getParameter("priceTo"));
                }
            }

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
            PreparedStatement pstmt = null;
            ResultSet results = null;
            Integer interestID = -1;
            String query;
            HttpSession session = request.getSession();
            userID = (Integer) session.getAttribute("userID");

            // Check if interest in table
            query = "SELECT * FROM interests WHERE type = ? AND rentsale = ? AND status = ? AND priceFrom = ?"
                    + " AND priceTo = ? AND sizeFrom = ? AND sizeTo = ? AND country = ? AND city = ?";
            pstmt = connection.prepareStatement(query);
            pstmt.setString(1, type);
            pstmt.setString(2, rentOrsell);
            pstmt.setString(3, status);
            pstmt.setInt(4, priceFrom);
            pstmt.setInt(5, priceTo);
            pstmt.setInt(6, sizeFrom);
            pstmt.setInt(7, sizeTo);
            pstmt.setString(8, country);
            pstmt.setString(9, city);
            results = pstmt.executeQuery();

            if (!results.isBeforeFirst()) {

                query = "INSERT INTO interests(type, rentsale, status, priceFrom, priceTo, "
                        + "sizeFrom, sizeTo, country, city) VALUES(?,?,?,?,?,?,?,?,?)";
                pstmt = connection.prepareStatement(query);
                pstmt.setString(1, type);
                pstmt.setString(2, rentOrsell);
                pstmt.setString(3, status);
                pstmt.setInt(4, priceFrom);
                pstmt.setInt(5, priceTo);
                pstmt.setInt(6, sizeFrom);
                pstmt.setInt(7, sizeTo);
                pstmt.setString(8, country);
                pstmt.setString(9, city);
                pstmt.executeUpdate();

                query = "SELECT * FROM interests WHERE type = ? AND rentsale = ? AND status = ? AND priceFrom = ? "
                        + "AND priceTo = ? AND sizeFrom = ? AND sizeTo = ? AND country = ? AND city = ?";
                pstmt = connection.prepareStatement(query);
                pstmt.setString(1, type);
                pstmt.setString(2, rentOrsell);
                pstmt.setString(3, status);
                pstmt.setInt(4, priceFrom);
                pstmt.setInt(5, priceTo);
                pstmt.setInt(6, sizeFrom);
                pstmt.setInt(7, sizeTo);
                pstmt.setString(8, country);
                pstmt.setString(9, city);
                results = pstmt.executeQuery();

                while (results.next()) {
                    interestID = results.getInt("interestID");
                }

            } else {
                while (results.next()) {
                    interestID = results.getInt("interestID");
                }
            }

            //to check if user have same interest
            query = "SELECT * FROM userinterests WHERE interestUserID = ? AND interestID = ? ";
            pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, userID);
            pstmt.setInt(2, interestID);
            results = pstmt.executeQuery();

            if (!results.isBeforeFirst()) {
                
                query = "INSERT INTO userinterests(interestUserID, interestID) VALUES(?,?) ";
                pstmt = connection.prepareStatement(query);
                pstmt.setInt(1, userID);
                pstmt.setInt(2, interestID);
                pstmt.executeUpdate();
                
            }
            

            pstmt.close();
            results.close();
            connection.close();
            
            response.sendRedirect("home.jsp");

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
            Logger.getLogger(addUserInterest.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addUserInterest.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(addUserInterest.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addUserInterest.class.getName()).log(Level.SEVERE, null, ex);
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
