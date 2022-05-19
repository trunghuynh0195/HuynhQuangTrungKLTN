import 'package:app_user_attendance/bloc/login_bloc.dart';
import 'package:app_user_attendance/screens/home.dart';
import 'package:app_user_attendance/widgets/elevated_button_widget.dart';
import 'package:app_user_attendance/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordNode = FocusNode();
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: KeyboardDismisser(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(),
                  _buildLogo(),
                  _textInput(context),
                  const SizedBox(
                    height: 40,
                  ),
                  _button(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SizedBox(
          height: 50,
        ),
        Text(
          'Event Attendance',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A98A2),
          ),
        ),
        Text(
          'easy attendance management',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 45),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/login.png'))),
    );
  }

  Widget _textInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //email
        SizedBox(
          height: 50,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: const Color(0xFF1A98A2),
                  ),
            ),
            child: TextFieldWidget(
              controller: _emailController,
              borderRadius: 30,
              hintText: 'example@gmail.com',
              prefixIcon: const Icon(Icons.person),
              onSubmitted: (value) => _passwordNode.requestFocus(),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        //password
        SizedBox(
          height: 50,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: const Color(0xFF1A98A2),
                  ),
            ),
            child: TextFieldWidget(
              controller: _passwordController,
              focusNode: _passwordNode,
              obscureText: isShow,
              borderRadius: 30,
              prefixIcon: const Icon(Icons.lock),
              hintText: '*******',
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                  icon: Icon(isShow ? Icons.visibility : Icons.visibility_off)),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _button() {
    return ElevatedButtonWidget(
      onPressed: login,
      title: 'Login',
      backgroundColor: const Color(0xFF1A98A2),
      borderRadiusCircular: 30,
    );
  }

  showDialogLoading() {
    showDialog(
        context: context,
        builder: (_) {
          return Container(
            color: Colors.white.withOpacity(0.2),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        });
  }

  void login() async {
    try {
      showDialogLoading();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((value) {
        LoginBloC().getUser('${value.user?.uid}').then((user) {
          if (user.roles != 'USER') {
            _emailController.clear();
            _passwordController.clear();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tài khoản không tồn tại!')));
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Home(user: user)),
                (route) => false);
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      print(e);
    }
  }
}
