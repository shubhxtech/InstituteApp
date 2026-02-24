import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';

import '../../../../widgets/form_field_widget.dart';
import '../../../../widgets/screen_width_button.dart';
import '../../../../widgets/glass_container.dart';
import '../bloc/user_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  String? errorEmailValue;
  final GlobalKey<FormState> emailKey = GlobalKey();

  String? errorPasswordValue;
  final GlobalKey<FormState> passwordKey = GlobalKey();

  bool _isEmailValid = false;

  bool userLoading = false;
  UserEntity? currentUser;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12), // slide up from 12% below centre
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserLoading) {
          setState(() => userLoading = true);
        } else if (state is UserLoaded) {
          setState(() => userLoading = false);
          GoRouter.of(context).goNamed(
            UhlLinkRoutesNames.home,
            extra: {'isGuest': false, 'user': state.user},
          );
        } else if (state is UserError) {
          setState(() => userLoading = false);
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).colorScheme.onSurface,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Log In",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        // Allow scroll when keyboard pushes content up
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: GlassContainer(
                  opacity: 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      // ── Email field ──────────────────────────────────────
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          if (state is GetUserByEmailLoaded) {
                            setState(() {
                              if (state.user != null) {
                                _isEmailValid = true;
                                currentUser = state.user;
                              } else {
                                _isEmailValid = false;
                                currentUser = null;
                              }
                            });
                          } else if (state is GetUserByEmailError) {
                            Fluttertoast.showToast(
                              msg: "Error in loading your email and password.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Theme.of(context).cardColor,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                            );
                          }
                        },
                        child: FormFieldWidget(
                          focusNode: emailFocusNode,
                          fieldKey: emailKey,
                          controller: emailTextEditingController,
                          obscureText: false,
                          validator: (value) {
                            final bool emailPatternValid = RegExp(
                                    r"^(?:[a-zA-Z0-9_]+@iitmandi\.ac\.in|[a-zA-Z0-9_]+@students\.iitmandi\.ac\.in)$")
                                .hasMatch(value!);
                            if (!emailPatternValid) {
                              return "Please enter a valid IIT Mandi email address.";
                            } else if (!_isEmailValid) {
                              return "This email is not registered. Please sign up first.";
                            }
                            return null;
                          },
                          onChanged: (String? value) async {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(GetUserByEmailEvent(email: value ?? ""));
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          errorText: errorEmailValue,
                          prefixIcon: Icons.mail_rounded,
                          showSuffixIcon: false,
                          hintText: "Email",
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      // ── Password field ──────────────────────────────────
                      FormFieldWidget(
                        focusNode: passwordFocusNode,
                        maxLines: 1,
                        fieldKey: passwordKey,
                        controller: passwordTextEditingController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        errorText: errorPasswordValue,
                        prefixIcon: Icons.lock_outline_rounded,
                        showSuffixIcon: true,
                        hintText: "Password",
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      // ── Sign-in button ──────────────────────────────────
                      ScreenWidthButton(
                        text: "Sign in",
                        buttonFunc: () {
                          final bool isValidEmail =
                              emailKey.currentState!.validate();
                          final bool isValidPassword =
                              passwordKey.currentState!.validate();

                          if (isValidEmail && isValidPassword) {
                            BlocProvider.of<AuthenticationBloc>(context).add(
                              SignInEvent(
                                email: emailTextEditingController.text,
                                password: passwordTextEditingController.text,
                              ),
                            );
                          }
                        },
                        isLoading: userLoading,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
