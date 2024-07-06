import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyaa/const.dart';
import 'package:nyaa/models/user_profile.dart';
import 'package:nyaa/services/alert_service.dart';
import 'package:nyaa/services/auth_service.dart';
import 'package:nyaa/services/database_service.dart';
import 'package:nyaa/services/media_service.dart';
import 'package:nyaa/services/navigation_service.dart';
import 'package:nyaa/services/storage_service.dart';
import 'package:nyaa/widgets/custom_form_field.dart';
import 'package:nyaa/widgets/icon_text_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  File? selectedImage;
  String? email, password, name;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: Column(
          children: [
            _headerText(),
            const Spacer(),
            _registerForm(),
            const Spacer(),
            _loginAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.roboto(
                fontWeight: FontWeight.w800,
              ).fontFamily,
            ),
          ),
          Text(
            "Create your account using form below!",
            style: TextStyle(
              fontSize: 15,
              fontFamily: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ).fontFamily,
              color: Colors.black.withOpacity(0.6),
            ),
          )
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pfpSelectionField(),
          const SizedBox(height: 40),
          CustomFormField(
            hintText: "Name",
            validationRegExp: NAME_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          const SizedBox(height: 10),
          CustomFormField(
            hintText: "Email",
            validationRegExp: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          const SizedBox(height: 10),
          CustomFormField(
            hintText: "Password",
            validationRegExp: PASSWORD_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          const SizedBox(height: 40),
          IconTextButton(
            label: "Register",
            isLoading: isLoading,
            onPressed: isLoading
                ? () {}
                : () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      if ((_registerFormKey.currentState?.validate() ??
                              false) &&
                          selectedImage != null) {
                        _registerFormKey.currentState!.save();

                        final result =
                            await _authService.signup(email!, password!);

                        if (result) {
                          String? pfpURL = await _storageService.uploadUserPfp(
                            file: selectedImage!,
                            uid: _authService.user!.uid,
                          );

                          if (pfpURL != null) {
                            print("---------- PFP UPLOAD SUCCESS ---------");
                            await _databaseService.createUserProfile(
                              userProfile: UserProfile(
                                uid: _authService.user!.uid,
                                name: name,
                                pfpURL: pfpURL,
                              ),
                            );

                            _alertService.showToast(
                              text: "Register Success",
                              icon: Icons.check_circle,
                            );

                            _navigationService.goBack();
                            _navigationService.pushReplacementNamed("/home");
                          } else {
                            throw Exception("Please Pick The Profile Picture");
                          }
                        } else {
                          throw Exception("Unable To Register The User");
                        }
                      }
                    } catch (e) {
                      _alertService.showToast(
                        text: e.toString(),
                        icon: Icons.error,
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
          ),
        ],
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.10,
        backgroundImage: selectedImage == null
            ? Image.network(PLACEHOLDER_PFP).image
            : Image.file(selectedImage!).image,
      ),
    );
  }

  Widget _loginAccountLink() {
    return Text.rich(
      TextSpan(
        text: "Already have an account? ",
        children: [
          TextSpan(
            text: "Sign In",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigationService.goBack();
              },
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
