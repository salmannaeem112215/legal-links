import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/services/image_picker_service/image_picker_option.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:legal_links_app/utils/zbot_toast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/resources.dart';
import '../../../../resources/validator.dart';
import '../../../../utils/common-widgets/custom_textformfield.dart';
import '../../../../utils/hights_widths.dart';

class SignupScreenOneOfLawyer extends StatefulWidget {
  const SignupScreenOneOfLawyer({super.key});

  @override
  State<SignupScreenOneOfLawyer> createState() => _SignupScreenOneOfLawyerState();
}

class _SignupScreenOneOfLawyerState extends State<SignupScreenOneOfLawyer> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController yeearOfExperienceController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode numberFN = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode expFN = FocusNode();

  bool isObscure1 = false;
  bool isObscure2 = false;

  bool isChecked = false;
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  TextEditingController phoneNumberController = TextEditingController();

  DateTime? currentBackPressTime;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // nameController.text = "Test Lawyer";
      // emailController.text = "testlawyer1@gmail.com";
      // phoneNumberController.text = "3122323223";
      // yeearOfExperienceController.text = "23";

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, vm, _) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  pickImageWidget(vm),
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                  CustomTextFormField(
                    fieldTitle: "Email",
                    controller: emailController,
                    hintText: 'Enter email',
                    focusNode: emailFocus,
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.emailAddress,
                    validator: FieldValidator.validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  h1,
                  Container(
                    margin: EdgeInsets.only(left: 4.sp, bottom: 4.sp, top: 6.sp),
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
                    controller: yeearOfExperienceController,
                    focusNode: expFN,
                    inputAction: TextInputAction.next,
                    hintText: 'Years of Experience',
                    fieldTitle: "Years of Experience",
                    validator: FieldValidator.validateEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                  ),
                  h1,
                  Text(
                    'Gender',
                    style: R.textStyles.poppinsMedium(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                  h1,
                  genderDropDown(vm: vm),
                  h3,
                  h1,
                  CustomButton(
                    buttonTitle: 'Continue',
                    tap: () async {
                      await butonFn();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  GenderEnum? selectedGender;

  Widget genderDropDown({required AuthVM vm}) {
    return DropdownButtonFormField<GenderEnum>(
      //focusNode: maritalFn,
      borderRadius: BorderRadius.circular(8),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: GenderEnum.values.map((GenderEnum m) {
        return DropdownMenuItem<GenderEnum>(
          value: m,
          child: Text(
            getGenderString(m),
            style: R.textStyles.poppinsRegular(
              fontSize: 8,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      decoration: R.decoration.fieldDecoration(hintText: "Select Gender"),
      value: selectedGender,
      validator: (val) => FieldValidator.validateGender(val?.name ?? ""),
      onChanged: (GenderEnum? newValue) {
        setState(() {
          selectedGender = newValue;
        });
      },
    );
  }

  Widget pickImageWidget(AuthVM vm) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        Get.dialog(
          ImagePickerOption(
            uploadImage: (value) async {
              if (value != null) {
                profileImage = value;
                vm.update();
                setState(() {});
              }
            },
            isPhotoPicked: profileImage == null ? false : true,
            removeImageFn: () {
              profileImage = null;
              setState(() {});
              Navigator.pop(context);
            },
          ),
        );
      },
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 50.sp,
            height: 50.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: R.colors.white,
              border: Border.all(width: 3.0, color: R.colors.primary),
            ),
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: R.colors.primary.withOpacity(.08)),
              child: profileImage == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Icon(
                        Icons.add,
                        size: 25.sp,
                        color: R.colors.primary,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.file(
                        File(profileImage?.path ?? ""),
                        width: 40.sp,
                        height: 40.sp,
                      ),
                    ),
            ),
          ),
          w4,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Picture',
                textAlign: TextAlign.center,
                style: R.textStyles.poppinsMedium(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: R.colors.black,
                  letterSpacing: 0.32,
                ),
              ),
              Text(
                'Click to upload image',
                style: R.textStyles.poppinsRegular(
                  fontSize: 10,
                  color: R.colors.grey,
                  letterSpacing: -0.012,
                ),
              ),
            ],
          ),
        ],
      ),
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
        hintStyle: R.textStyles.poppinsRegular(fontSize: 11, color: Colors.grey),
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
      onInputChanged: (PhoneNumber phonenumber) {
        number = phonenumber;
      },
      onInputValidated: (val) {
        debugPrint(val.toString());
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
      // validator: (value) => FieldValidator.validatePhoneNumber(
      //     phoneNumberController.text.trim(), context),
      formatInput: false,
      keyboardAction: TextInputAction.done,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const UnderlineInputBorder(),
      onSaved: (PhoneNumber number) {
        debugPrint('On Saved: $number');
      },

      onFieldSubmitted: (value) {
        setState(() {});
        FocusScope.of(context).requestFocus(expFN);
      },
    );
  }

  Future<void> butonFn() async {
    if (_formKey.currentState!.validate()) {
      if (profileImage == null) {
        ZBotToast.showToastError(message: "Please Pick Image");
      } else {
        context.read<AuthVM>().tempLawyerProfileImage = profileImage;

        context.read<AuthVM>().tempLawyerModel = UserModel(
          role: context.read<AuthVM>().userRole,
          fullName: nameController.text.trim(),
          phoneNumber: PhoneNumberModel(
            number: phoneNumberController.text.trim(),
            isoCode: number.isoCode,
            countryCode: number.dialCode,
          ),
          email: emailController.text.trim(),
          status: UserStatus.PENDING,
          yearOfExperience: yeearOfExperienceController.text.toString(),
          gender: selectedGender,
          // profileImages: [profileImage?.path ?? ""],
        );

        context.read<AuthVM>().singupPageController.jumpToPage(1);
        context.read<AuthVM>().singupPage = 1;
        context.read<AuthVM>().update();
      }
    }
  }

  // UserModel dummyUser = UserModel(
  //   role: UserRole.ADMIN,
  //   assistantName: 'John Doe',
  //   isVerified: true,
  //   experiencedCasesCount: 50,
  //   fullName: 'John Doe',
  //   experience: Experience(
  //     lawFirm: 'Law Firm XYZ',
  //     endDate: '2022-01-01',
  //     position: 'Senior Lawyer',
  //     startDate: '2020-01-01',
  //   ),
  //   isLawyerVerified: 'Verified',
  //   practiceAreas: ['Criminal Law', 'Family Law'],
  //   yearOfExperience: '5 years',
  //   qualifications: Qualifications(
  //     year: '2010',
  //     degree: 'LLB',
  //     institute: 'Law School ABC',
  //   ),
  //   createdAt: DateTime.now(),
  //   phoneNumber: PhoneNumberModel(
  //     number: '1234567890',
  //     isoCode: 'US',
  //     countryCode: '+1',
  //   ),
  //   specialist: ['Litigation', 'Contracts'],
  //   profileImages: ['image1.jpg', 'image2.jpg'],
  //   about:
  //       'I am an experienced lawyer with expertise in criminal and family law.',
  //   officeAdress: OfficeAdress(
  //     zipCode: '12345',
  //     country: 'USA',
  //     streetAdress: '123 Main St',
  //     city: 'Anytown',
  //     state: 'CA',
  //     latLng: '37.7749° N, 122.4194° W',
  //   ),
  //   feePerMeeting: 100.0,
  //   gender: GenderEnum.MALE,
  //   id: '123456789',
  //   email: 'john.doe@example.com',
  //   updatedAt: DateTime.now(),
  //   status: UserStatus.ACTIVE,
  //   casesCount: 10,
  // );
}
