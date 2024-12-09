import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'model.dart';

final String soapUrl = "http://192.168.1.18:5002/TaskManagerService";

// Create Task Method
Future<void> createTask(String userID, String taskBody, String importance) async {
  String soapRequest = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://example.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <exam:createTask>
         <!--Optional:-->
         <arg0>${userID}</arg0>
         <!--Optional:-->
         <arg1>${taskBody}</arg1>
         <!--Optional:-->
         <arg2>${importance}</arg2>
      </exam:createTask>
   </soapenv:Body>
</soapenv:Envelope>''';

  try {
    final response = await http.post(
      Uri.parse(soapUrl),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      body: soapRequest,
    );

    if (response.statusCode == 200) {
      XmlDocument document = XmlDocument.parse(response.body);
      var resultElement = document.findAllElements('createTaskResponse').single;
      String resultMessage = resultElement.text.trim();
      print('Task created successfully: $resultMessage');
    } else {
      print('Request failed with status: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (e) {
    log('Error making SOAP request: $e');
  }
}
Future<void> deleteTask(String userID, String taskID) async {
  String soapRequest = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://example.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <exam:deleteTask>
         <!--Optional:-->
         <arg0>${userID}</arg0>
         <!--Optional:-->
         <arg1>${taskID}</arg1>
      </exam:deleteTask>
   </soapenv:Body>
</soapenv:Envelope>''';

  try {
    final response = await http.post(
      Uri.parse(soapUrl),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      body: soapRequest,
    );

    if (response.statusCode == 200) {
      XmlDocument document = XmlDocument.parse(response.body);
      var resultElement = document.findAllElements('createTaskResponse').single;
      String resultMessage = resultElement.text.trim();
      print('Task deleted successfully: $resultMessage');
    } else {
      print('Request failed with status: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (e) {
    log('Error making SOAP request: $e');
  }
}

Future<List<Task>> listTasks(String userID) async {
  String soapRequest = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:exam="http://example.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <exam:listTasks>
         <!--Optional:-->
         <arg0>${userID}</arg0>
      </exam:listTasks>
   </soapenv:Body>
</soapenv:Envelope>''';

  try {
    // Send the SOAP request
    final response = await http.post(
      Uri.parse(soapUrl),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        // No SOAPAction needed, as per the WSDL
      },
      body: soapRequest,
    );

    if (response.statusCode == 200) {
      // Parse the response XML
      return parseTaskListResponse(response.body);
    } else {
      throw Exception('Failed to call SOAP API: ${response.statusCode}');
    }
  } catch (e) {
    print('Error calling listTasks: $e');
    return [];
  }
}
List<Task> parseTaskListResponse(String response) {
  final tasks = <Task>[];

  try {
    final document = XmlDocument.parse(response);
    final returnElements = document.findAllElements('return');

    for (var element in returnElements) {
      final id = element.findElements('id').single.text;
      final taskBody = element.findElements('taskBody').single.text;
      final creationDate = element.findElements('creationDate').single.text;
      final importance = element.findElements('importance').single.text;

      tasks.add(Task(
        id: id,
        taskBody: taskBody,
        creationDate: creationDate,
        importance: importance,
      ));
    }
  } catch (e) {
    log('Error parsing response: $e');
  }

  return tasks;
}

