package com.example.taskmanagementwebapp.model.entity.sessionbean;

import com.example.taskmanagementwebapp.model.entity.User;

import javax.ejb.EJBException;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Stateless
public class UserSessionBean implements UserSessionBeanLocal {
    @PersistenceContext(unitName = "TaskManagementWebApp")
    EntityManager entityManager;

    public User findUserByUsername(String username) throws EJBException {
        TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
        query.setParameter("username", username);
        try {
            return query.getSingleResult();
        } catch (Exception ex) {
            throw new EJBException("Problem finding user by username", ex);
        }
    }

    @Override
    public boolean isUsernameExists(String username) {
        TypedQuery<User> query = entityManager.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
        query.setParameter("username", username);
        List<User> users = query.getResultList();
        return !users.isEmpty();
    }

    @Override
    public void createUser(String username, String password) throws EJBException {
        try {
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(password);
            entityManager.persist(newUser);
        } catch (Exception e) {
            // Handle any other exceptions
            throw new EJBException("An error occurred while creating the user.", e);
        }
    }
}
