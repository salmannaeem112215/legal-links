import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/src/auth/view/confirmation_dialog.dart';
import 'package:legal_links_app/utils/bottom_sheets/change_password_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../resources/validator.dart';
import '../../../utils/bottom_sheets/forget_password_sheet.dart';
import '../../../utils/common-widgets/custom_button.dart';
import '../../../utils/common-widgets/custom_textformfield.dart';
import '../../../utils/common-widgets/global_widget.dart';
import '../../../utils/hights_widths.dart';
import '../vm/auth_vm.dart';

class LoginScreen extends StatefulWidget {
  static String route = "/loginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController(/* text: 'luffy@gmail.com' */);
  TextEditingController passwordController = TextEditingController(/* text: '12345@' */);

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool ispObscure = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthVM>(builder: (context, vm, _) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // debugPrint("mrd0EqAOwVKV7wkksyf6");
                      // FirebaseFirestore.instance
                      //     .collection("lawyer_scedule")
                      //     .doc("mrd0EqAOwVKV7wkksyf6")
                      //     .get()
                      //     .then((value) => debugPrint(jsonEncode(value.data())));
                    },
                    child: Image.asset(R.images.logo, height: 25.h),
                  ),
                  h2,
                  Text(
                    "Login",
                    style: R.textStyles.poppinsBold(
                      color: R.colors.primary,
                      fontSize: 18.sp,
                    ),
                  ),
                  h2,
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
                  CustomTextFormField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.visiblePassword,
                    validator: FieldValidator.validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hintText: 'Enter password',
                    fieldTitle: "Password",
                    obscureText: ispObscure,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          ispObscure = !ispObscure;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.sp),
                        child: Icon(
                          ispObscure ? Icons.visibility_off_rounded : Icons.remove_red_eye_rounded,
                          color: Colors.grey,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  h2,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        {
                          Get.bottomSheet(
                            const ForgotPasswordSheet(
                              title: 'Forgot Password?',
                              subTitle:
                                  'Enter your reqistered Email ID We will send you a link to reset your password',
                              labelText: 'Email',
                              placeHolder: 'Enter email',
                              text: 'Proceed',
                              isFromDelete: false,
                            ),
                            isScrollControlled: true,
                          );
                          Get.back();
                          Get.bottomSheet(ChangePasswordSheet());
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Forgot Password?",
                            textAlign: TextAlign.center,
                            style: R.textStyles.poppinsMedium(
                              fontSize: 12.sp,
                              color: R.colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  h2,
                  CustomButton(
                    buttonTitle: "Login",
                    tap: () async {
                      await login(vm);
                    },
                  ),
                  h2,
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 8.sp),
            child: GlobalWidgets.authBottomWidget(
              "Don't have an account?",
              '  Sign up',
              () => Get.dialog(const ConfirmationDialog()),
            ),
          ),
        );
      }),
    );
  }

  Future<void> login(AuthVM vm) async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthVM>().signIn(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }
}
