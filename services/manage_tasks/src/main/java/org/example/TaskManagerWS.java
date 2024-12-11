package org.example;

import com.mongodb.client.MongoCollection;
import org.bson.Document;

import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.jws.WebService;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebService(serviceName = "TaskManagerService")
public class TaskManagerWS {

    private MongoCollection<Document> taskCollection = MongoDB.getTaskCollection();

    @WebMethod
    public String createTask(
            @WebParam String userID,
            @WebParam String taskBody,
            @WebParam String importance
    ) {
        try {
            // Create task as MongoDB Document
            Document task = new Document("userID", userID)
                    .append("taskBody", taskBody)
                    .append("creationDate", new Date())
                    .append("importance", importance);

            // Insert into MongoDB
            taskCollection.insertOne(task);
            return "Task created successfully!";
        } catch (Exception e) {
            return "Error creating task: " + e.getMessage();
        }
    }

    @WebMethod
    public List<Task> listTasks(@WebParam String userID) {
        List<Task> tasks = new ArrayList<>();
        for (Document doc : taskCollection.find(new Document("userID", userID))) {
            Task task = new Task(
                    doc.getObjectId("_id").toString(),
                    doc.getString("taskBody"),
                    doc.getDate("creationDate"),
                    doc.getString("importance")
            );
            tasks.add(task);
        }
        return tasks;
    }

    @WebMethod
    public String updateTask(
            @WebParam String userID,
            @WebParam String taskId,
            @WebParam String newTaskBody,
            @WebParam String newImportance,
            @WebParam String newNotificationDate
    ) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date newNotificationDateParsed = sdf.parse(newNotificationDate);

            Document filter = new Document("_id", new org.bson.types.ObjectId(taskId)).append("userID", userID);
            Document update = new Document("$set", new Document("taskBody", newTaskBody)
                    .append("importance", newImportance)
                    .append("notificationDate", newNotificationDateParsed));

            if (taskCollection.updateOne(filter, update).getMatchedCount() > 0) {
                return "Task updated successfully!";
            } else {
                return "Task not found!";
            }
        } catch (Exception e) {
            return "Error updating task: " + e.getMessage();
        }
    }

    @WebMethod
    public String deleteTask(@WebParam String userID, @WebParam String taskId) {
        Document filter = new Document("_id", new org.bson.types.ObjectId(taskId)).append("userID", userID);
        if (taskCollection.deleteOne(filter).getDeletedCount() > 0) {
            return "Task deleted successfully!";
        }
        return "Task not found!";
    }

//    @WebMethod
//    public List<Task> searchTasksByImportance(@WebParam String userID, @WebParam String importance) {
//        List<Task> tasks = new ArrayList<>();
//        for (Document doc : taskCollection.find(new Document("userID", userID).append("importance", importance))) {
//            Task task = new Task(
//                    doc.getObjectId("_id").toString(),
//                    doc.getString("taskBody"),
//                    doc.getDate("creationDate"),
//                    doc.getString("importance")
//            );
//            tasks.add(task);
//        }
//        return tasks;
//    }
}
