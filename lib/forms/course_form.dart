import 'package:flutter/material.dart';
import 'package:strudl/models/course.dart';
import 'package:strudl/services/ui_helper.dart';

class CourseForm extends StatefulWidget {
  final Function handleSubmit;
  final Function? handleDelete;
  final Course? initialState;
  final String? sumbitButtonText;
  const CourseForm({
    Key? key,
    required this.handleSubmit,
    this.handleDelete,
    this.initialState,
    this.sumbitButtonText,
  }) : super(key: key);

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Color colorController = const Color(0xFF2da44e);
  Color colorSelected = const Color(0xFF2da44e);

  @override
  void initState() {
    super.initState();
    if (widget.initialState != null) {
      titleController.text = widget.initialState!.title;
      descriptionController.text = widget.initialState!.description ?? "";
      colorController = UiHelper.hexStringToColor(widget.initialState!.color);
      colorSelected = UiHelper.hexStringToColor(widget.initialState!.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.handleDelete != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: IconButton(
                    onPressed: () => widget.handleDelete!(widget.initialState),
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          UiHelper.renderTextInput(
            hint: "Title",
            controller: titleController,
            validationRules: ["required"],
          ),
          UiHelper.renderTextInput(
            hint: "Description",
            controller: descriptionController,
            validationRules: [],
          ),
          UiHelper.renderColorSelect(
            hint: "Theme color",
            controller: colorController,
            selected: colorSelected,
            onChanged: (color) {
              setState(() {
                colorController = color;
              });
            },
            onSelected: () {
              setState(() {
                colorSelected = colorController;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate the form
              if (!formKey.currentState!.validate()) return;

              // Submit the form
              await widget.handleSubmit(
                Course(
                  id: widget.initialState?.id ?? 0,
                  title: titleController.text,
                  description: descriptionController.text,
                  color: UiHelper.colorToHexString(colorSelected),
                ),
              );
            },
            child: Text(widget.sumbitButtonText ?? "Submit"),
          ),
        ],
      ),
    );
  }
}
