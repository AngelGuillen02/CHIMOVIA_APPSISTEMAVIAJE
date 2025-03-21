import 'package:chimovia_appmovil/modules/login/bloc/login_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login(String email, String password) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<LoginBlocBloc>(context).add(
        ClickEnBotonDeIniciarSesion(email: email.trim(), password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBlocBloc, LoginBlocState>(
      listener: (context, state) {
        if (state is LoginBlocLoading) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is LoginBlocSuccess) {
          context.go('/menu');
        }
        if (state is LoginBlocFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 14, 
                ),
              ),
              backgroundColor: Colors.red, 
              duration: Duration(seconds: 3), 
              behavior:
                  SnackBarBehavior
                      .floating, 
              margin: EdgeInsets.all(10), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF42A5F5)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.car_repair_outlined,
                              size: 80,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 30),
                        _buildLoginButton(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _emailController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: "Correo electrónico",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor ingrese un correo electrónico';
          }
          // if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
          //   return 'Por favor ingrese un correo electrónico válido';
          // }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return PasswordField(controller: _passwordController);
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
        ),
        onPressed:
            _isLoading
                ? null
                : () => _login(_emailController.text, _passwordController.text),
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  "INICIAR SESIÓN",
                  style: TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: "Contraseña",
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                key: ValueKey<bool>(_isObscure),
                color: Colors.white70,
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor ingrese una contraseña';
          }
          // if (value.length < 8) {
          //   return 'La contraseña debe tener al menos 8 caracteres';
          // }
          return null;
        },
      ),
    );
  }
}
