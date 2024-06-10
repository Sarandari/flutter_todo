import 'package:flutter/material.dart';
import 'package:todos_1/screens/add_page.dart';
import 'package:todos_1/sevices/todo_service.dart';
import 'package:todos_1/utils/snackbar_helper.dart';
import 'package:todos_1/widget/todo_card.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Color.fromARGB(255, 109, 37, 164),
        title: Text(
          'Хийх зүйлс',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(255, 109, 37, 164)),
          onPressed: () {},
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'Хийх зүйлс байхгүй',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return TodoCard(
                  index: index,
                  item: item,
                  navigateToEdit: navigateToEditPage,
                  deleteById: deleteById,
                );
              },
            ),
          ),
        ),
      ),
      //Жагсаалт нэмэх
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Даалгавар нэмэх'),
      ),
    );
  }

 //Жагсаалтыг засвахлах
  void navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPageState(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Даалгаврыг нэмэх
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPageState(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Даалгаврыг устгах
  Future<void> deleteById(String id) async {
    final success = await TodoService.deleteById(id);
    if (success) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: 'Deletion Failed');
    }
  }
  
  //Даалгаврыг дахин ачааллах
  Future<void> fetchTodo() async {
    final responce = await TodoService.fetchTodos();
    if (responce != null) {
      setState(() {
        items = responce;
      });
    } else {
      showErrorMessage(context, message: 'something wento wrong');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
