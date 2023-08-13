package com.example.taskmanagementwebapp.utilities;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

public class FormValidator {
    public static List<String> validate(HttpServletRequest request, String[] fields) {
        List<String> emptyFields = new ArrayList<>();
        if (fields != null) {
            for (String field : fields) {
                if (!request.getParameterMap().containsKey(field) || request.getParameter(field).isEmpty()) {
                    emptyFields.add(field);
                }
            }
        }
        return emptyFields;
    }
}
