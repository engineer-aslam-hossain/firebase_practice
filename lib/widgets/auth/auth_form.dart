import 'dart:io';
import 'package:firebase_practice/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_practice/constant.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String username,
    String email,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  String? _username;
  String? _emailAddress;
  String? _password;
  File? _image;

  void _pickedImage(File pickImage) {
    setState(() {
      _image = pickImage;
    });
  }

  void _submitForm() {
    try {
      final isValid = _formKey.currentState?.validate();
      FocusScope.of(context).unfocus();

      if (_image == null && !isLogin) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'please pick an image',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }

      if (isValid!) {
        _formKey.currentState?.save();

        _formKey.currentState?.reset();

        if (isLogin) {
          widget.submitFn(
            _username != null ? _username!.trim() : '',
            _emailAddress!.trim(),
            _password!.trim(),
            File(''),
            isLogin,
            context,
          );
        } else {
          widget.submitFn(
            _username != null ? _username!.trim() : '',
            _emailAddress!.trim(),
            _password!.trim(),
            _image!,
            isLogin,
            context,
          );
        }
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLogin) UserImagePicker(_pickedImage),
                if (!isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    style: TextStyle(height: 0.8),
                    decoration: kInputDecoration.copyWith(
                      labelText: 'Username',
                      hintText: 'jhon Doe',
                    ),
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Please Enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  key: ValueKey('email'),
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: TextStyle(height: 0.8),
                  autofillHints: [AutofillHints.email],
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Email Address',
                    hintText: 'example@email.com',
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please Enter a valid Email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    _emailAddress = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  key: ValueKey('password'),
                  style: TextStyle(height: 0.8),
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Password',
                    hintText: '*****',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Please Enter your password.';
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(isLogin ? 'Login' : 'Sign Up'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(isLogin
                        ? 'Create New Account'
                        : 'Already have account? Login'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
