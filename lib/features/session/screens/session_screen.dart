import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/fallback_prompts.dart';
import '../../../core/services/service_providers.dart';
import '../models/session_model.dart';
import '../widgets/interactive_rock_widget.dart';
import '../widgets/stone_prompt_card.dart';
import '../../safety/services/crisis_filter_service.dart';
import '../../safety/screens/crisis_support_screen.dart';

enum SessionStep {
  welcome,
  inputWorry,
  rockBreaking,
  stonePrompts,
  summary,
}

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  SessionStep _currentStep = SessionStep.welcome;
  final TextEditingController _worryController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();

  List<String> _prompts = [];
  final Map<String, String> _answers = {};
  final Set<int> _dismissedStones = {};
  String _reliefMessage = FallbackPrompts.defaultReliefMessage;
  bool _isLoadingAi = false;
  bool _showCrisisSupport = false;

  @override
  void dispose() {
    _worryController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  Future<void> _onStartRockBreaking() async {
    final text = _worryController.text.trim();
    if (text.isEmpty) return;

    // Güvenlik & Kriz Denetimi: Kendine zarar / acil risk içeriyor mu?
    if (CrisisFilterService.containsCrisisRisk(text)) {
      setState(() => _showCrisisSupport = true);
      return;
    }

    setState(() {
      _currentStep = SessionStep.rockBreaking;
      _isLoadingAi = true;
    });

    // AI sorularını arka planda çek
    final supabase = ref.read(supabaseServiceProvider);
    final questions = await supabase.generateQuestionsForWorry(text);

    if (mounted) {
      setState(() {
        _prompts = questions;
        _isLoadingAi = false;
      });
    }
  }

  void _onRockBroken() {
    setState(() {
      _currentStep = SessionStep.stonePrompts;
    });
  }

  Future<void> _onCompleteSession() async {
    setState(() => _isLoadingAi = true);

    final supabase = ref.read(supabaseServiceProvider);
    final smallAction = _actionController.text.trim().isNotEmpty
        ? _actionController.text.trim()
        : 'Derin bir nefes alıp ana dönmek.';

    final msg = await supabase.generateReliefMessage(
      worryText: _worryController.text.trim(),
      smallAction: smallAction,
      answers: _answers,
    );

    // Seansı Repository aracılığıyla kaydet
    final repository = ref.read(sessionRepositoryProvider);
    final session = SessionModel(
      id: const Uuid().v4(),
      userId: supabase.currentUserId,
      worryText: _worryController.text.trim(),
      prompts: _prompts,
      answers: _answers,
      smallAction: smallAction,
      aiReliefMessage: msg,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    await repository.saveSession(session);

    if (mounted) {
      setState(() {
        _reliefMessage = msg;
        _isLoadingAi = false;
        _currentStep = SessionStep.summary;
      });
    }
  }

  void _resetSession() {
    setState(() {
      _currentStep = SessionStep.welcome;
      _worryController.clear();
      _actionController.clear();
      _prompts.clear();
      _answers.clear();
      _dismissedStones.clear();
      _showCrisisSupport = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showCrisisSupport) {
      return CrisisSupportScreen(
        onDismiss: () {
          setState(() {
            _showCrisisSupport = false;
            _currentStep = SessionStep.inputWorry;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: _currentStep == SessionStep.summary
          ? AppColors.lightBackground
          : AppColors.darkBackground,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildCurrentStepWidget(),
        ),
      ),
    );
  }

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case SessionStep.welcome:
        return _buildWelcomeStep();
      case SessionStep.inputWorry:
        return _buildInputWorryStep();
      case SessionStep.rockBreaking:
        return _buildRockBreakingStep();
      case SessionStep.stonePrompts:
        return _buildStonePromptsStep();
      case SessionStep.summary:
        return _buildSummaryStep();
    }
  }

  // 1. Karşılama Ekranı (Etik disclaimer ekli)
  Widget _buildWelcomeStep() {
    return Center(
      key: const ValueKey('welcome_step'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.burgundy.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.pink, width: 1.5),
              ),
              child: const Icon(Icons.spa_outlined, color: AppColors.pink, size: 40),
            ),
            const SizedBox(height: 28),
            Text(
              'Tranquilo',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.pink,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Kaygını devasa bir yük olarak taşıma.\nOnu küçük ve yönetilebilir parçalara ayır.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkTextSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.darkBackground,
                padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () {
                setState(() => _currentStep = SessionStep.inputWorry);
              },
              child: const Text(
                'Başla',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Bu uygulama tıbbi tedavi veya terapi yerine geçmez;\ndüşünce düzenleme ve rahatlama aracıdır.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkTextSecondary.withValues(alpha: 0.5),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Düşünce Giriş Ekranı
  Widget _buildInputWorryStep() {
    return Padding(
      key: const ValueKey('input_worry_step'),
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.pink),
            onPressed: () => setState(() => _currentStep = SessionStep.welcome),
          ),
          const Spacer(),
          const Text(
            'Aklını meşgul eden\ndüşünceyi yaz.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _worryController,
            maxLines: 4,
            autofocus: true,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Örn: Yarınki sunum berbat geçecek...',
              hintStyle: TextStyle(
                color: AppColors.darkTextSecondary.withValues(alpha: 0.5),
              ),
              filled: true,
              fillColor: AppColors.darkSurface,
              contentPadding: const EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.darkBackground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _onStartRockBreaking,
              child: const Text(
                'Kayaya Dönüştür',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // 3. Kaya Kırma Ekranı
  Widget _buildRockBreakingStep() {
    return Center(
      key: const ValueKey('rock_breaking_step'),
      child: InteractiveRockWidget(
        worryText: _worryController.text.trim(),
        onRockBroken: _onRockBroken,
      ),
    );
  }

  // 4. Taş Soruları ve Mikro Adım Ekranı
  Widget _buildStonePromptsStep() {
    final activePrompts = _prompts.isEmpty ? FallbackPrompts.defaultQuestions : _prompts;
    final allStonesDismissed = _dismissedStones.length >= activePrompts.length;

    return Padding(
      key: const ValueKey('stone_prompts_step'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Düşünce Süzgeci',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Her taşı cevapla ve ekrandan dışarı sürükle.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkTextSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_dismissedStones.length}/${activePrompts.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pink,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.darkRock),
          Expanded(
            child: ListView.builder(
              itemCount: activePrompts.length,
              itemBuilder: (context, index) {
                if (_dismissedStones.contains(index)) {
                  return const SizedBox.shrink();
                }
                return StonePromptCard(
                  index: index,
                  prompt: activePrompts[index],
                  initialAnswer: _answers[activePrompts[index]],
                  onAnswerChanged: (val) {
                    _answers[activePrompts[index]] = val;
                  },
                  onDismissed: () {
                    setState(() {
                      _dismissedStones.add(index);
                    });
                  },
                );
              },
            ),
          ),
          if (allStonesDismissed) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.pink, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    FallbackPrompts.finalActionQuestion,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _actionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Örn: Giriş slaydını son bir kez okumak...',
                      hintStyle: TextStyle(
                        color: AppColors.darkTextSecondary.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: AppColors.darkBackground,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pink,
                        foregroundColor: AppColors.darkBackground,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _isLoadingAi ? null : _onCompleteSession,
                      child: _isLoadingAi
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Seansı Tamamla',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 5. Huzurlu Alan & Seans Özeti Ekranı
  Widget _buildSummaryStep() {
    return Center(
      key: const ValueKey('summary_step'),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.burgundy.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.burgundy,
                size: 38,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _reliefMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'ŞİMDİKİ KÜÇÜK ADIMIN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.burgundy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _actionController.text.trim().isNotEmpty
                        ? _actionController.text.trim()
                        : 'Derin bir nefes alıp ana dönmek.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.burgundy,
                side: const BorderSide(color: AppColors.burgundy),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: _resetSession,
              child: const Text('Yeni Bir Düşünceyi İncele'),
            ),
          ],
        ),
      ),
    );
  }
}
