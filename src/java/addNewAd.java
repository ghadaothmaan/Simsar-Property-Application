import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
import javax.servlet.http.HttpSession;

/**
 *
 * @author Salma-Hassan and bayan tehe
 */
@WebServlet(urlPatterns = {"/addNewAd"})
public class addNewAd extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @throws java.sql.SQLException
     * @throws java.lang.ClassNotFoundException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
            PreparedStatement pstmt = null;
            ResultSet results = null;

            String title, description, status, type, size, floor, rentsell, price, curDate, map_lat, map_lng,
                    city, region, country, query;
            int active = 1;
            title = request.getParameter("title");
            description = request.getParameter("description");
            status = request.getParameter("status");
            type = request.getParameter("type");
            floor = request.getParameter("floor");
            rentsell = request.getParameter("rentOrsell");
            size = request.getParameter("size");
            price = request.getParameter("price");
            country = request.getParameter("country");
            city = request.getParameter("city");
            region = request.getParameter("region");

            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();
            curDate = dtf.format(now);

            map_lat = request.getParameter("map_lat");
            map_lng = request.getParameter("map_lng");

            HttpSession session = request.getSession();
            int userID = (Integer) session.getAttribute("userID"),
                    priceInt = Integer.parseInt(price),
                    sizeInt = Integer.parseInt(size),
                    floorInt = Integer.parseInt(floor);

            double map_latDouble = Double.parseDouble(map_lat),
                    map_lngDouble = Double.parseDouble(map_lng);

            query = "INSERT INTO advertisement (title, rentsell, size, description, "
                    + "floor, status, type, price, publishDate, "
                    + "mapLat, mapLng, city, region, country, userID, active) "
                    + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

            pstmt = connection.prepareStatement(query);
            pstmt.setString(1, title);
            pstmt.setString(2, rentsell);
            pstmt.setInt(3, sizeInt);
            pstmt.setString(4, description);
            pstmt.setInt(5, floorInt);
            pstmt.setString(6, status);
            pstmt.setString(7, type);
            pstmt.setInt(8, priceInt);
            pstmt.setString(9, curDate);
            pstmt.setDouble(10, map_latDouble);
            pstmt.setDouble(11, map_lngDouble);
            pstmt.setString(12, city);
            pstmt.setString(13, region);
            pstmt.setString(14, country);
            pstmt.setInt(15, userID);
            pstmt.setInt(16, active);
            
            pstmt.execute();

            //search if this ad in interests table, if yes, send to user notification :"D
            query = "SELECT * FROM interests WHERE (type = ? OR type = ?) AND "
                    + "(rentsale = ? OR rentsale = ?) AND "
                    + "(status = ? OR status = ?) AND "
                    + "(priceFrom <= ? OR priceFrom = ?) AND "
                    + "(priceTo >= ? OR priceTo = ?) AND "
                    + "(sizeFrom <= ? OR sizeFrom = ?) AND "
                    + "(sizeTo >= ? OR sizeTo = ?) AND "
                    + "(country = ? OR country = ?) AND "
                    + "(city = ? OR city = ?)";

            pstmt = connection.prepareStatement(query);
            pstmt.setString(1, type);
            pstmt.setString(2, "");
            pstmt.setString(3, rentsell);
            pstmt.setString(4, "");
            pstmt.setString(5, status);
            pstmt.setString(6, "");
            pstmt.setInt(7, priceInt);
            pstmt.setInt(8, -1);
            pstmt.setInt(9, priceInt);
            pstmt.setInt(10, -1);
            pstmt.setInt(11, sizeInt);
            pstmt.setInt(12, -1);
            pstmt.setInt(13, sizeInt);
            pstmt.setInt(14, -1);
            pstmt.setString(15, country);
            pstmt.setString(16, "");
            pstmt.setString(17, city);
            pstmt.setString(18, "");
            results = pstmt.executeQuery();

            if (!results.isBeforeFirst()) {
                System.out.println("No interests found for this ad!");

            } else { //send notification to users

                int interestID = -1, interestUserID = -1, adID = -1;
                String notification = "we found an advertisement " + title + " that matches your interests",
                        userEmail = "";
                ResultSet user = null;

                while (results.next()) { //one, cuz no interests with same attrs
                    interestID = results.getInt("interestID");
                }

                //get id of new add added to database
                query = "SELECT * FROM advertisement WHERE userID = ? AND publishDate = ? AND title = ?";
                pstmt = connection.prepareStatement(query);
                pstmt.setInt(1, userID);
                pstmt.setString(2, curDate);
                pstmt.setString(3, title);
                results = pstmt.executeQuery();

                while (results.next()) { //add the final one
                    adID = results.getInt("adsID");
                }

                System.out.println(adID);

                query = "SELECT * FROM userinterests WHERE interestID = ?";
                pstmt = connection.prepareStatement(query);

                pstmt.setInt(1, interestID);
                results = pstmt.executeQuery();

                while (results.next()) { //many users have same interest

                    now = LocalDateTime.now();
                    curDate = dtf.format(now);

                    interestUserID = results.getInt("interestUserID");
                    query = "INSERT INTO notifications(notificationUserID, notificationAdID, notificationDate, "
                            + "notification, isViewed) VALUES(?,?,?,?,?)";

                    pstmt = connection.prepareStatement(query);

                    pstmt.setInt(1, interestUserID);
                    pstmt.setInt(2, adID);
                    pstmt.setString(3, curDate);
                    pstmt.setString(4, notification);
                    pstmt.setString(5, "NO");
                    pstmt.execute();

                    //send notification to mail
                    query = "SELECT * FROM user WHERE id = ?";
                    pstmt = connection.prepareStatement(query);
                    pstmt.setInt(1, interestUserID);
                    user = pstmt.executeQuery();

                    while (user.next()) {
                        userEmail = user.getString("email");
                    }
                    try {
                        Properties props = new Properties();
                        props.put("mail.transport.protocol", "smtps");
                        props.put("mail.smtps.host", "smtp.gmail.com");
                        props.put("mail.smtps.port", 465);
                        props.put("mail.smtps.auth", "true");
                        props.put("mail.smtps.quitwait", "false");
                        Session session1 = Session.getDefaultInstance(props);
                        session1.setDebug(true);

                        Message message = new MimeMessage(session1);
                        message.setSubject("SIMSAR-Notification");
                        message.setText(notification);

                        Address[] mailList = {
                            new InternetAddress(userEmail),};

                        message.setRecipients(Message.RecipientType.TO, mailList);
                        Transport transport = session1.getTransport();
                        transport.connect("info@muslimahgirl.com", "infopasswor");
                        transport.sendMessage(message, message.getAllRecipients());
                        transport.close();

                    } catch (MessagingException e) {
                        log(e.toString());
                    }
                }
                user.close();
            }
            connection.close();
            pstmt.close();
            results.close();
            response.sendRedirect("viewUserAds.jsp");
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
        } catch (SQLException ex) {
            Logger.getLogger(addNewAd.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(addNewAd.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(addNewAd.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(addNewAd.class.getName()).log(Level.SEVERE, null, ex);
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
