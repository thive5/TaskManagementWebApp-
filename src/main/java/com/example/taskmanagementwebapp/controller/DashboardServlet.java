package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.Todotask;
import com.example.taskmanagementwebapp.model.entity.User;
import com.example.taskmanagementwebapp.model.entity.sessionbean.TaskSessionBeanLocal;

import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

import org.apache.log4j.Logger;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class);
    @EJB
    private TaskSessionBeanLocal taskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            logger.warn("DashboardServlet cannot get current user");
            response.sendRedirect("loginpage.html");
            return;
        }
        int userId = user.getId();
        logger.info("Current user:" + userId);
        try{
        List<Todotask> tasksList = taskBean.getTaskByUser(userId);
        request.setAttribute("tasksList", tasksList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
        }catch (Exception e){
            logger.error("Error while retrieving tasks or forwarding request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
