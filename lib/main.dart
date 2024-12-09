import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'api/auth.dart';
import 'api/model.dart';
import 'api/todo_manager.dart';


Color borderColor = Color.fromRGBO(101, 101, 101, 1.0);
Color high = Color.fromRGBO(232, 214, 214, 1.0);
Color low = Color.fromRGBO(202, 223, 200, 1.0);
Color normal = Color.fromRGBO(213, 215, 228, 1.0);

String userID ="1";


void main() {
  runApp(MyApp());
}

//root screen
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  int _selectedSection = 2; // 0 for Login, 1 for Register, 2 for Home

  @override
  void initState() {
    super.initState();
    //checkLoginStatus();
  }


  @override
  Widget build(BuildContext context) {
    // Set status bar color to white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Set the status bar color to white
      statusBarIconBrightness: Brightness.dark, // Optional: change icons to dark for visibility
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getScreenForSection(),
    );
  }

  // Get the current screen based on the selected section
  Widget _getScreenForSection() {
    switch (_selectedSection) {
      case 1:
        return RegisterScreen(onRegisterSuccess: () {
          setState(() {
            _selectedSection = 2; // Switch to Home after registration
          });
        });
      case 2:
        return HomeScreen(onLogout: () {
          setState(() {
            _selectedSection = 0; // Switch to Login after logout
          });
        });
      default:
        return LoginScreen(onLoginSuccess: () {
          setState(() {
            _selectedSection = 2; // Switch to Home after login
          });
        });
    }
  }
}

//login screen
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  LoginScreen({required this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // State variable to track password visibility
  var _errorMessage;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    String? _errorMessage;

    try {
      final success = await login( email, password); // API call
      if (success.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "Welcome back",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        widget.onLoginSuccess();  // Notify success
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hello Again!",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Welcome back you've been missed!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            // Username Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Email', // Placeholder text
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(147, 147, 147, 1.0),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when enabled
                ),// Optional: add border around the TextField
              ),
            ),
            SizedBox(height: 20),
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // Toggle the visibility
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle the state
                    });
                  },
                ),
                hintText: 'Password', // Placeholder text
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(147, 147, 147, 1.0),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when enabled
                ),// Optional: add border around the TextField
              ),
            ),
            SizedBox(height: 40),
            // Sign In Button
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Log in',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                          onRegisterSuccess: () {
                            Navigator.pop(context); // Navigate back to Login screen
                          },
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, // This sets the text color
                  ),
                  child: Text('Register now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//register screen
class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  RegisterScreen({required this.onRegisterSuccess});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final success = await register(name, email, password); // API call
      if (success) {
        Fluttertoast.showToast(
            msg: "Sign in successfully !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        widget.onRegisterSuccess();  // Notify success
      } else {
        setState(() {
          _errorMessage = 'User already exists or invalid data';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create Account",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 5),
            Text("Join us and get started!", style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 40),
            // Name Field
            TextField(
              controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your name', // Placeholder text
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(147, 147, 147, 1.0),
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    borderSide: BorderSide(color: borderColor), // Default border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    borderSide: BorderSide(color: borderColor), // Red color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    borderSide: BorderSide(color: borderColor), // Red color when enabled
                  ),// Optional: add border around the TextField
                )
            ),
            SizedBox(height: 20),
            // Username Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Enter your email', // Placeholder text
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(147, 147, 147, 1.0),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when enabled
                ),// Optional: add border around the TextField
              ),
            ),
            SizedBox(height: 20),
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: 'Enter your password', // Placeholder text
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(147, 147, 147, 1.0),
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  borderSide: BorderSide(color: borderColor), // Red color when enabled
                ),// Optional: add border around the TextField
              ),
            ),
            SizedBox(height: 40),
            // Register Button
            ElevatedButton(
              onPressed: _register, // On success, go to home screen
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 20),
            // Error Message
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            // Already a member link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already a member?'),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to Login screen
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//main screen
// Main screen


class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const HomeScreen({required this.onLogout, Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late List<Task> todos = [];
  final TextEditingController _todoController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final fetchedTasks = await listTasks(userID); // Replace with actual userID
    if(fetchedTasks.isNotEmpty){
      setState(() {
        todos.clear();
        todos.addAll(fetchedTasks);
        isLoading = false;
      });
    }else{
      log("empty list from server");
    }

  }

  void _addTodo() {
    if (_todoController.text.isNotEmpty) {
      createTask(userID,_todoController.text,'normal');
      setState(() {
        todos.add(Task(id: userID, taskBody: _todoController.text, creationDate:'', importance: 'normal'));
      });
      _todoController.clear();
    }
  }

  void _onCardTap(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card tapped: ${todos[index]}'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deleteTodo(int index,String taskID) {
    deleteTask(userID, taskID);
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            'Todo List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.black,size: 25,),
              onPressed: widget.onLogout,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Add Todo Field and Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),child:
              Card(
                color: const Color.fromRGBO(243, 243, 243, 1.0),
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                elevation: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _todoController,
                          decoration: InputDecoration(
                            hintText: 'Write something...',
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(147, 147, 147, 1.0),
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(147, 147, 147, 1.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(147, 147, 147, 1.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(147, 147, 147, 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: borderColor),
                        onPressed: _addTodo,
                      ),
                    ],
                  ),
                ),
            ),
            const SizedBox(height: 20),
            // Todo List Display with Cards
            Expanded(
              child: todos.isEmpty
                  ? const Center(
                child: Text(
                  'No todos added yet!',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromRGBO(240, 240, 240, 1.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
                    elevation: 0,
                    child: ListTile(
                      onTap: () => _onCardTap(index),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todos[index].taskBody,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Card(
                                color: (todos[index].importance=="high")?high:(todos[index].importance=="normal")?normal:low,
                                elevation: 0,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                                    child: Text(
                                  todos[index].importance,
                                )
                            ),
                          )

                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: borderColor),
                        onPressed: () => _deleteTodo(index,todos[index].id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


