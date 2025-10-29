import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:legal_links_app/resources/validator.dart';
import 'package:legal_links_app/services/google_map/address_model.dart';
import 'package:legal_links_app/src/auth/model/lawyer_model.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../services/google_map/google_map_screen.dart';
import '../../../../../../utils/common-widgets/custom_button.dart';
import '../../../../../../utils/common-widgets/global_widget.dart';
import '../../../../../../utils/hights_widths.dart';

class UpdateLawyerProfile extends StatefulWidget {
  static String route = '/updatelawyerprofile';
  const UpdateLawyerProfile({super.key});

  @override
  State<UpdateLawyerProfile> createState() => _UpdateLawyerProfileState();
}

class _UpdateLawyerProfileState extends State<UpdateLawyerProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController assistantController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController caseCountController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController yearExperienceController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController dateCon = TextEditingController();

  DateTime? selectedDate;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmpasswordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode experienceFocus = FocusNode();
  FocusNode feeFocus = FocusNode();
  FocusNode genderFn = FocusNode();
  FocusNode assistantFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode aboutFocus = FocusNode();

  bool isObscure1 = false;
  bool isObscure2 = false;

  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode numberFN = FocusNode();
  List<Qualifications> qualificationList = [Qualifications()];
  List<Experience> experienceList = [Experience()];
  List<String> practiceAreaList = [];

  LatLng? latLng;
  PickLocationData? pickLocationData;
  UserModel? tempModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var vm = Provider.of<AuthVM>(context, listen: false);
      nameController.text = vm.userModel.fullName ?? "";
      phoneNumberController.text = vm.userModel.phoneNumber?.number ?? "";
      yearExperienceController.text = vm.userModel.yearOfExperience.toString();
      feeController.text = vm.userModel.feePerMeeting.toString();
      assistantController.text = vm.userModel.assistantName ?? "";
      caseCountController.text = vm.userModel.casesCount.toString();
      aboutController.text = vm.userModel.about ?? "";
      // practiceAreaList = vm.userModel.practiceAreas ?? [];
      addressController.text = vm.userModel.officeAdress?.streetAdress ?? "";

      number = PhoneNumber(
        dialCode: vm.userModel.phoneNumber?.countryCode ?? "",
        isoCode: vm.userModel.phoneNumber?.isoCode ?? "",
        phoneNumber: vm.userModel.phoneNumber?.number ?? "",
      );

      //nameController.text = vm.userModel.fullName ?? "";

      // number.isoCode = vm.userModel.phoneNumber ?? "";
      // vm.imageUrl = null;
      // vm.pImage = null;
      // vm.update();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GlobalWidgets.appBar(
          "Update Profile",
          onTap: () {
            Get.back();
          },
        ),
        body: Consumer<AuthVM>(builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  h3,
                  CustomTextFormField(
                    fieldTitle: "Full Name",
                    controller: nameController,
                    hintText: 'Enter name',
                    focusNode: nameFocus,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.name,
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  h1,
                  Container(
                    margin:
                        EdgeInsets.only(left: 4.sp, bottom: 4.sp, top: 6.sp),
                    child: Text(
                      "Phone Number",
                      style: R.textStyles.poppinsMedium(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  phoneNumberField(),
                  h1,
                  CustomTextFormField(
                    fieldTitle: "Year of experience",
                    controller: yearExperienceController,
                    hintText: 'How many year of experience do you have?',
                    focusNode: experienceFocus,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  h1,
                  CustomTextFormField(
                    fieldTitle: "Fee",
                    controller: feeController,
                    hintText: 'Fee',
                    focusNode: feeFocus,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.name,
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  h1,
                  // Text(
                  //   'SpecialList',
                  //   style: R.textStyles.poppinsMedium(),
                  // ),
                  // h1,
                  // speciallistLawyerDropdown(vm: vm),
                  CustomTextFormField(
                    controller: assistantController,
                    focusNode: assistantFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    hintText: 'Assistant Name',
                    fieldTitle: "Assistant Name",
                  ),
                  CustomTextFormField(
                    controller: caseCountController,
                    //  focusNode: feeFocus,
                    inputAction: TextInputAction.next,
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hintText: '10',
                    fieldTitle: "Case Count",
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                  CustomTextFormField(
                    controller: addressController,
                    focusNode: addressFocus,
                    inputAction: TextInputAction.next,
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputType: TextInputType.streetAddress,
                    hintText: 'Address',
                    fieldTitle: "Your address",
                    onTap: () {
                      debugPrint(
                          "vm.userModel.officeAdress?.streetAdress ${vm.userModel.officeAdress?.streetAdress}");
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => GoogleMapScreen(
                            selectedLocation: latLng,
                            address: (value) {
                              pickLocationData = value;
                              latLng = LatLng(value.lat ?? 0, value.lng ?? 0);
                              addressController.text =
                                  pickLocationData?.streetAddress ?? '';
                            },
                          ),
                        );
                        setState(() {});
                        debugPrint("pickLocationData $pickLocationData");
                      },
                      child: const Icon(Icons.location_pin),
                    ),
                  ),
                  h1,
                  CustomTextFormField(
                    controller: aboutController,
                    focusNode: aboutFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    hintText: 'About Yourself',
                    fieldTitle: "About Yourself",
                    maxLines: 3,
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  h1,
                  h1,
                  // heading('Practice Area', () {
                  //   setState(() {
                  //     practiceAreaList.add("");
                  //   });
                  // }),
                  // h1,
                  // for (int index = 0; index < practiceAreaList.length; index++) ...[
                  //   practiceField(practiceAreaList[index], index),
                  //   h0P8,
                  // ],
                  h1,
                  // heading('Your Experience', () {
                  //   setState(() {
                  //     experienceList.add(
                  //       Experience(),
                  //     );
                  //   });
                  // }),
                  // h1,
                  // for (int index = 0;
                  //     index < experienceList.length;
                  //     index++) ...[
                  //   customTextFieldExperience(experienceList[index], index),
                  //   h0P8,
                  // ],
                  // h1,
                  // heading('Your Qualification', () {
                  //   setState(() {
                  //     qualificationList.add(Qualifications());
                  //   });
                  // }),
                  // h1,
                  // for (int index = 0;
                  //     index < qualificationList.length;
                  //     index++) ...[
                  //   qualificationFieldRow(qualificationList[index], index),
                  //   h0P8,
                  // ],
                  h1,
                ],
              ),
            ),
          );
        }),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
          child: CustomButton(
            buttonTitle: "Save",
            tap: () async {
              await buttonFn();
            },
          ),
        ),
      ),
    );
  }

  LawyerModelSignup? laywersSpe;

  Widget speciallistLawyerDropdown({required AuthVM vm}) {
    return DropdownButtonFormField<LawyerModelSignup?>(
      borderRadius: BorderRadius.circular(8),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: vm.castList
          .map((item) => DropdownMenuItem<LawyerModelSignup?>(
                value: item,
                child: Text(
                  item.specialist ?? "",
                  style: R.textStyles
                      .poppinsRegular(color: R.colors.black, fontSize: 8),
                ),
              ))
          .toList(),
      decoration: R.decoration.fieldDecoration(hintText: "Select Specialist"),
      value: laywersSpe,
      validator: (value) {
        if (value == null) {
          return "required";
        }
        return null;
      },
      onChanged: (value) {
        laywersSpe = value;
      },
    );
  }

  Widget phoneNumberField() {
    return InternationalPhoneNumberInput(
      focusNode: numberFN,
      inputDecoration: InputDecoration(
        isDense: true,
        suffixIcon: Icon(
          Icons.phone_outlined,
          color: numberFN.hasFocus ? R.colors.primary : R.colors.grey,
        ),
        hintText: 'Number',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        filled: true,
        focusColor: R.colors.primary,
        hintStyle:
            R.textStyles.poppinsRegular(fontSize: 11, color: Colors.grey),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
              color: R.colors.red,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
              color: R.colors.primary,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: R.colors.primary,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
              color: R.colors.red,
            )),
      ),
      // onInputChanged: (PhoneNumber phonenumber) {
      //   number = phonenumber;
      // },
      onInputChanged: (PhoneNumber number) {
        if ((number.phoneNumber?.length ?? 0) < 1) {
          setState(() {});
        }
      },
      onInputValidated: (val) {
        debugPrint(val.toString());
        setState(() {});
      },
      selectorConfig: const SelectorConfig(
          leadingPadding: 10,
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          showFlags: false,
          setSelectorButtonAsPrefixIcon: true,
          trailingSpace: true),
      spaceBetweenSelectorAndTextField: 0,
      selectorTextStyle: TextStyle(color: R.colors.primary),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      initialValue: number,
      textFieldController: phoneNumberController,
      // validator: (value) {},
      formatInput: false,
      keyboardAction: TextInputAction.done,
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: false),
      inputBorder: const UnderlineInputBorder(),

      onSaved: (PhoneNumber number) {
        debugPrint('On Saved: $number');
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
        FocusScope.of(context).requestFocus(passwordFocus);
      },
    );
  }

  Future<void> buttonFn() async {
    print('Fee Value: ${feeController.text}');

    num feeValue = double.parse(feeController.text.trim());
    num caseCountControllerValue =
        double.parse(caseCountController.text.trim());
    // ignore: unused_local_variable
    // int? yearExperience;
    // if (yearExperienceController.text.isNotEmpty) {
    //   yearExperience = int.tryParse(yearExperienceController.text);
    // }
    debugPrint('Fee Value: $feeValue');

    if (_formKey.currentState!.validate()) {
      Timestamp now = Timestamp.now();
      UserModel updateLawyer = UserModel(
        fullName: nameController.text.trim(),
        updatedAt: now,
        phoneNumber: PhoneNumberModel(
          number: phoneNumberController.text.trim(),
          isoCode: number.isoCode,
          countryCode: number.dialCode,
        ),
        feePerMeeting: feeValue,
        about: aboutController.text,
        yearOfExperience: yearExperienceController.text.trim(),
        // practiceAreas: practiceAreaList,
        assistantName: assistantController.text.trim(),
        casesCount: caseCountControllerValue,

        officeAdress: OfficeAdress(
          city: pickLocationData?.city,
          country: pickLocationData?.country,
          latLng:
              GeoPoint(pickLocationData?.lat ?? 0, pickLocationData?.lng ?? 0),
          state: pickLocationData?.city,
          streetAdress: addressController.text.trim(),
          zipCode: pickLocationData?.city,
        ),
      );

      Map<String, dynamic> updateData = {
        "fullName": updateLawyer.fullName,
        'phoneNumber': {
          'number': updateLawyer.phoneNumber?.number,
          'isoCode': updateLawyer.phoneNumber?.isoCode,
          'countryCode': updateLawyer.phoneNumber?.countryCode,
        },
        "about": updateLawyer.about,
        "assistantName": updateLawyer.assistantName,
        "casesCount": updateLawyer.casesCount,
        "feePerMeeting": updateLawyer.feePerMeeting,
        "yearOfExperience": updateLawyer.yearOfExperience,
        "officeAdress": {
          "zipCode": updateLawyer.officeAdress?.zipCode,
          "country": updateLawyer.officeAdress?.country,
          "streetAdress": updateLawyer.officeAdress?.streetAdress,
          "city": updateLawyer.officeAdress?.city,
          "state": updateLawyer.officeAdress?.state,
          "latLng": updateLawyer.officeAdress?.latLng,
        },
        "updatedAt": updateLawyer.updatedAt,
      };

      debugPrint(" body: $updateData");

      await context.read<AuthVM>().updateUserData(
            updateData,
            context.read<AuthVM>().userModel.id ?? "",
          );
    }

    Widget heading(String text, VoidCallback onTap) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: R.textStyles.poppinsMedium(),
          ),
          TextButton(
              onPressed: onTap,
              child: Text(
                'ADD MORE',
                style: R.textStyles
                    .poppinsSemiBold(color: R.colors.primary, fontSize: 10),
              )),
        ],
      );
    }

    Widget customTextFieldExperience(Experience item, int index) {
      return Row(
        children: [
          Expanded(
            flex: 5,
            child: CustomTextFormField(
              hintText: "Designation",
              inputAction: TextInputAction.next,
              inputType: TextInputType.name,
              validator: FieldValidator.validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  experienceList[index].position = value;
                });
                return "";
              },
            ),
          ),
          w2,
          Expanded(
            flex: 5,
            child: CustomTextFormField(
              hintText: "Firm/Court",
              // focusNode: lawyerFocus,
              inputAction: TextInputAction.next,
              inputType: TextInputType.name,
              validator: FieldValidator.validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  experienceList[index].lawFirm = value;
                });
                return "";
              },
            ),
          ),
          if (index >= 1)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    experienceList.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: R.colors.red,
                  size: 22.sp,
                ),
              ),
            ),
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: Container(),
          ),
        ],
      );
    }

    Widget qualificationFieldRow(Qualifications item, int index) {
      return Row(
        children: [
          Expanded(
            flex: 5,
            child: CustomTextFormField(
              hintText: "Degree",
              // focusNode: degreeFocus,
              inputAction: TextInputAction.next,
              inputType: TextInputType.name,
              validator: FieldValidator.validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  qualificationList[index].degree = value;
                });
                return "";
              },
            ),
          ),
          w2,
          Expanded(
            flex: 5,
            child: CustomTextFormField(
              hintText: "Institute/University",
              // focusNode: instituteFocus,
              inputAction: TextInputAction.next,
              inputType: TextInputType.name,
              validator: FieldValidator.validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  qualificationList[index].institute = value;
                });
                return "";
              },
            ),
          ),
          if (index >= 1)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    qualificationList.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: R.colors.red,
                  size: 20.sp,
                ),
              ),
            ),
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: Container(),
          ),
        ],
      );
    }

    Widget practiceField(String item, int index) {
      return Row(
        children: [
          Expanded(
            flex: 9,
            child: CustomTextFormField(
              initialVal: item,
              hintText: "Practice Area",
              //focusNode: lawyerFocus,
              inputAction: TextInputAction.next,
              inputType: TextInputType.name,
              validator: FieldValidator.validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  practiceAreaList[index] = value;
                });
                return "";
              },
            ),
          ),
          if (index >= 1)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    practiceAreaList.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: R.colors.primary,
                  size: 25.sp,
                ),
              ),
            ),
          Expanded(
            flex: index == 0 ? 2 : 1,
            child: Container(),
          ),
        ],
      );
    }
  }
}
