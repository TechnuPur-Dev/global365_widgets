import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global365_widgets/src/authentication/signup/controllers/signup_controller/business_profile_controller.dart';
import 'package:global365_widgets/src/dropdowns/searchabledropdowncustom/dropdown_plus.dart';
import 'package:global365_widgets/src/theme/dropdown_theme.dart';
import 'package:global365_widgets/src/utils/api_services/get_request.dart';
import 'package:global365_widgets/src/utils/api_client/api_client.dart';
import 'package:global365_widgets/src/utils/toast/delightful_toast_class.dart';
import 'package:global365_widgets/src/constants/globals.dart';

class StateDropdown extends StatefulWidget {
  final bool isNotHistory;
  final bool isLoading;
  final bool isUpdate;
  final bool isEnabled;
  final String partyId;
  final String label;
  final void Function(dynamic item)? onChanged;
  final bool isShowLabelingColumn;
  final double? containerHeight;
  final Offset? offset;

  final DropdownEditingController<dynamic> controller;
  const StateDropdown({
    required this.controller,
    this.isNotHistory = false,
    this.isLoading = false,
    this.isUpdate = false,
    this.isEnabled = false,
    this.partyId = "0",
    this.label = "Company",
    this.onChanged,
    this.isShowLabelingColumn = true,
    this.containerHeight,
    this.offset,
    Key? key,
  }) : super(key: key);

  @override
  State<StateDropdown> createState() => _StateDropdownState();
}

class _StateDropdownState extends State<StateDropdown> {
  @override
  void initState() {
    // gLogger("List is ${BusinessProfileController.to.statesList.value}");
    controller = widget.controller;
    isNotHistory = widget.isNotHistory;
    isLoading = widget.isLoading;
    isUpdate = widget.isUpdate;
    fetchData();
    super.initState();
  }

  String objectName = "name";
  String objectIDName = "value";

  bool isNotHistory = false;
  bool isUpdate = false;

  Future<void> fetchData() async {
    if (BusinessProfileController.to.selectedLocationId.value == 0) {
      GToast.info(context, "Please select location");
      return;
    }
    if (BusinessProfileController.to.statesList.isEmpty) {
      setState(() {
        isLoading = false;
      });
      APIsCallGet.getData(
        "Companies/GetStatesByLocationId?locationId=${BusinessProfileController.to.selectedLocationId.value}",
      ).then((response) {
        print(response.statusCode);
        print(response.data);
        if (response.statusCode == 200) {
          dynamic payLoad = jsonDecode(response.data);
          List parsed = payLoad['payload'];

          List tempNew = isNotHistory
              ? []
              : [
                  {"value": "0", "label": "All"},
                ];
          tempNew.addAll(parsed);
          if (!isNotHistory) {
            controller.value = tempNew[0];
          }

          setState(() {
            listItems = tempNew;
            BusinessProfileController.to.statesList.value = tempNew;
          });

          if (!isUpdate) {
            setState(() {
              isLoading = true;
            });
          } else {
            findandAssignValue();
          }
        } else {
          setState(() {
            isLoading = true;
          });
        }
      });
    } else {
      final parsed = BusinessProfileController.to.statesList;
      List tempNew = isNotHistory
          ? []
          : [
              {"value": "0", "label": "All"},
            ];
      tempNew.addAll(parsed);

      if (!isNotHistory) {
        controller.value = tempNew[0];
      }

      setState(() {
        listItems = tempNew;
      });
      if (!isUpdate) {
        setState(() {
          isLoading = true;
        });
      } else {
        findandAssignValue();
      }
    }
  }

  findandAssignValue() {
    for (int i = 0; i < listItems.length; i++) {
      if (listItems[i][objectIDName].toString() == widget.partyId) {
        controller.value = listItems[i];
      }
    }
    setState(() {
      isLoading = true;
    });
  }

  bool isLoading = false;
  List listItems = [];
  DropdownEditingController controller = DropdownEditingController();
  Widget dropDownCompanies() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        if (widget.isShowLabelingColumn) GDropDownTheme.headerTextBold(widget.label),
        //     Text(
        //       " *",
        //       style: GoogleFonts.poppins(
        //           fontSize: 14, fontWeight: FontWeight.w800, color: Colors.red),
        //     ),
        //   ],
        // ),
        if (widget.isShowLabelingColumn) const SizedBox(height: 4),

        (isLoading)
            ? Container(
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                // decoration: ShapeDecoration(
                //   color: Colors.white,
                //   shape: RoundedRectangleBorder(
                //     side: BorderSide(width: 1, color: dashSecondHeaderPrimaryColor),
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                // ),
                height: widget.containerHeight,
                child: DropdownFormField<dynamic>(
                  offset: widget.offset ?? const Offset(0, 0),
                  onEmptyActionPressed: null,
                  emptyActionText: "",
                  controller: controller,
                  decoration: GDropDownTheme.dropDownDecorationBold(widget.label),
                  onSaved: (dynamic str) {
                    print("run on saved");
                  },
                  onChanged: widget.onChanged,
                  validator: (dynamic str) {
                    print("run on validator");
                    return null;
                  },
                  displayItemFn: (dynamic item) => Text(
                    (item ?? {})[objectName] ?? '',
                    style: GDropDownTheme.displayTextStyleBold(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  findFn: (dynamic str) async => listItems,
                  selectedFn: (dynamic item1, dynamic item2) {
                    if (item1 != null && item2 != null) {
                      print(item2);
                      return item1[objectName] == item2[objectName];
                    }
                    return false;
                  },
                  filterFn: (dynamic item, str) => item[objectName].toLowerCase().indexOf(str.toLowerCase()) >= 0,
                  dropdownItemFn: (dynamic item, int position, bool focused, bool selected, Function() onTap) =>
                      ListTile(
                        title: Text(item[objectName].toString(), style: GDropDownTheme.dropDownItemStyle()),
                        tileColor: focused ? const Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
                        onTap: onTap,
                      ),
                ),
              )
            : globalSpinkitForLoaderswithBorder(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: dropDownCompanies());
  }
}
