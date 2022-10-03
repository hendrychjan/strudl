import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:strudl/get/app_controller.dart';
import 'package:strudl/services/ui_helper.dart';

class SessionsOverviewFilterForm extends StatefulWidget {
  final Function handleSubmit;
  final Map initialState;
  const SessionsOverviewFilterForm({
    Key? key,
    required this.handleSubmit,
    required this.initialState,
  }) : super(key: key);

  @override
  State<SessionsOverviewFilterForm> createState() =>
      _SessionsOverviewFilterFormState();
}

class _SessionsOverviewFilterFormState
    extends State<SessionsOverviewFilterForm> {
  final formKey = GlobalKey<FormState>();
  final _rangeController = TextEditingController();
  final _customRangeDateFrom = TextEditingController();
  final _customRangeDateTo = TextEditingController();
  final _rangeTargetDate = TextEditingController();
  List _coursesController = [];
  List _sessionTypesController = [];

  final _timeRangeOptions = [
    {"text": "All time", "value": "alltime"},
    {"text": "Year", "value": "year"},
    {"text": "Month", "value": "month"},
    {"text": "Week", "value": "week"},
    {"text": "Custom", "value": "custom"},
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the fields from initial state
    _rangeController.text = widget.initialState["range"];
    _customRangeDateFrom.text =
        widget.initialState["customRangeDateFrom"].toString();
    _customRangeDateTo.text =
        widget.initialState["customRangeDateTo"].toString();
    _rangeTargetDate.text = widget.initialState["rangeTargetDate"].toString();
    _coursesController.addAll(widget.initialState["courses"]);
    _sessionTypesController.addAll(widget.initialState["sessionTypes"]);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UiHelper.renderMultiSelect(
            hint: "Courses",
            selectedItems: _coursesController,
            items: AppController.to.courses
                .map((e) => {
                      "text": e.title,
                      "value": e.id,
                    })
                .toList(),
            onChanged: (List<dynamic> values) {
              setState(() {
                _coursesController = values;
              });
            },
            context: context,
            selectedLength: _coursesController.length,
          ),
          UiHelper.renderMultiSelect(
            hint: "Session types",
            selectedItems: _sessionTypesController,
            items: AppController.to.sessionTypes
                .map((e) => {
                      "text": e.title,
                      "value": e.id,
                    })
                .toList(),
            onChanged: (List<dynamic> values) {
              setState(() {
                _sessionTypesController = values;
              });
            },
            context: context,
            selectedLength: _sessionTypesController.length,
          ),
          UiHelper.renderSelect(
            hint: "Time range",
            items: _timeRangeOptions,
            value: _rangeController.text,
            onChanged: (String selected) => setState(
              () {
                _rangeController.text = selected;
              },
            ),
          ),
          if (_rangeController.text == "custom")
            UiHelper.renderDateTimePicker(
              hint: "Date from",
              contoller: _customRangeDateFrom,
              validationRules: ["required"],
              type: DateTimePickerType.date,
            ),
          if (_rangeController.text == "custom")
            UiHelper.renderDateTimePicker(
              hint: "Date to",
              contoller: _customRangeDateTo,
              validationRules: ["required"],
              type: DateTimePickerType.date,
            ),
          if (_rangeController.text != "custom" &&
              _rangeController.text != "alltime")
            UiHelper.renderDateTimePicker(
              hint: "Target date",
              contoller: _rangeTargetDate,
              validationRules: ["required"],
              type: DateTimePickerType.date,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Get.back,
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Validate the form
                  if (!formKey.currentState!.validate()) return;

                  await widget.handleSubmit(
                    {
                      "range": _rangeController.text,
                      "customRangeDateFrom":
                          DateTime.parse(_customRangeDateFrom.text),
                      "customRangeDateTo":
                          DateTime.parse(_customRangeDateTo.text),
                      "rangeTargetDate": DateTime.parse(_rangeTargetDate.text),
                      "courses": _coursesController,
                      "sessionTypes": _sessionTypesController,
                    },
                  );
                },
                child: const Text("Ok"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
