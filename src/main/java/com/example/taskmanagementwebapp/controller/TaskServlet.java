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

@WebServlet(name = "TaskServlet", value = "/TaskServlet")
public class TaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class);
    @EJB
    private TaskSessionBeanLocal taskBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Retrieve the current user session
        HttpSession session = request.getSession();
        // Get the user object from the session
        User user = (User) session.getAttribute("user");
        // Get the user object from the session
        int userId = user.getId();

        // Retrieve the request parameters from the form
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String duedate = request.getParameter("duedate");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");

        // get the selected CRUD function
        String action = request.getParameter("action");

        // only go through FormValidator if action is create or update
        if ("create".equals(action) || "update".equals(action)) {
            // Define the fields to be validated
            String[] fields = {"title", "description", "duedate", "status", "priority"};
            //Pass form fields to FormValidator and get a list of field values that are empty
            List<String> emptyFields = FormValidator.validate(request, fields);
            // If there are any empty fields from FormValidator
            if (!emptyFields.isEmpty()) {
                // For each empty field, add an error attribute to the request
                for (String field : emptyFields) {
                    //request.setAttribute(field + "Error", "");
                    session.setAttribute(field + "Error", "");
                }
                // Add the emptyFields list to the session
                session.setAttribute("emptyFields", emptyFields);
                // Add back the form fields with values submitted by user back to user using the request attributes
                //request.setAttribute("id", id);
                //request.setAttribute("title", title);
                session.setAttribute("title", title);
                //request.setAttribute("description", description);
                session.setAttribute("description", description);
                //request.setAttribute("duedate", duedate);
                session.setAttribute("duedate", duedate);
                //request.setAttribute("status", status);
                session.setAttribute("status", status);
                //request.setAttribute("priority", priority);
                session.setAttribute("priority", priority);
                // Get the user's tasks and add them to the request attributes //needed to re-render the table
                //List<Todotask> tasksList = taskBean.getTaskByUser(userId, Integer.MAX_VALUE, 0, "");
                //request.setAttribute("tasksList", tasksList);
                // Add a flag to indicate which form field has validation errors
                //request.setAttribute("hasErrors", true);
                session.setAttribute("hasErrors", true);
                // send back the action type
                //request.setAttribute("currentAction", action);
                session.setAttribute("currentAction", action);
                // Forward the request to the dashboard.jsp page to show errors
                //request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
                // Forward the request to the DashboardServlet to show errors
                response.sendRedirect("DashboardServlet");
                return;
            }
        }
        Date date = null;
        if ("create".equals(action) || "update".equals(action)) {
            try {
                // Parse the duedate string to a Date object
                date = new SimpleDateFormat("yyyy-MM-dd").parse(duedate);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        if ("create".equals(action)) {
            createTask(request, response, title, description, date, status, priority, user);
        } else if ("update".equals(action)) {
            updateTask(request, response, title, description, date, status, priority, user);
        } else if ("delete".equals(action)) {
            deleteTask(request, response);
        } else {
            // handle error or unknown action
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response, String title, String description, Date date, String status, String priority, User user) throws ServletException, IOException {
        // Create the new task
        Todotask newTask = new Todotask();
        newTask.setTitle(title);
        newTask.setDescription(description);
        newTask.setDuedate(date);
        newTask.setStatus(status);
        newTask.setPriority(priority);
        newTask.setUserid(user);

        // Save the new task
        taskBean.createTask(newTask);

        // Redirect back to the dashboard
        response.sendRedirect("DashboardServlet");
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response, String title, String description, Date date, String status, String priority, User user) throws ServletException, IOException {
        // Create a Todotask object and set its fields
        Todotask updateTask = new Todotask();
        String idString = request.getParameter("id");
        if (idString != null && !idString.isEmpty()) {
            int id = Integer.parseInt(idString);
            updateTask.setId(id);
        } else {
            // handle error: id is required for updates
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id for update");
        }
        updateTask.setTitle(title);
        updateTask.setDescription(description);
        updateTask.setDuedate(date);
        updateTask.setStatus(status);
        updateTask.setPriority(priority);
        updateTask.setUserid(user);

        // Call the updateTask method of the TaskSessionBeanLocal instance
        taskBean.updateTask(updateTask);

        // Redirect the response to the DashboardServlet
        response.sendRedirect("DashboardServlet");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idString = request.getParameter("id");
        if (idString != null && !idString.isEmpty()) {
            int id = Integer.parseInt(idString);
            taskBean.deleteTask(id);
        } else {
            // handle error: id is required for updates
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id for update");
        }
        response.sendRedirect("DashboardServlet");
    }
}
