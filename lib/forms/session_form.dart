import 'package:flutter/material.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/models/session.dart';
import 'package:strudl/services/ui_helper.dart';

class SessionForm extends StatefulWidget {
  final Function handleSubmit;
  final Function? onCancel;
  final Function? handleDelete;
  final Session? initialState;
  final String? sumbitButtonText;
  const SessionForm(
      {Key? key,
      required this.handleSubmit,
      this.handleDelete,
      this.initialState,
      this.sumbitButtonText,
      this.onCancel})
      : super(key: key);

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  final formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final courseIdController = TextEditingController();
  final sessionTypeIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialState != null) {
      noteController.text = widget.initialState!.note ?? "";
      startController.text = widget.initialState!.start.toString();
      endController.text = widget.initialState!.end.toString();
      courseIdController.text = widget.initialState!.courseId.toString();
      sessionTypeIdController.text =
          widget.initialState!.sessionTypeId.toString();
    } else {
      courseIdController.text = AppController.to.courses.first.id.toString();
      sessionTypeIdController.text =
          AppController.to.sessionTypes.first.id.toString();
      startController.text = DateTime.now().toIso8601String();
      endController.text = DateTime.now().toIso8601String();
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
          UiHelper.renderDateTimePicker(
            hint: "Start",
            contoller: startController,
            validationRules: ["required"],
          ),
          UiHelper.renderDateTimePicker(
            hint: "End",
            contoller: endController,
            validationRules: ["required"],
          ),
          UiHelper.renderSelect(
            hint: "Course",
            items: AppController.to.courses
                .map((c) => {
                      "text": c.title,
                      "value": c.id.toString(),
                      "color": c.color
                    })
                .toList(),
            onChanged: (String selected) {
              setState(() {
                courseIdController.text = selected;
              });
            },
            value: courseIdController.text,
            icon: const Icon(Icons.book_rounded),
          ),
          UiHelper.renderSelect(
            hint: "Category",
            items: AppController.to.sessionTypes
                .map((c) => {
                      "text": c.title,
                      "value": c.id.toString(),
                      "color": c.color
                    })
                .toList(),
            onChanged: (String selected) {
              setState(() {
                sessionTypeIdController.text = selected;
              });
            },
            value: sessionTypeIdController.text,
            icon: const Icon(Icons.category),
          ),
          UiHelper.renderTextInput(
            hint: "Note",
            controller: noteController,
            validationRules: [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.onCancel != null)
                TextButton(
                  onPressed: () => widget.onCancel!(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  // Validate the form
                  if (!formKey.currentState!.validate()) return;

                  // Submit the form
                  await widget.handleSubmit(
                    Session(
                      id: widget.initialState?.id ?? 0,
                      start: DateTime.parse(startController.text),
                      end: DateTime.parse(endController.text),
                      note: noteController.text,
                      courseId: int.parse(courseIdController.text),
                      sessionTypeId: int.parse(sessionTypeIdController.text),
                    ),
                  );
                },
                child: Text(widget.sumbitButtonText ?? "Submit"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
