package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.sessionbean.TaskSessionBeanLocal;

import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "CompleteServlet", value = "/CompleteServlet")
public class CompleteServlet extends HttpServlet {
    @EJB
    private TaskSessionBeanLocal taskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String completedStatus = request.getParameter("completedStatus");
            // Save the new task
            taskBean.completeTask(taskId, completedStatus);
            // Redirect back to the dashboard
            response.sendRedirect("DashboardServlet");
        } catch (NumberFormatException e) {
            // Handle specific exception for number format
            e.printStackTrace();
            response.getWriter().write("Invalid task ID format in CompleteServlet.");
        } catch (Exception e) {
            // Handle other exceptions
            e.printStackTrace();
            response.getWriter().write("An error occurred in CompleteServlet.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
