package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.User;
import com.example.taskmanagementwebapp.model.entity.sessionbean.UserSessionBeanLocal;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "login", value = "/login")
public class login extends HttpServlet {
    @EJB
    private UserSessionBeanLocal userBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("doPost method called");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = userBean.findUserByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                // User is authenticated, set the username in the session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("user", user);
                // Redirect to the dashboard page
                response.sendRedirect("DashboardServlet");
            } else {
                // Authentication failed, show an error message
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Username or password is incorrect");
                // Redirect back to the login page
                response.sendRedirect("loginpage.jsp");
            }

        } catch (EJBException ex) {
            // This block will execute if the username is not found in the database
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Username or password is incorrect");
            // Redirect back to the login page
            response.sendRedirect("loginpage.jsp");
        }
    }
}
