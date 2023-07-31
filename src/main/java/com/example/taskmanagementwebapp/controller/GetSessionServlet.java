package com.example.taskmanagementwebapp.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "GetSessionServlet", value = "/GetSessionServlet")
public class GetSessionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String errorMessage = (String) session.getAttribute("errorMessage");
        session.removeAttribute("errorMessage");  // Clear the error message
        if (errorMessage == null) {
            errorMessage = "";
        }
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(errorMessage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
