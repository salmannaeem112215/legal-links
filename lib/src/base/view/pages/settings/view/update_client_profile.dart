import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/resources/validator.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/utils/common-widgets/custom_button.dart';
import 'package:legal_links_app/utils/common-widgets/custom_textformfield.dart';
import 'package:legal_links_app/utils/common-widgets/global_widget.dart';
import 'package:legal_links_app/utils/hights_widths.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UpdateClientScreen extends StatefulWidget {
  static String route = "/UpdateClientScreen";
  const UpdateClientScreen({super.key});

  @override
  State<UpdateClientScreen> createState() => _UpdateClientScreenState();
}

class _UpdateClientScreenState extends State<UpdateClientScreen> {
  showSnackBar(context, text) {
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar((snackBar));
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController dateCon = TextEditingController();

  DateTime? selectedDate;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmpasswordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode genderFn = FocusNode();

  bool isObscure1 = false;
  bool isObscure2 = false;

  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode numberFN = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var vm = Provider.of<AuthVM>(context, listen: false);
      // aboutTC.text = vm.userModel.about ?? "";
      nameController.text = vm.userModel.fullName ?? "";
      phoneNumberController.text = vm.userModel.phoneNumber?.number ?? "";
      // number.isoCode = vm.userModel.phoneNumber ?? "";
      // vm.imageUrl = null;
      // vm.pImage = null;
      // vm.update();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(builder: (context, authVm, _) {
      return SafeArea(
        child: Scaffold(
          appBar: GlobalWidgets.appBar(
            "Update Profile",
            onTap: () {
              Get.back();
            },
          ),
          body: SingleChildScrollView(
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
                  h3,
                ],
              ),
            ),
          ),
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
    });
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
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const UnderlineInputBorder(),
      onSaved: (PhoneNumber number) {
        debugPrint('On Saved: $number');
      },

      onFieldSubmitted: (value) {
        setState(() {});
        FocusScope.of(context).requestFocus(passwordFocus);
      },
    );
  }

  Future<void> buttonFn() async {
    if (_formKey.currentState!.validate()) {
      Timestamp now = Timestamp.now();
      UserModel updateClient = UserModel(
        fullName: nameController.text.trim(),
        updatedAt: now,
        phoneNumber: PhoneNumberModel(
          number: phoneNumberController.text.trim(),
          isoCode: number.isoCode,
          countryCode: number.dialCode,
        ),
      );
      //
      Map<String, dynamic> updateData = {
        'fullName': updateClient.fullName,
        'updatedAt': updateClient.updatedAt,
        'phoneNumber': {
          'number': updateClient.phoneNumber?.number,
          'isoCode': updateClient.phoneNumber?.isoCode,
          'countryCode': updateClient.phoneNumber?.countryCode,
        }
      };

      await context.read<AuthVM>().updateUserData(
            updateData,
            context.read<AuthVM>().userModel.id ?? "",
          );

      // debugPrint(" body: ");
      // debugPrint('role: ${context.read<AuthVM>().userRole}');
      // debugPrint('fullName: ${nameController.text.trim()}');
      // debugPrint('updatedAt: $now');
      // debugPrint('phoneNumberController: ${phoneNumberController.text.trim()}');
      // debugPrint('number.isoCode: ${number.isoCode}');
      // debugPrint('number.dialCode: ${number.dialCode}');
    }
  }
}
