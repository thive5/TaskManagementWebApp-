package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.sessionbean.UserSessionBeanLocal;

import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "CreateAccountServlet", value = "/CreateAccountServlet")
public class CreateAccountServlet extends HttpServlet {
    @EJB
    private UserSessionBeanLocal userBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Check if the username already exists
        if (userBean.isUsernameExists(username)) {
            session.setAttribute("errorMessage", "Username already exists!");
            request.getRequestDispatcher("createaccount.jsp").forward(request, response);
            return;
        }
        // If not, create a new user
        userBean.createUser(username, password);
        // Set a session attribute for the success message
        request.getSession().setAttribute("accountCreated", "");
        response.sendRedirect("loginpage.jsp");
    }
}
