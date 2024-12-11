package org.example;

import jakarta.xml.ws.Endpoint;

public class Server {
    public static void main(String[] args) {
        String url = "http://192.168.1.18:5002/TaskManagerService";
        Endpoint.publish(url, new TaskManagerWS());  // Publish the web service
        System.out.println("Service started at: " + url);
    }
}
