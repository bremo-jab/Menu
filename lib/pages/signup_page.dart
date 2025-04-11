import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  String _fullPhoneNumber = '';

  Future<void> _sendOTP() async {
    if (_fullPhoneNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يرجى إدخال رقم الهاتف')));
      return;
    }

    try {
      final phoneExists =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: _fullPhoneNumber)
              .get();

      if (phoneExists.docs.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('رقم الهاتف مستخدم مسبقاً')));
        return;
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: _fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فشل التحقق: ${e.message}')));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إرسال رمز التحقق عبر الرسائل')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
    }
  }

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _fullPhoneNumber.isEmpty ||
        otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) throw Exception('فشل إنشاء المستخدم');

      PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await user.linkWithCredential(phoneCredential);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'phone': _fullPhoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم إنشاء الحساب بنجاح')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'البريد الإلكتروني مستخدم مسبقًا.';
          break;
        case 'invalid-email':
          errorMessage = 'صيغة البريد الإلكتروني غير صحيحة.';
          break;
        case 'weak-password':
          errorMessage = 'كلمة المرور ضعيفة. يرجى اختيار كلمة مرور أقوى.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'عملية التسجيل غير مفعلة حالياً.';
          break;
        default:
          errorMessage = 'حدث خطأ: ${e.message}';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight =
        screenHeight -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6dd5ed), Color(0xFF2193b0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: availableHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: availableHeight * 0.06),
                    Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(
                        fontSize: availableHeight * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: availableHeight * 0.04),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'الاسم الكامل',
                      icon: Icons.person,
                    ),
                    SizedBox(height: availableHeight * 0.02),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'البريد الإلكتروني',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: availableHeight * 0.02),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: 'رقم الهاتف',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      initialCountryCode: 'SA',
                      onChanged: (phone) {
                        _fullPhoneNumber = phone.completeNumber;
                      },
                    ),
                    SizedBox(height: availableHeight * 0.015),
                    ElevatedButton(
                      onPressed: _sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: availableHeight * 0.015,
                        ),
                      ),
                      child: Text('إرسال رمز التحقق'),
                    ),
                    SizedBox(height: availableHeight * 0.02),
                    _buildTextField(
                      controller: _otpController,
                      hint: 'رمز التحقق (OTP)',
                      icon: Icons.security,
                    ),
                    SizedBox(height: availableHeight * 0.02),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'كلمة المرور',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: availableHeight * 0.04),
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: availableHeight * 0.018,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('إنشاء حساب', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: availableHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
