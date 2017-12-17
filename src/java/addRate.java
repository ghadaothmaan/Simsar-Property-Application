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
@WebServlet(urlPatterns = {"/addRate"})
public class addRate extends HttpServlet {

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
        PrintWriter out = response.getWriter();

        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");

        int rate = Integer.parseInt(request.getParameter("rate"));
        HttpSession session = request.getSession();
        int userID = (int) session.getAttribute("userID");
        int adID = Integer.parseInt(request.getParameter("adID"));

        System.out.println("heeeeeeeeeee");
        PreparedStatement statement = connection.prepareStatement("INSERT INTO adsrates (rateAdID, rateUserID, rate) VALUES (?,?,?)");
        statement.setInt(1, adID);
        statement.setInt(2, userID);
        statement.setInt(3, rate);

        statement.executeUpdate();

        PreparedStatement statement2 = connection.prepareStatement("SELECT AVG(rate) AS avgrate FROM adsrates WHERE rateAdID = ?");
        statement2.setInt(1, adID);
        ResultSet rs = statement2.executeQuery();
        int averageRate = 0;
        while (rs.next()) {
            averageRate = (int) rs.getFloat("avgrate");
        }

        PreparedStatement statement3 = connection.prepareStatement("UPDATE advertisement SET rate = ? WHERE adsID = ?");
        statement3.setInt(1, averageRate);
        statement3.setInt(2, adID);
        statement3.execute();

        connection.close();

//        RequestDispatcher rd = request.getRequestDispatcher("viewAd.jsp?ID=" + adID);
        //System.out.println(request.getParameter("adID"));
//        rd.forward(request, response);
        response.sendRedirect("viewAd.jsp?ID=" + adID);

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
            Logger.getLogger(addRate.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addRate.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(addRate.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addRate.class.getName()).log(Level.SEVERE, null, ex);
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
