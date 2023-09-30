// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables, avoid_types_as_parameter_names, unused_local_variable, sized_box_for_whitespace, avoid_print

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../cubit_share/cubit.dart';
import '../styles/colors.dart';

typedef Validator = String? Function(String?)?;
Widget defaultButton({
  double hight = 40,
  double width = double.infinity,
  Color background = defaultColor,
  bool isUpperCase = true,
  Function()? function,
  required String text,
  String? TextField,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  Function()? function,
  required String text,
}) =>
    TextButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
        ));

Widget defaultFormFaild({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onsubmet,
  Function(String)? onchange,
  Function()? onTap,
  required Validator validate,
  required String Label,
  required IconData prefix,
  bool isPassword = false,
  bool isClikable = true,
  IconData? suffix,
  Function()? sufixpressed,
  Function(String?)? onsaved,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClikable,
      onFieldSubmitted: onsubmet,
      onChanged: onchange,
      validator: validate,
      onTap: onTap,
      onSaved: onsaved,
      decoration: InputDecoration(
        labelText: Label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: sufixpressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
Widget defaultAppBar({
  required BuildContext context,
  String? titel,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_outlined),
      ),
      title: Text(titel!),
      actions: actions,
    );

// ignore: use_function_type_syntax_for_parameters
Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        // ignore: prefer_const_constructor
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutabls
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .UpdateData(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .UpdateData(status: 'archaived', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black54,
                ))
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).DeleteData(id: model['id']);
      },
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      // ignore: prefer_is_empty
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => MyDivider(),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 120,
              color: Colors.grey,
            ),
            // ignore: prefer_const_constructor
            Text(
              'No tasks yet🙁,please add some tasks😃',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );

Widget MyDivider() => Padding(
      // ignore: prefer_const_constructor
      padding: EdgeInsetsDirectional.only(start: 15.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget articalBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticalItem(list[index], context),
        separatorBuilder: (context, index) => MyDivider(),
        itemCount: 10,
      ),
      fallback: (context) =>
          isSearch ? Container() : Center(child: CircularProgressIndicator()),
    );

buildArticalItem(list, BuildContext context) {}

void NavigateTo(context, Widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Widget),
    );

void NavigateAndFinsh(context, Widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Widget,
    ),
    (route) => false);

void ShowToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// enum
// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
