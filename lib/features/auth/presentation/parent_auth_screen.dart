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

class ParentAuthScreen extends ConsumerStatefulWidget {
  const ParentAuthScreen({super.key});

  @override
  ConsumerState<ParentAuthScreen> createState() => _ParentAuthScreenState();
}

class _ParentAuthScreenState extends ConsumerState<ParentAuthScreen> {
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
    final student = await repo.loginParent(
      _selectedTeacher!.id,
      _codeController.text.trim().toUpperCase(), // Code is upper-cased (e.g. C101)
    );

    setState(() {
      _isLoading = false;
    });

    if (student != null) {
      ref.read(currentStudentProvider.notifier).login(student);
      if (mounted) {
        context.go('/parent');
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
        title: Text(tr.translate('parent')),
      ),
      body: Stack(
        children: [
          // Islamic pattern background
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
                    // Icon block
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
                          Icons.family_restroom_rounded,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ).animate().scale(duration: 400.ms, curve: AppMotion.standard).fadeIn(duration: 350.ms),
                    const SizedBox(height: 24),
                    Text(
                      'تسجيل دخول ولي الأمر',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                    ).animate().fadeIn(delay: 100.ms, duration: 350.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 32),

                    // Teacher Circle Selector
                    teachersAsync.when(
                      data: (teachers) {
                        if (teachers.isEmpty) {
                          return Center(
                            child: Text(
                              'لا توجد حلقات نشطة حالياً',
                              style: GoogleFonts.cairo(color: Colors.red),
                            ),
                          );
                        }

                        return DropdownButtonFormField<Teacher>(
                          value: _selectedTeacher,
                          decoration: InputDecoration(
                            labelText: tr.translate('select_teacher'),
                            prefixIcon: const Icon(Icons.class_outlined),
                          ),
                          hint: Text(tr.translate('select_teacher')),
                          items: teachers.map((teacher) {
                            return DropdownMenuItem<Teacher>(
                              value: teacher,
                              child: Text(
                                'حلقة ${teacher.fullName}',
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
                          validator: (val) => val == null ? 'يرجى اختيار الحلقة' : null,
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('خطأ في تحميل الحلقات: $err')),
                    ).animate().fadeIn(delay: 180.ms, duration: 350.ms).slideY(begin: 0.08, end: 0),
                    const SizedBox(height: 20),

                    // Student Code Field
                    if (_selectedTeacher != null) ...[
                      TextFormField(
                        controller: _codeController,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: tr.translate('enter_student_code'),
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
                          helperText: 'مثال: C101',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'يرجى إدخال رمز الطالب';
                          }
                          return null;
                        },
                      ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.05, end: 0),
                      const SizedBox(height: 24),
                    ],

                    // Error text
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

                    // Submit button
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
