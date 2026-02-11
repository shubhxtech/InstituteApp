import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/config/new_app_theme.dart';
import 'package:vertex/widgets/glass_container.dart';
import 'package:vertex/widgets/glass_button.dart';

class ChooseAuthPage extends StatefulWidget {
  const ChooseAuthPage({super.key});

  @override
  State<ChooseAuthPage> createState() => _ChooseAuthPageState();
}

class _ChooseAuthPageState extends State<ChooseAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Global Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: NewAppTheme.mainBgGradient,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: GlassContainer(
                opacity: 0.1,
                borderRadius: BorderRadius.circular(25),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Institute App',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your campus companion',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: 50),
                      GlassButton(
                        text: "Login",
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(UhlLinkRoutesNames.login);
                        },
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20),
                      GlassButton(
                        text: "Register",
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(UhlLinkRoutesNames.signup); // Changed to signup based on original logic
                        },
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20),
                      GlassButton(
                        text: "Continue as Guest",
                        onPressed: () {
                          GoRouter.of(context)
                              .goNamed(UhlLinkRoutesNames.home, extra: {'isGuest': true, 'user': null}); // Changed to home based on original logic
                        },
                        width: double.infinity,
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
