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
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String completedStatus = request.getParameter("completedStatus");
        // Save the new task
        taskBean.completeTask(taskId,completedStatus);
        // Redirect back to the dashboard
        response.sendRedirect("DashboardServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
