import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:prolovelove/controller/auth_controller.dart';
import 'package:prolovelove/model/user_model.dart';
import 'package:prolovelove/view/facelock/login_face_lock.dart';
import '../../component/globalvariables.dart';
import '../../helper/assets.dart';
import '../../helper/button.dart';
import '../../helper/colors.dart';
import '../../helper/spacer.dart';
import '../component/social_login_button.dart';
import '../controller/notification_service.dart';
import 'call/calling_service.dart';
import 'facelock/locator.dart';
import 'facelock/register_face_lock.dart';
import 'facelock/services/camera.service.dart';
import 'facelock/services/face_detector_service.dart';
import 'facelock/services/ml_service.dart';
import 'login_screen.dart';
import 'registerScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  bool isLoading = false;
  bool loading = false;
  String? fcmuserToken;
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeServices();
    getTokken();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        fcmuserToken = value;
        print(value);

        print('device User token $fcmuserToken');
      }
    });
  }

  _initializeServices() async {
    setState(() => loading = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
    setState(() => loading = false);
  }

  getTokken() async {
    if (appStorage.read("tokken") != null) {
      final authController = Get.put(AuthController());

      setState(() {
        isLoading = true;
        userToken = appStorage.read("tokken");
        USERNAME = appStorage.read(userName);
        var userCID = appStorage.read("currentUserId");
        print("SetUserId $userCID");
        onUserLogin(userCID.toString(), USERNAME.toString());
      });
      log(userToken);
      log(USERNAME!);
      Future.delayed(const Duration(seconds: 6), () {
        //new kamlesh

        var professionalId = appStorage.read("professionalId");
        print("ProfessionalProfesssion $professionalId");
        if (professionalId == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => loginFaceLock(
                        userData: UserModel(firstName: USERNAME),
                        professionalId: 0,
                      )));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => loginFaceLock(
                        userData: UserModel(firstName: USERNAME),
                        professionalId: 1,
                      )));
          // Get.to(() => loginFaceLock(
          //       userData: UserModel(firstName: USERNAME),
          //       professionalId: 1,
          //     ));
          // Get.to(UserMainScreen());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: !loading
            ? SizedBox(
                width: Get.width,
                height: Get.height,
                child: Column(
                  children: [
                    vertical(70),
                    Image.asset(
                      AppImages.logo_Icon,
                      height: Get.height * 0.1,
                    ),
                    vertical(20),
                    Image.asset(
                      AppImages.loveGif,
                      height: Get.height * 0.5,
                    ),
                    // boldtext(AppColors.black, 52, "Welcome"),
                    // lighttext(AppColors.black, 12, "You are Awesome!"),
                    const Spacer(),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buttonMain(0.65, "Getting Started", () {
                            Get.to(() => RegisterFaceLock(
                                  fcmToken: fcmuserToken,
                                ));
                          }),
                    isLoading
                        ? const SizedBox.shrink()
                        : socialLoginButton(
                            "Already havn't an account ?", "Sign up", () {
                            Get.to(() => const RegisterScreen());
                          }),
                    vertical(25)
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
