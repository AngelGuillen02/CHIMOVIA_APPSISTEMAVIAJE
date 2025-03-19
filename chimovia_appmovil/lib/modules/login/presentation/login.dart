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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;


    void _login(String email, String passwword){
      BlocProvider.of<LoginBlocBloc>(context).add(ClickEnBotonDeIniciarSesion(email: email, password: passwword));
      setState(() {});
    }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBlocBloc, LoginBlocState>(
      listener: (context, state) {
        if(state is LoginBlocLoading){
          setState(() {
            _isLoading = true;
          });
        }
        if(state is LoginBlocSuccess){
          context.go('/menu');
        }
        if(state is LoginBlocFailure){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.car_repair_outlined,
                            size: 80,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildEmailField(),
                      SizedBox(height: 20),
                      _buildPasswordField(),
                      SizedBox(height: 30),
                      _buildLoginButton(),
                      SizedBox(height: 30),
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

   Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _emailController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: "Correo electrónico",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese un correo electrónico';
          }
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
        onPressed: _isLoading ? null : () => _login(_emailController.text, _passwordController.text),
        child:
            _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
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

  PasswordField({required this.controller});

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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: "Contraseña",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
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
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese una contraseña';
          }
          return null; 
        },
      ),
    );
  }
}

