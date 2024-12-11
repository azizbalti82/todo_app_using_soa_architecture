package org.example;

import java.util.Date;

public class Task {
    private String id;
    private String taskBody;
    private Date creationDate;
    private String importance;

    // Constructor
    public Task(String id, String taskBody, Date creationDate, String importance) {
        this.id = id;
        this.taskBody = taskBody;
        this.creationDate = creationDate;
        this.importance = importance;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTaskBody() {
        return taskBody;
    }

    public void setTaskBody(String taskBody) {
        this.taskBody = taskBody;
    }

    public Date getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(Date creationDate) {
        this.creationDate = creationDate;
    }

    public String getImportance() {
        return importance;
    }

    public void setImportance(String importance) {
        this.importance = importance;
    }

    @Override
    public String toString() {
        return "Task{" +
                "id='" + id + '\'' +
                ", taskBody='" + taskBody + '\'' +
                ", creationDate=" + creationDate +
                ", importance='" + importance + '}';
    }
}
