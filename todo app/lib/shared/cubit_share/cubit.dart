// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls, curly_braces_in_flow_control_structures, duplicate_ignore

import 'package:flutte/shared/cubit_share/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/todo_app/archived_Tasks/archivedTasks_screen.dart';
import '../../modules/todo_app/doneTasks/doneTasks_screen.dart';
import '../../modules/todo_app/tasks/tasks_screen.dart';
import '../network/local/cashe_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> Screens = [
    NewTasks_Screen(),
    DoneTasks_Screen(),
    ArchivedTasks_Screen(),
  ];
  List<String> title = [
    'New Tasks',
    ' Done Tasks',
    'Archive Tasks',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];

  void createDatabase() {
    // ignore: unused_local_variable
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      // ignore: avoid_print
      print('database create');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT ,date TEXT ,time TEXT  ,status TEXT)')
          .then((value) {
        // ignore: avoid_print
        print('table create');
      }).catchError((error) {
        // ignore: avoid_prin
        print('Error When Creating Table ${error.toString()}');
      });
    }, onOpen: (database) {
      getFromDatabase(database);

      // ignore: avoid_prin
      print('database open😎');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    database!.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES("$title","$date ","$time","new")')
          .then((value) {
        print('$value inserted successfuly');
        emit(AppInsertDatabaseState());
        getFromDatabase(database!);
      }).catchError((error) {
        print('Error When Inserting Rrcord ${error.toString()}');
      });
      return null;
    });
  }

  void getFromDatabase(Database database) {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    // ignore: unused_local_variable
    emit(AppGetDatabaseloodingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      //newtasks = value;
      value.forEach(
        (element) {
          if (element['status'] == 'new')
            newtasks.add(element);
          else if (element['status'] == 'done')
            donetasks.add(element);
          else
            archivedtasks.add(element);
        },
      );

      emit(AppGetDatabaseState());
    });
  }

  void UpdateData({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate(
      'UPDATE tasks SET status =? WHERE id =?',
      ['$status', id],
    ).then((value) {
      getFromDatabase(database!);
      emit(AppUpdateDatabaseState());
    });
  }

  void DeleteData({
    required int id,
  }) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database!);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;
  void ChangeAppMode({bool? formshared}) {
    if (formshared != null) {
      isDark = formshared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CasheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}
