import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task; // Task cần chỉnh sửa

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _nameController;
  late TextEditingController _placeController;
  DateTime? _selectedDateTime;
  Color? _selectedColor;
  final List<bool> _isSelected = [true, false, false];
  int? _selectedLevelIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name);
    _placeController = TextEditingController(text: widget.task?.place);
    _selectedDateTime = widget.task?.time;
    _selectedColor = widget.task?.color;
    _selectedLevelIndex = widget.task?.le?.index;
    for (int i = 0; i < _isSelected.length; i++) {
      _isSelected[i] = i == _selectedLevelIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _placeController,
              decoration: const InputDecoration(labelText: 'Place'),
            ),
            const SizedBox(height: 16.0),
            const Text(
                      'Color ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),

            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _selectedColor,
                  radius: 16,
                ),
                IconButton(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () async {
                    Color? pickedColor = await showDialog<Color>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: Colors.blue,
                            onColorChanged: (Color color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(_selectedColor);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    if (pickedColor != null) {
                      setState(() {
                        _selectedColor = pickedColor;
                      });
                    }
                  },
                ),
              ],
            ),
            const Divider(height: 10, thickness: 2, color: Color(0xffEAEAEA)),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Due Time ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _selectedDateTime == null
                          ? 'No Date and Time Selected'
                          : DateFormat('MM/dd/yyyy HH:mm').format(_selectedDateTime!),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: () async {
                    DateTime? pickedDateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDateTime != null) {
                      // ignore: use_build_context_synchronously
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            pickedDateTime.year,
                            pickedDateTime.month,
                            pickedDateTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
           const Divider(height: 20, thickness: 2, color: Color(0xffEAEAEA)),
            const Text(
                      'Level ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
            const SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildToggleButton('Urgent', 0),
                    _buildToggleButton('Basic', 1),
                    _buildToggleButton('Important', 2),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                    height: 20, thickness: 2, color: Color(0xffEAEAEA)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (_nameController.text.isEmpty ||
                _placeController.text.isEmpty ||
                _selectedDateTime == null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please fill in all fields.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              Level selectedLevel;
              switch (_selectedLevelIndex) {
                case 0:
                  selectedLevel = Level.urgent;
                  break;
                case 1:
                  selectedLevel = Level.basic;
                  break;
                case 2:
                  selectedLevel = Level.important;
                  break;
                default:
                  selectedLevel = Level.basic;
              }
              Task editedTask = Task(
                name: _nameController.text,
                place: _placeController.text,
                id: widget.task?.id,
                time: _selectedDateTime,
                le: selectedLevel,
                color: _selectedColor,
              );
              // Trả về task đã được chỉnh sửa
              Navigator.pop(context, editedTask);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            ),
            minimumSize: const Size(346, 49),
          ),
          child: Text(widget.task == null ? 'Add Task' : 'Save Task'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Widget _buildToggleButton(String text, int index) {
    bool isSelected = _isSelected[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < _isSelected.length;
              buttonIndex++) {
            _isSelected[buttonIndex] = buttonIndex == index;
          }
          _selectedLevelIndex = index;
        });
      },
      child: Center(
        child: Container(
          height: 38,
          width: 105,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
