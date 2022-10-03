import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/models/session_type.dart';
import 'package:strudl/services/ui_helper.dart';

class SessionTypeForm extends StatefulWidget {
  final Function handleSubmit;
  final Function? handleDelete;
  final SessionType? initialState;
  final String? sumbitButtonText;
  const SessionTypeForm(
      {Key? key,
      required this.handleSubmit,
      this.initialState,
      this.sumbitButtonText,
      this.handleDelete})
      : super(key: key);

  @override
  State<SessionTypeForm> createState() => _SessionTypeFormState();
}

class _SessionTypeFormState extends State<SessionTypeForm> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialState != null) {
      titleController.text = widget.initialState!.title;
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
          ElevatedButton(
            onPressed: () async {
              // Validate the form
              if (!formKey.currentState!.validate()) return;

              // Submit the form
              await widget.handleSubmit(
                SessionType(
                  id: widget.initialState?.id ?? 0,
                  title: titleController.text,
                  color: UiHelper.colorToHexString(Get.theme.primaryColor),
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
