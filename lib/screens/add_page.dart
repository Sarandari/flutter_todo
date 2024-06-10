import 'package:flutter/material.dart';
import 'package:todos_1/sevices/todo_service.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPageState extends StatefulWidget {
  final Map? todo;
  const AddTodoPageState({super.key, this.todo});

  @override
  State<AddTodoPageState> createState() => _AddTodoPageStateState();
}

class _AddTodoPageStateState extends State<AddTodoPageState> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    super.initState();
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Color.fromARGB(255, 109, 37, 164),
        title: Text(
          isEdit ? 'Даалгаврыг өөрчлөх' : 'Даалгавар нэмэх',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Энд гарчигийг бичнэ үү',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Гарчиг', // Гадамшааны бичвэр
                suffixIcon: IconButton(
                  onPressed: () =>
                      titleController.clear(), // Дарахад ачаалах үйлдэл
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Энд тэмдэглэл бичнэ үү',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Тэмдэглэл', // Гадамшааны бичвэр
                suffixIcon: IconButton(
                  onPressed: () =>
                      titleController.clear(), // Дарахад ачаалах үйлдэл
                  icon: Icon(Icons.clear),
                ),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 8,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? 'Өөрчлөх' : 'Хадгалах'),
              ),
            ),
          )
        ],
      ),
    );
  }
  void updateData() async {

    final todo = widget.todo;
    if (todo == null) {
      print('tou can not call updated wothout todo data');
      return;
    }
    final id = todo['_id'];
    //Сервер рүү мэдээллээ илгээх
    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Амжилттай өөрчилсөн');
    } else {
      showErrorMessage(context, message: 'Өөрчлөлт хийхэд алдаа гарсан!');
    }
  }

  void submitData() async {
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.addTodo(body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Амжилттай хадгалсан');
    } else {
      showErrorMessage(context, message: 'Хадгалахад алдаа гарсан!');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
