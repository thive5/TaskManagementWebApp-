package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.sessionbean.TaskSessionBeanLocal;
import org.apache.log4j.Logger;

import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "DeleteTaskServlet", value = "/DeleteTaskServlet")
public class DeleteTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class);
    @EJB
    private TaskSessionBeanLocal taskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the request parameters from the form
        int id = Integer.parseInt(request.getParameter("id"));
        // Delete the task
        taskBean.deleteTask(id);
        // Redirect the user back to the dashboard
        response.sendRedirect("DashboardServlet");
    }
}
