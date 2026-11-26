import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:athar/core/localization/app_localizations.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/theme/motion.dart';
import 'package:athar/core/widgets/islamic_pattern.dart';

class EntryScreen extends ConsumerWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E261A) : const Color(0xFFF7F8F5),
      body: Stack(
        children: [
          // Custom Painted Islamic Background Pattern
          const Positioned.fill(
            child: IslamicPatternBackground(),
          ),

          // Mosque Silhouette at the bottom (Light beige color)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 180,
            child: CustomPaint(
              painter: _MosqueSilhouettePainter(
                color: isDark 
                    ? const Color(0xFF252F21).withValues(alpha: 0.4) 
                    : const Color(0xFFE4ECD5).withValues(alpha: 0.6),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Language Switcher (Top corner floating style)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            ref.read(localeProvider.notifier).toggleLanguage();
                          },
                          icon: Icon(
                            Icons.language,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text(
                            ref.watch(localeProvider).languageCode == 'ar' ? 'English' : 'العربية',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Logo & App Name Header (Matching Screen 1)
                    Hero(
                      tag: 'app_logo',
                      child: Column(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: IslamicTheme.oliveDeep.withValues(alpha: 0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(color: IslamicTheme.goldMetallic, width: 2.5),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: IslamicTheme.goldMetallic.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.menu_book_rounded,
                                      color: IslamicTheme.goldMetallic,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'أثر',
                                      style: GoogleFonts.amiri(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: IslamicTheme.oliveLight,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tr.translate('app_title'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.arefRuqaa(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : IslamicTheme.oliveDeep,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'إدارة حلقات تحفيظ القرآن الكريم',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.arefRuqaa(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: IslamicTheme.goldMetallic,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, curve: AppMotion.standard).slideY(begin: 0.08, end: 0, duration: 400.ms, curve: AppMotion.standard),
                    const SizedBox(height: 48),

                    // 1. Parent Card Button (Large)
                    _RoleButton(
                      title: tr.translate('parent'),
                      icon: Icons.person_outline_rounded,
                      color: isDark ? const Color(0xFF252F21) : Colors.white,
                      textColor: isDark ? Colors.white : IslamicTheme.oliveDeep,
                      iconColor: IslamicTheme.goldMetallic,
                      border: Border.all(color: IslamicTheme.goldMetallic, width: 1.8),
                      onTap: () => context.push('/parent/auth'),
                    ).animate().fadeIn(delay: 100.ms, duration: 350.ms, curve: AppMotion.standard).slideY(begin: 0.1, end: 0, delay: 100.ms, duration: 350.ms, curve: AppMotion.standard),
                    const SizedBox(height: 16),

                    // 2. Teacher Card Button (Large)
                    _RoleButton(
                      title: tr.translate('teacher'),
                      icon: Icons.menu_book_rounded,
                      color: isDark ? const Color(0xFF252F21) : Colors.white,
                      textColor: isDark ? Colors.white : IslamicTheme.oliveDeep,
                      iconColor: IslamicTheme.goldMetallic,
                      border: Border.all(color: IslamicTheme.goldMetallic, width: 1.8),
                      onTap: () => context.push('/teacher/auth'),
                    ).animate().fadeIn(delay: 180.ms, duration: 350.ms, curve: AppMotion.standard).slideY(begin: 0.1, end: 0, delay: 180.ms, duration: 350.ms, curve: AppMotion.standard),
                    const SizedBox(height: 32),

                    // 3. Admin Card Button (Small gold/mint button centered)
                    Center(
                      child: SizedBox(
                        width: 165,
                        child: _RoleButton(
                          title: tr.translate('admin'),
                          icon: Icons.settings_outlined,
                          color: isDark ? const Color(0xFF1E261A) : const Color(0xFFE4ECD5),
                          textColor: IslamicTheme.oliveLight,
                          iconColor: IslamicTheme.oliveLight,
                          border: Border.all(color: IslamicTheme.goldMetallic.withValues(alpha: 0.5), width: 1.2),
                          height: 48,
                          fontSize: 14,
                          onTap: () => _showAdminPasswordDialog(context),
                        ),
                      ),
                    ).animate().fadeIn(delay: 260.ms, duration: 350.ms, curve: AppMotion.standard).slideY(begin: 0.1, end: 0, delay: 260.ms, duration: 350.ms, curve: AppMotion.standard),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdminPasswordDialog(BuildContext context) {
    final TextEditingController passwordCtrl = TextEditingController();
    final String correctPassword = '4568';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E261A) : const Color(0xFFF7F8F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: IslamicTheme.goldMetallic, width: 1.8),
          ),
          title: Text(
            'دخول الإدارة',
            textAlign: TextAlign.center,
            style: GoogleFonts.arefRuqaa(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : IslamicTheme.oliveDeep,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'يرجى إدخال رمز الدخول السري للإدارة',
                style: GoogleFonts.cairo(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'رمز المرور',
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: IslamicTheme.goldMetallic),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (passwordCtrl.text == correctPassword) {
                  Navigator.pop(ctx);
                  context.push('/admin');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('رمز المرور خاطئ!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'تأكيد',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;
  final double height;
  final double fontSize;
  final Border? border;

  const _RoleButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
    this.height = 60.0,
    this.fontSize = 16.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: fontSize + 4,
                color: iconColor,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.arefRuqaa(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter to draw Mosque silhouette at bottom
class _MosqueSilhouettePainter extends CustomPainter {
  final Color color;
  _MosqueSilhouettePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(w, h);
    path.lineTo(0, h);
    
    // Left minaret tower
    path.lineTo(0, h - 30);
    path.lineTo(w * 0.05, h - 30);
    path.lineTo(w * 0.05, h - 110);
    path.lineTo(w * 0.03, h - 110);
    path.lineTo(w * 0.03, h - 125);
    path.lineTo(w * 0.06, h - 145); // point
    path.lineTo(w * 0.09, h - 125);
    path.lineTo(w * 0.09, h - 110);
    path.lineTo(w * 0.07, h - 110);
    path.lineTo(w * 0.07, h - 30);
    
    path.lineTo(w * 0.16, h - 30);
    
    // Dome 1 (Left side)
    path.lineTo(w * 0.16, h - 38);
    path.quadraticBezierTo(w * 0.16, h - 65, w * 0.22, h - 65);
    path.lineTo(w * 0.22, h - 72); // point tip
    path.lineTo(w * 0.22, h - 65);
    path.quadraticBezierTo(w * 0.28, h - 65, w * 0.28, h - 38);
    path.lineTo(w * 0.28, h - 30);
    
    path.lineTo(w * 0.35, h - 30);
    
    // Left-Center minaret tower
    path.lineTo(w * 0.35, h - 130);
    path.lineTo(w * 0.33, h - 130);
    path.lineTo(w * 0.33, h - 145);
    path.lineTo(w * 0.36, h - 165); // point
    path.lineTo(w * 0.39, h - 145);
    path.lineTo(w * 0.39, h - 130);
    path.lineTo(w * 0.37, h - 130);
    path.lineTo(w * 0.37, h - 30);
    
    path.lineTo(w * 0.42, h - 30);

    // Large center dome
    path.lineTo(w * 0.42, h - 45);
    path.quadraticBezierTo(w * 0.42, h - 90, w * 0.50, h - 90);
    path.lineTo(w * 0.50, h - 102); // center tip
    path.lineTo(w * 0.50, h - 90);
    path.quadraticBezierTo(w * 0.58, h - 90, w * 0.58, h - 45);
    path.lineTo(w * 0.58, h - 30);
    
    path.lineTo(w * 0.63, h - 30);
    
    // Right-Center minaret tower
    path.lineTo(w * 0.63, h - 130);
    path.lineTo(w * 0.61, h - 130);
    path.lineTo(w * 0.61, h - 145);
    path.lineTo(w * 0.64, h - 165); // point
    path.lineTo(w * 0.67, h - 145);
    path.lineTo(w * 0.67, h - 130);
    path.lineTo(w * 0.65, h - 130);
    path.lineTo(w * 0.65, h - 30);
    
    path.lineTo(w * 0.72, h - 30);
    
    // Dome 2 (Right side)
    path.lineTo(w * 0.72, h - 38);
    path.quadraticBezierTo(w * 0.72, h - 65, w * 0.78, h - 65);
    path.lineTo(w * 0.78, h - 72); // point tip
    path.lineTo(w * 0.78, h - 65);
    path.quadraticBezierTo(w * 0.84, h - 65, w * 0.84, h - 38);
    path.lineTo(w * 0.84, h - 30);
    
    // Right minaret tower
    path.lineTo(w * 0.93, h - 30);
    path.lineTo(w * 0.93, h - 110);
    path.lineTo(w * 0.91, h - 110);
    path.lineTo(w * 0.91, h - 125);
    path.lineTo(w * 0.94, h - 145); // point
    path.lineTo(w * 0.97, h - 125);
    path.lineTo(w * 0.97, h - 110);
    path.lineTo(w * 0.95, h - 110);
    path.lineTo(w * 0.95, h - 30);
    path.lineTo(w, h - 30);
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
