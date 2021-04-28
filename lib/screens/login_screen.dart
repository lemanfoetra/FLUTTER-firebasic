import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasic/screens/home_screen.dart';
import 'package:flutter/material.dart';

enum VerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var currentFormState = VerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
  String titleAppBar = "Login";

  /// Kirim kode OTP
  Future<void> kirimOtp() async {
    setState(() {
      showLoading = true;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          titleAppBar = "Verifikasi Kode OTP";
          currentFormState = VerificationState.SHOW_OTP_FORM_STATE;
          this.verificationId = verificationId;
          showLoading = false;
        });
      },
      verificationCompleted: (credential) {
        setState(() {
          showLoading = false;
        });
      },
      verificationFailed: (exception) async {
        setState(() {
          showLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception.message),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          showLoading = false;
        });
        print("codeAutoRetrievalTimeout");
      },
    );
  }

  /// Verfiikasi kode OTP
  Future<void> loginWithPhone(BuildContext context) async {
    setState(() {
      showLoading = true;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        smsCode: otpController.text,
        verificationId: this.verificationId,
      );
      final signCredential = await _auth.signInWithCredential(credential);
      if (signCredential?.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
      ),
      body: Center(
        child: showLoading
            ? CircularProgressIndicator()
            : currentFormState == VerificationState.SHOW_MOBILE_FORM_STATE
                ? mobileFormWidget(context)
                : otpFormWidget(context),
      ),
    );
  }

  Widget mobileFormWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Masukan Nomor Telp."),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Proses'),
            onPressed: () {
              kirimOtp();
            },
          ),
        ],
      ),
    );
  }

  Widget otpFormWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: otpController,
            decoration: InputDecoration(hintText: "Masukan Kode OTP"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Verifikasi'),
            onPressed: () {
              loginWithPhone(context);
            },
          )
        ],
      ),
    );
  }
}
