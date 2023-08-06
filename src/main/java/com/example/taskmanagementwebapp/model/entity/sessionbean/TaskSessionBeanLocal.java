package com.example.taskmanagementwebapp.model.entity.sessionbean;
import com.example.taskmanagementwebapp.model.entity.Todotask;

import javax.ejb.EJBException;
import javax.ejb.Local;
import java.util.List;

@Local
public interface TaskSessionBeanLocal {
    public List<Todotask> getTaskByUser(Integer userId, int maxResults, int firstResult, String searchKeyword, String duedateSortInput,String statusInput,String priorityInput) throws EJBException;
    public void createTask(Todotask task);
    public void updateTask(Todotask task);
    public void deleteTask(int id);
    public int getTaskCountForUser(int userId,String searchKeyword, String duedateSortInput,String statusInput,String priorityInput); //to get num or pages for user records
    public void completeTask(int taskId,String completedStatus);
}
