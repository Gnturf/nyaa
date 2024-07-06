import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyaa/const.dart';
import 'package:nyaa/services/alert_service.dart';
import 'package:nyaa/services/auth_service.dart';
import 'package:nyaa/services/navigation_service.dart';
import 'package:nyaa/widgets/custom_form_field.dart';
import 'package:nyaa/widgets/icon_text_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
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
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            _headerText(),
            const Spacer(),
            _loginForm(),
            const Spacer(),
            _createAccountLink(),
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
            "Welcome Back Nyaa!",
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.roboto(
                fontWeight: FontWeight.w800,
              ).fontFamily,
            ),
          ),
          Text(
            "Hello again, glad to see you!",
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

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomFormField(
            hintText: "Email",
            validationRegExp: EMAIL_VALIDATION_REGEX,
            onSaved: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          CustomFormField(
            hintText: "Password",
            validationRegExp: PASSWORD_VALIDATION_REGEX,
            obscureText: true,
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          const SizedBox(
            height: 40,
          ),
          IconTextButton(
            label: "Continue With Google",
            icon: Icons.accessible_rounded,
            onPressed: () async {
              if (_loginFormKey.currentState?.validate() ?? false) {
                _loginFormKey.currentState!.save();
                bool result = await _authService.login(email!, password!);

                print("-------------------- $result --------------------");

                if (result) {
                  _navigationService.pushReplacementNamed("/home");
                } else {
                  _alertService.showToast(
                    text: "Login Failed, Please Try Again",
                    icon: Icons.error,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _createAccountLink() {
    return Text.rich(
      TextSpan(
        text: "Don't have an account yet? ",
        children: [
          TextSpan(
            text: "Sign Up",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _navigationService.pushNamed("/register");
              },
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
