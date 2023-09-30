// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit_share/states.dart';
import '../shared/cubit_share/cubit.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class TodoApp extends StatelessWidget {
  // ignore: avoid_init_to_null

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formekey = GlobalKey<FormState>();

  var titelController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            centerTitle: true,
            elevation: 2,
            title: Text(
              cubit.title[cubit.currentIndex],
              // ignore: prefer_const_constructor
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ConditionalBuilder(
            // ignore: prefer_is_empty
            condition: state is! AppGetDatabaseloodingState,
            builder: (context) => cubit.Screens[cubit.currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (cubit.isBottomSheetShown) {
                if (formekey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      title: titelController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              } else {
                scaffoldkey.currentState
                    ?.showBottomSheet(
                      (context) => Padding(
                        // ignore: prefer_const_constructor
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          color: Colors.white,
                          child: Form(
                            key: formekey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFaild(
                                  controller: titelController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'titel must not be empty';
                                    }
                                    return null;
                                  },
                                  Label: 'task title',
                                  prefix: Icons.title,
                                ),
                                // ignore: prefer_const_constructor
                                SizedBox(
                                  height: 10,
                                ),
                                defaultFormFaild(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  Label: 'task time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                // ignore: prefer_const_constructor
                                SizedBox(
                                  height: 10,
                                ),
                                defaultFormFaild(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2024-06-09'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  Label: 'task date',
                                  prefix: Icons.calendar_month_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      elevation: 20.0,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });
                cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add,
                );
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey[200],
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              // ignore: prefer_const_literals_to_create_immutables
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive tasks'),
              ]),
        );
      }),
    );
  }
}
