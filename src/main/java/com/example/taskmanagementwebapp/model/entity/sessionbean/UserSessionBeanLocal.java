package com.example.taskmanagementwebapp.model.entity.sessionbean;
import com.example.taskmanagementwebapp.model.entity.User;
import javax.ejb.Local;
import javax.ejb.EJBException;

@Local
public interface UserSessionBeanLocal {
    User findUserByUsername(String username) throws EJBException;
    boolean isUsernameExists(String username);
    void createUser(String username, String password) throws EJBException;

}
