import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/password_forget.dart';
import 'package:active_ecommerce_flutter/ui_elements/auth_ui.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordOtp extends StatefulWidget {
  PasswordOtp({Key key, this.verify_by = "email", this.email_or_code})
      : super(key: key);
  final String verify_by;
  final String email_or_code;

  @override
  _PasswordOtpState createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  //controllers
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool _resetPasswordSuccess = false;

  String headeText ="";

  FlipCardController cardController = FlipCardController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      headeText = AppLocalizations.of(context).password_otp_screen_enter_the_code_sent;
      setState((){});
    });
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressConfirm() async {

    var code = _codeController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).password_otp_screen_code_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).password_otp_screen_password_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .password_otp_screen_password_confirm_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .password_otp_screen_password_length_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .password_otp_screen_password_match_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var passwordConfirmResponse =
        await AuthRepository().getPasswordConfirmResponse(code, password);

    if (passwordConfirmResponse.result == false) {
      ToastComponent.showDialog(passwordConfirmResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordConfirmResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      headeText=AppLocalizations.of(context).password_otp_screen_password_changed;
      cardController.toggleCard();
      setState((){});
    }
  }

  onTapResend() async {
    var passwordResendCodeResponse = await AuthRepository()
        .getPasswordResendCodeResponse(widget.email_or_code, widget.verify_by);

    if (passwordResendCodeResponse.result == false) {
      ToastComponent.showDialog(passwordResendCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(passwordResendCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  gotoLoginScreen(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        headeText,
        WillPopScope(
          onWillPop: (){
            gotoLoginScreen();
           return Future.delayed(Duration.zero);
          },
            child: buildBody(context, _screen_width, _verify_by)));
  }

  Widget buildBody(
      BuildContext context, double _screen_width, String _verify_by) {
    return FlipCard(
      flipOnTouch: false,
      controller: cardController,
      //fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL,
      // default
      front: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: _screen_width * (3 / 4),
                  child: _verify_by == "email"
                      ? Text(
                          AppLocalizations.of(context)
                              .password_otp_screen_enter_verification_code_to_email,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: MyTheme.dark_grey, fontSize: 14))
                      : Text(
                          AppLocalizations.of(context)
                              .password_otp_screen_enter_verification_code_to_phone,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.dark_grey, fontSize: 14))),
            ),
            Container(
              width: _screen_width * (3 / 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .password_otp_screen_code_warning,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _codeController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "A X B 4 J H"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context).password_otp_screen_password,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "• • • • • • • •"),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .password_otp_screen_password_length_recommendation,
                          style: TextStyle(
                              color: MyTheme.textfield_grey,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .password_otp_screen_retype_password,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 36,
                      child: TextField(
                        controller: _passwordConfirmController,
                        autofocus: false,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "• • • • • • • •"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        //height: 50,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        child: Text(
                          AppLocalizations.of(context).common_confirm_ucfirst,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressConfirm();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: InkWell(
                onTap: () {
                  onTapResend();
                },
                child: Text(
                  AppLocalizations.of(context).password_otp_screen_resend_code,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      decoration: TextDecoration.underline,
                      fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
      back: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: _screen_width * (3 / 4),
                  child: Text(
                      LangText(context)
                          .local
                          .password_otp_screen_congratulations,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: _screen_width * (3 / 4),
                  child: Text(
                      LangText(context)
                          .local
                          .password_otp_screen_password_change_msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 13,
                      ))),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset(
                'assets/changed_password.png',
                width: DeviceInfo(context).width / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    AppLocalizations.of(context)
                        .password_otp_screen_back_to_Login,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    gotoLoginScreen();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
