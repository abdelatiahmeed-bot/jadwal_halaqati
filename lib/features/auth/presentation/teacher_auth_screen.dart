import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:athar/core/localization/app_localizations.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/theme/motion.dart';
import 'package:athar/features/auth/presentation/auth_providers.dart';
import 'package:athar/core/models/models.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';

class TeacherAuthScreen extends ConsumerStatefulWidget {
  const TeacherAuthScreen({super.key});

  @override
  ConsumerState<TeacherAuthScreen> createState() => _TeacherAuthScreenState();
}

class _TeacherAuthScreenState extends ConsumerState<TeacherAuthScreen> {
  Teacher? _selectedTeacher;
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate() || _selectedTeacher == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repo = ref.read(authRepositoryProvider);
    final teacher = await repo.loginTeacher(
      _selectedTeacher!.id,
      _codeController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (teacher != null) {
      ref.read(currentTeacherProvider.notifier).login(teacher);
      if (mounted) {
        context.go('/teacher');
      }
    } else {
      setState(() {
        _errorMessage = ref.read(translationsProvider).translate('invalid_credentials');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(translationsProvider);
    final teachersAsync = ref.watch(activeTeachersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('teacher')),
      ),
      body: Stack(
        children: [
          // Islamic pattern in background
          const Positioned.fill(
            child: IslamicPatternBackground(),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Visual Header Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: IslamicTheme.goldMetallic, width: 1.5),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ).animate().scale(duration: 400.ms, curve: AppMotion.standard).fadeIn(duration: 350.ms),
                    const SizedBox(height: 24),
                    Text(
                      tr.translate('select_teacher'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                    ).animate().fadeIn(delay: 100.ms, duration: 350.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 32),

                    // Teacher Dropdown list
                    teachersAsync.when(
                      data: (teachers) {
                        if (teachers.isEmpty) {
                          return Center(
                            child: Text(
                              'لا يوجد معلمون نشطون حالياً',
                              style: GoogleFonts.cairo(color: Colors.red),
                            ),
                          );
                        }

                        return DropdownButtonFormField<Teacher>(
                          value: _selectedTeacher,
                          decoration: InputDecoration(
                            labelText: tr.translate('select_teacher'),
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                          ),
                          hint: Text(tr.translate('select_teacher')),
                          items: teachers.map((teacher) {
                            return DropdownMenuItem<Teacher>(
                              value: teacher,
                              child: Text(
                                teacher.fullName,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedTeacher = val;
                            });
                          },
                          validator: (val) => val == null ? 'يرجى اختيار معلم' : null,
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('خطأ في تحميل المعلمين: $err')),
                    ).animate().fadeIn(delay: 180.ms, duration: 350.ms).slideY(begin: 0.08, end: 0),
                    const SizedBox(height: 20),

                    // Code input fields
                    if (_selectedTeacher != null) ...[
                      TextFormField(
                        controller: _codeController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: tr.translate('enter_teacher_code'),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'يرجى إدخال الرمز السري';
                          }
                          return null;
                        },
                      ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.05, end: 0),
                      const SizedBox(height: 24),
                    ],

                    // Error Message
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 200.ms).shake(duration: 350.ms),
                      const SizedBox(height: 16),
                    ],

                    // Login button
                    if (_selectedTeacher != null)
                      AppPressable(
                        onTap: _isLoading ? null : _handleLogin,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(tr.translate('login_button')),
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
