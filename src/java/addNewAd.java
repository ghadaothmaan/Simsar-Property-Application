
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
 * @author Salma-Hassan
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
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ia-db", "root", "root");
            Statement statement = connection.createStatement();
            String title, description, status, type, size, floor, rentsell, price, curDate, map_lat, map_lng,
                    city, region, country;

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
            System.out.println(request.getParameter("address"));
            LocalDate date = java.time.LocalDate.now();
            curDate = date.toString();
            map_lat = request.getParameter("map_lat");
            map_lng = request.getParameter("map_lng");
            int priceInt = Integer.parseInt(price);
            
            HttpSession session = request.getSession();
            
            statement.executeUpdate("INSERT INTO advertisement (title, description, status, type, size, floor,rentsell, price, publishDate,mapLng, mapLat, city ,region, userID, country) VALUES('"
                    + title + "','" + description + "','"
                    + status + "','" + type + "','"
                    + size + "','" + floor + "','" + rentsell + "','" + priceInt + "','" + curDate + "','"
                    + map_lng + "','" + map_lat + "','" + city + "','" + region + "','"
                    + session.getAttribute("userID") + "','" + country +"')");
            
            connection.close();
            
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
