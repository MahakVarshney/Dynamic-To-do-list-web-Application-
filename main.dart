import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(),
          Expanded(
            child: DashboardContent(),
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color.fromARGB(255, 221, 234, 232),
      child: Center(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text('Tasks',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.insights),
              title: Text('Insights'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InsightsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Reports'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReportsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.comment),
              title: Text('Comments'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CommentsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.inbox),
              title: Text('Inbox'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InboxScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Handle logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final List<Map<String, String>> tasks = [
    {'time': '10 am', 'task': 'Website design for a client'},
    {'time': '1 pm', 'task': 'Interaction design for Viemo'},
    {'time': '4 pm', 'task': 'Buy groceries'},
    {'time': '9 pm', 'task': 'Meeting with the team'},
  ];

  void _addTask() {
    setState(() {
      tasks.add({'time': 'New Task', 'task': 'New Task Details'});
    });
  }

  void _editTask(int index, String newTime, String newTask) {
    setState(() {
      tasks[index] = {'time': newTime, 'task': newTask};
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _searchTask(String query) {
    // Implement search functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(onSearch: _searchTask),
          SizedBox(height: 20),
          Text(
            'Organize & Manage your tasks',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addTask,
            child: Text('Add task', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TaskListWithCalendar(
                    tasks: tasks,
                    onEdit: _editTask,
                    onRemove: _removeTask,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(child: RightSideContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  SearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search something',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.notifications_none, size: 30),
        SizedBox(width: 10),
        Icon(Icons.settings, size: 30),
      ],
    );
  }
}

class TaskListWithCalendar extends StatelessWidget {
  final List<Map<String, String>> tasks;
  final Function(int, String, String) onEdit;
  final Function(int) onRemove;

  TaskListWithCalendar(
      {required this.tasks, required this.onEdit, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DateDisplay(),
        SizedBox(height: 20),
        TaskList(tasks: tasks, onEdit: onEdit, onRemove: onRemove),
      ],
    );
  }
}

class DateDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy').format(now);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$formattedDate'),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Map<String, String>> tasks;
  final Function(int, String, String) onEdit;
  final Function(int) onRemove;

  TaskList({required this.tasks, required this.onEdit, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Tasks', style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              TaskCalendar(),
              SizedBox(height: 20),
              ...tasks.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> task = entry.value;
                return TaskItem(
                  time: task['time']!,
                  task: task['task']!,
                  onEdit: () => _showEditDialog(
                      context, index, task['time']!, task['task']!),
                  onDone: () => onRemove(index),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
      BuildContext context, int index, String time, String task) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController timeController =
            TextEditingController(text: time);
        TextEditingController taskController =
            TextEditingController(text: task);

        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: 'Task'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onEdit(index, timeController.text, taskController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class TaskCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> weekDates = List.generate(
        7, (index) => now.subtract(Duration(days: now.weekday - 1 - index)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            weekDates.length,
            (index) => Column(
              children: [
                Text(
                  DateFormat.E().format(weekDates[index]),
                  style: TextStyle(
                    fontWeight: index == now.weekday - 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color:
                        index == now.weekday - 1 ? Colors.black : Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                TaskDateItem(
                  date: weekDates[index].day.toString(),
                  isSelected: index == now.weekday - 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskDateItem extends StatelessWidget {
  final String date;
  final bool isSelected;

  TaskDateItem({required this.date, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        date,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String time;
  final String task;
  final VoidCallback onEdit;
  final VoidCallback onDone;

  TaskItem(
      {required this.time,
      required this.task,
      required this.onEdit,
      required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              time,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(task, style: TextStyle(fontSize: 18))),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.red),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.done, color: Colors.green),
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

class RightSideContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(),
          SizedBox(height: 20),
          Calendar(),
          SizedBox(height: 20),
          PerformanceOverview(),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
        width: 191,
        height: 46,
        decoration: BoxDecoration(
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
      color : Color.fromRGBO(219, 38, 38, 1),
  ),
  child: Text('click me')
      )
      ],
    );
  }
}

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calendar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TableCalendar(
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
          ),
        ),
      ],
    );
  }
}

class PerformanceOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Performance Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
            height: 200,
            width: 200,
            color: Colors.grey.withOpacity(0.1),
            child: PieChart(
              swapAnimationDuration: const Duration(milliseconds: 500),
              PieChartData(sections: [
              // item 1
              PieChartSectionData(
                value: 20,
                color: Colors.blue,
              ),
              // item 1
              PieChartSectionData(
                value: 20,
                color: Colors.red,
              ),
              // item 1
              PieChartSectionData(
                value: 20,
                color: Colors.green,
              ),
              // item 1
              PieChartSectionData(
                value: 20,
                color: Colors.yellow,
              ),
            ]))),
      ],
    );
  }
}

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
      ),
      body: Center(
        child: Text('Insights Screen'),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Center(
        child: Text('Reports Screen'),
      ),
    );
  }
}

class CommentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Center(
        child: Text('Comments Screen'),
      ),
    );
  }
}

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: Center(
        child: Text('Inbox Screen'),
      ),
    );
  }
}
