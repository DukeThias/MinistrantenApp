import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:provider/provider.dart';

class PasswortAendernSeite extends StatefulWidget {
  @override
  _PasswortAendernSeiteState createState() => _PasswortAendernSeiteState();
}

class _PasswortAendernSeiteState extends State<PasswortAendernSeite> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscured1 = true;
  bool _isObscured2 = true;
  bool _isObscured3 = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Handle password change logic here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwort erfolgreich geändert!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();
    return Scaffold(
      appBar: AppBar(title: Text('Passwort ändern')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Aktuelles Passwort',
                      ),
                      obscureText: _isObscured1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte aktuelles Passwort eingeben';
                        }
                        if (globals.get("passwort") != value) {
                          return 'Aktuelles Passwort ist falsch';
                        }

                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isObscured1 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _isObscured1 = !_isObscured1;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(labelText: 'Neues Passwort'),
                      obscureText: _isObscured2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte neues Passwort eingeben';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isObscured1 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _isObscured2 = !_isObscured2;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Neues Passwort bestätigen',
                      ),
                      obscureText: _isObscured3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte neues Passwort bestätigen';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isObscured3 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _isObscured3 = !_isObscured3;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Passwort ändern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
