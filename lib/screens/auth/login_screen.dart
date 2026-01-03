import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_provider.dart';
import '../../providers/player_provider.dart';
import '../../widgets/glassmorphic/glassmorphic_container.dart';
import '../../widgets/glassmorphic/glassmorphic_button.dart';
import '../../widgets/glassmorphic/glassmorphic_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  @override
  void dispose() {
    _serverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      _serverController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text,
    );
    
    if (!mounted) return;
    
    if (success) {
      // Initialize library and player providers with API
      final libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      
      libraryProvider.setApi(authProvider.api);
      playerProvider.setApi(authProvider.api);
      
      // Load library data
      await libraryProvider.loadLibrary();
      
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F1E),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and title
                    Icon(
                      Icons.music_note_rounded,
                      size: 80,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your Subsonic server',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 48),
                    
                    // Server URL field
                    GlassmorphicTextField(
                      hint: 'Server URL',
                      controller: _serverController,
                      prefixIcon: Icons.dns_rounded,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter server URL';
                        }
                        if (!value!.startsWith('http')) {
                          return 'URL must start with http:// or https://';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Username field
                    GlassmorphicTextField(
                      hint: 'Username',
                      controller: _usernameController,
                      prefixIcon: Icons.person_rounded,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Password field
                    GlassmorphicTextField(
                      hint: 'Password',
                      controller: _passwordController,
                      prefixIcon: Icons.lock_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword 
                              ? Icons.visibility_rounded 
                              : Icons.visibility_off_rounded,
                          color: Colors.white60,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Login button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return GlassmorphicButton(
                          text: 'Login',
                          onPressed: _login,
                          icon: Icons.login_rounded,
                          isLoading: authProvider.isLoading,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Info text
                    GlassmorphicContainer(
                      padding: const EdgeInsets.all(16),
                      opacity: 0.08,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Enter your Subsonic server details to continue',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
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
}
