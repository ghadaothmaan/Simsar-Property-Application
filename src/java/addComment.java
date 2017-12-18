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
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author bayan
 */
@WebServlet(urlPatterns = {"/addComment"})
public class addComment extends HttpServlet {

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
            
            String adID, userID, comment, curDate, userName = "", query, notification, adTitle = "", userAdEmail = "";
            Integer userAdID = 0;
            
            adID = request.getParameter("adID");
            userID = request.getParameter("userID");
            comment = request.getParameter("comment");
            
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");  
            LocalDateTime now = LocalDateTime.now();  
            curDate = dtf.format(now);
            
            Class.forName("com.mysql.jdbc.Driver");
            PreparedStatement pstmt = null;
            ResultSet result = null;
                    
            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root")) {
                
                // insert comment
                query = "INSERT INTO adscomments (commentAdID, comment, commentDate, commentUserID) VALUES(?,?,?,?)";
                pstmt = connection.prepareStatement(query);
                pstmt.setString(1, adID);
                pstmt.setString(2, comment);
                pstmt.setString(3, curDate);
                pstmt.setString(4, userID);
                pstmt.executeUpdate();
                
                // get user ad id 
                Integer adsID = Integer.parseInt(adID);
                query = "SELECT * FROM advertisement WHERE adsID = ?";
                pstmt = connection.prepareStatement(query);
                pstmt.setInt(1, adsID);
                result = pstmt.executeQuery();
                
                while (result.next()){
                    userAdID = result.getInt("userID");
                    adTitle = result.getString("title");
                }
                    
                // get name of current user
                Integer id = Integer.parseInt(userID);
                query = "SELECT * FROM user WHERE id = ?";
                pstmt = connection.prepareStatement(query);
                pstmt.setInt(1, id);
                result = pstmt.executeQuery();
                
                while (result.next())
                    userName = result.getString("name");
                
                // get Email of ad user email
                query = "SELECT * FROM user WHERE id = ?";
                pstmt = connection.prepareStatement(query);
                pstmt.setInt(1, userAdID);
                result = pstmt.executeQuery();
                
                while (result.next())
                    userAdEmail = result.getString("email");
                
                // insert notification
                notification = userName + " commented on your ad " + adTitle;
                query = "INSERT INTO notifications (notificationUserID, notificationDate, notification, isViewed, notificationAdID) VALUES(?,?,?,?,?)";
                pstmt = connection.prepareStatement(query);
                pstmt.setString(1, userAdID.toString());
                pstmt.setString(2, curDate);
                pstmt.setString(3, notification);
                pstmt.setString(4, "No");
                pstmt.setInt(5, adsID);
                pstmt.execute();
            }
            
            // send notification to mail 
             try {
                Properties props = new Properties();
                props.put("mail.transport.protocol", "smtps");
                props.put("mail.smtps.host", "smtp.gmail.com");
                props.put("mail.smtps.port", 465);
                props.put("mail.smtps.auth", "true");
                props.put("mail.smtps.quitwait", "false");
                Session session = Session.getDefaultInstance(props);
                session.setDebug(true);
                
                Message message = new MimeMessage(session);
                message.setSubject("SIMSAR-Notification");
                message.setText(notification);

                Address [] mailList =  {
                    new InternetAddress(userAdEmail),
                };
                        
                message.setRecipients(Message.RecipientType.TO, mailList);
                Transport transport = session.getTransport();
                transport.connect("info@muslimahgirl.com", "infopasswor");
                transport.sendMessage(message, message.getAllRecipients());
                transport.close();

            } catch (MessagingException e) {
                log(e.toString());
            }
            
            pstmt.close();
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
            Logger.getLogger(addComment.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addComment.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(addComment.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addComment.class.getName()).log(Level.SEVERE, null, ex);
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
