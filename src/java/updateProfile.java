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
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Salma-Hassan
 */
@WebServlet(urlPatterns = {"/updateProfile"})
public class updateProfile extends HttpServlet {

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

            // set new user information
            HttpSession session = request.getSession();
            Integer userID = (Integer) session.getAttribute("userID");

            String name, email, password, newpassword, address, phone, oldpassword;

            name = request.getParameter("name");
            email = request.getParameter("email");
            password = request.getParameter("password");
            newpassword = request.getParameter("newpassword");
            oldpassword = request.getParameter("oldpassword");
            System.out.println("oldpassword  " + oldpassword + "  newpassword  " + newpassword);

            if (!newpassword.equals("")) {
                System.out.println("elseeeeeeeeee");
                if (oldpassword.equals("")) {
                    request.setAttribute("status", "nopassword");
                    RequestDispatcher rd = request.getRequestDispatcher("editProfile.jsp");
                    rd.forward(request, response);
                } else {
                    if (!oldpassword.equals(password)) {
                        request.setAttribute("status", "wrongpassword");
                        RequestDispatcher rd = request.getRequestDispatcher("editProfile.jsp");
                        rd.forward(request, response);
                    } else {
                        password = newpassword;
                    }
                }
            }

            address = request.getParameter("address");
            phone = request.getParameter("phone");

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
            PreparedStatement statement = connection.prepareStatement("UPDATE user SET name = ?, email = ?, password = ?, address = ?, phone = ? WHERE id = ?");
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, password);
            statement.setString(4, address);
            statement.setString(5, phone);
            statement.setInt(6, userID);
            statement.execute();
            connection.close();

            response.sendRedirect("viewProfile.jsp?ID=" + userID);
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
            Logger.getLogger(updateProfile.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(updateProfile.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(updateProfile.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(updateProfile.class.getName()).log(Level.SEVERE, null, ex);
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
