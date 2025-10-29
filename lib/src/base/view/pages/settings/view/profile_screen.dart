import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/constants/enums.dart';
import 'package:legal_links_app/src/auth/model/user_model.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/settings/view/update_client_profile.dart';
import 'package:legal_links_app/src/base/view/pages/settings/view/update_lawyer_profile.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/common-widgets/global_widget.dart';
import '../../../../../../utils/hights_widths.dart';
import '../model/profile_model.dart';
import 'widgets/custom_data_widget.dart';

class ProfileScreen extends StatefulWidget {
  static String route = '/profileroute';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late ClientModel model;
  dynamic args;
  late TabController tabController;
  List tabTitle = ['Lawyer', "Client Profile"];
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        if (args["model"] != null) {
          model = args["model"];
        }
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(
      builder: (context, authVm, _) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton:
                //  authVm.userModel.role == UserRole.CLIENT
                //     ?
                FloatingActionButton(
              backgroundColor: R.colors.primary,
              onPressed: () {
                if (authVm.userModel.role == UserRole.CLIENT) {
                  Get.to(() => const UpdateClientScreen());
                } else if (authVm.userModel.role == UserRole.LAWYER) {
                  Get.to(() => const UpdateLawyerProfile());
                }
              },
              child: Icon(
                Icons.edit,
                color: R.colors.white,
              ),
            ),
            // : null,
            appBar: GlobalWidgets.appBar('Profils'),
            body: authVm.userModel.role == UserRole.LAWYER
                ? lawyerProfileWidget(authVm)
                : clientProfileWidget(authVm),
          ),
        );
      },
    );
  }

  Widget lawyerProfileWidget(AuthVM vm) {
    return Column(
      children: [
        h2,
        ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: CachedNetworkImage(
            imageUrl: vm.userModel.profileImages?.first ?? '',
            imageBuilder: (context, imageProvider) => Container(
              height: 35.w,
              width: 35.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: R.colors.white, width: 1),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            fit: BoxFit.cover,
            errorWidget: (context, url, e) =>
                SizedBox(height: 35.w, width: 35.w, child: const Icon(Icons.error)),
            placeholder: (context, url) {
              return Center(
                  child: SizedBox(
                height: 35.w,
                width: 35.w,
                child: CircularProgressIndicator.adaptive(backgroundColor: R.colors.primary),
              ));
            },
          ),
        ),
        h2,
        Text(
          vm.userModel.fullName ?? '',
          style: R.textStyles.poppinsBold(fontSize: 15),
        ),
        Text(vm.userModel.email ?? '', style: R.textStyles.poppinsRegular()),
        h4,
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Information',
                  style: R.textStyles.poppinsBold(fontSize: 13),
                ),
                h1,
                Text(
                  'About',
                  style: R.textStyles.poppinsMedium(),
                ),
                Text(
                  vm.userModel.about ?? '',
                  style: R.textStyles.poppinsRegular(
                    color: R.colors.darkGrey,
                    letterSpacing: 0.45,
                  ),
                ),
                h1,
                CustomData(title: 'Name:', subTitle: vm.userModel.fullName ?? ''),
                h1,
                CustomData(title: 'Assistent Name:', subTitle: vm.userModel.assistantName ?? ''),
                h1,
                CustomData(title: 'Specialist Lawyer:', subTitle: vm.userModel.specialist![0]),
                h1,
                CustomData(
                  title: 'Qualifications:',
                  subTitle: vm.userModel.qualifications
                          ?.map((q) => " ${q.degree} (${q.institute})")
                          .join(', ') ??
                      '',
                ),
                h1,
                CustomData(
                    title: 'Experience:',
                    subTitle: vm.userModel.experience
                            ?.map((e) => "${e.lawFirm} (${e.position})")
                            .join(',') ??
                        ''),
                h1,
                CustomData(
                    title: 'Location:', subTitle: vm.userModel.officeAdress?.streetAdress ?? ""),
                h1,
                CustomData(title: 'Number:', subTitle: phoneNumber(vm.userModel.phoneNumber)),
                h1,
                CustomData(title: 'Email:', subTitle: vm.userModel.email ?? ''),
                h1,
                CustomData(
                  title: 'Gender:',
                  subTitle: getGenderString(vm.userModel.gender),
                ),
                h1,
                CustomData(
                    title: 'Years of Experience:',
                    subTitle: vm.userModel.yearOfExperience.toString()),
                h1,
                CustomData(title: 'Cases Count:', subTitle: vm.userModel.casesCount.toString()),
                h1,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Practice Area',
                        style: R.textStyles.poppinsMedium(
                          fontSize: 12,
                          color: R.colors.black,
                          letterSpacing: 0.45,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: List.generate(
                          vm.userModel.practiceAreas!.length,
                          (index) => Text(
                            vm.userModel.practiceAreas![index],
                            style: R.textStyles.poppinsRegular(
                              color: R.colors.darkGrey,
                              letterSpacing: 0.45,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // h1,
                // CustomData(title: 'License Number:', subTitle: "234 34354545"),
                h1,
                CustomData(title: 'Fee:', subTitle: vm.userModel.feePerMeeting.toString()),
                h1,
                h4,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget clientProfileWidget(AuthVM authVM) {
    return Column(
      children: [
        h2,
        Center(
          child: CircleAvatar(
            backgroundColor: R.colors.primary.withOpacity(.2),
            radius: 70,
            backgroundImage: NetworkImage(authVM.userModel.profileImages?.first ?? ""),
            onBackgroundImageError: (exception, stackTrace) {
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: R.colors.primary.withOpacity(.8), width: 1),
                ),
                child: Icon(
                  Icons.error,
                  color: R.colors.black,
                ),
              );
            },
          ),
        ),
        h3,
        Text(
          authVM.userModel.fullName ?? '',
          style: R.textStyles.poppinsBold(fontSize: 15),
        ),
        Text(authVM.userModel.email ?? '', style: R.textStyles.poppinsRegular()),
        h4,
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Information :',
                  style: R.textStyles.poppinsBold(fontSize: 13),
                ),
                h1,
                // if (authVM.userModel.about != "" || authVM.userModel.about != null)
                //   Text(
                //     'About ${authVM.userModel.about}',
                //     style: R.textStyles.poppinsMedium(),
                //   ),
                // if (authVM.userModel.about != "" || authVM.userModel.about != null)
                //   Text(
                //     authVM.userModel.about ?? "",
                //     style: R.textStyles.poppinsRegular(
                //       color: R.colors.darkGrey,
                //       letterSpacing: 0.45,
                //     ),
                //   ),
                // h1,
                CustomData(title: 'Name:', subTitle: authVM.userModel.fullName ?? ''),
                h1,
                // CustomData(
                //     title: 'Location:',
                //     subTitle: authVM.userModel.officeAdress?.streetAdress ?? ''),
                // h1,
                CustomData(
                  title: 'Number:',
                  subTitle: phoneNumber(authVM.userModel.phoneNumber),
                ),
                h1,
                CustomData(title: 'Email:', subTitle: authVM.userModel.email ?? ''),
                h1,
                // CustomData(title: 'Gender:', subTitle: getGenderString(authVM.userModel.gender)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String phoneNumber(PhoneNumberModel? numberModel) {
    return "${numberModel?.countryCode} ${numberModel?.number}";
  }
}
