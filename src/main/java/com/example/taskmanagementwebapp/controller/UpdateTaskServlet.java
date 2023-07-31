package com.example.taskmanagementwebapp.controller;

import com.example.taskmanagementwebapp.model.entity.Todotask;
import com.example.taskmanagementwebapp.model.entity.User;
import com.example.taskmanagementwebapp.model.entity.sessionbean.TaskSessionBeanLocal;
import com.example.taskmanagementwebapp.utilities.FormValidator;
import org.apache.log4j.Logger;

import javax.ejb.EJB;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "UpdateTaskServlet", value = "/UpdateTaskServlet")
public class UpdateTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class);
    @EJB
    private TaskSessionBeanLocal taskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        // Get the request parameters from the form
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String duedate = request.getParameter("duedate");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");

        String[] fields = {"title", "description", "duedate", "status", "priority"};
        List<String> emptyFields = FormValidator.validate(request, fields);
        if (!emptyFields.isEmpty()) {
            for (String field : emptyFields) {
                request.setAttribute(field + "Error", "");
            }
            // Add the form data to the request attributes
            request.setAttribute("id", id);
            request.setAttribute("title", title);
            request.setAttribute("description", description);
            request.setAttribute("duedate", duedate);
            request.setAttribute("status", status);
            request.setAttribute("priority", priority);
            List<Todotask> tasksList = taskBean.getTaskByUser(userId);
            request.setAttribute("tasksList", tasksList);
            // Add a flag to indicate that the form has validation errors
            request.setAttribute("hasErrors", true);
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);


        }else{
            // Create a Todotask object and set its fields
            Todotask updateTask = new Todotask();
            updateTask.setId(id);
            updateTask.setTitle(title);
            updateTask.setDescription(description);
            try {
                // Parse the duedate string to a Date object
                Date date = new SimpleDateFormat("yyyy-MM-dd").parse(duedate);
                updateTask.setDuedate(date);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            updateTask.setStatus(status);
            updateTask.setPriority(priority);
            updateTask.setUserid(user);

            // Call the updateTask method of the TaskSessionBeanLocal instance
            taskBean.updateTask(updateTask);

            // Redirect the response to the DashboardServlet
            response.sendRedirect("DashboardServlet");
        }

    }
}
