package org.example;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class MongoDB {
    private static final String URI = "mongodb://localhost:27017"; // Replace with your MongoDB URI if needed
    private static final String DATABASE_NAME = "TaskManagerDB";
    private static final String COLLECTION_NAME = "tasks";

    private static final MongoDatabase database;

    static {
        MongoClient mongoClient = new MongoClient(new MongoClientURI(URI));
        database = mongoClient.getDatabase(DATABASE_NAME);
    }

    public static MongoCollection<Document> getTaskCollection() {
        return database.getCollection(COLLECTION_NAME);
    }
}

