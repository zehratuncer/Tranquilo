import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class StonePromptCard extends StatefulWidget {
  final int index;
  final String prompt;
  final String? initialAnswer;
  final ValueChanged<String> onAnswerChanged;
  final VoidCallback onDismissed;

  const StonePromptCard({
    super.key,
    required this.index,
    required this.prompt,
    this.initialAnswer,
    required this.onAnswerChanged,
    required this.onDismissed,
  });

  @override
  State<StonePromptCard> createState() => _StonePromptCardState();
}

class _StonePromptCardState extends State<StonePromptCard> {
  late final TextEditingController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('stone_${widget.index}_${widget.prompt}'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) {
        HapticFeedback.lightImpact();
        widget.onDismissed();
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.pink.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.air, color: AppColors.pink),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.pink.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.air, color: AppColors.pink),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isExpanded ? AppColors.pink : AppColors.darkRock,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.burgundy,
                  child: Text(
                    '${widget.index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.prompt,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.pink,
                  ),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                maxLines: 2,
                onChanged: widget.onAnswerChanged,
                style: const TextStyle(fontSize: 15, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Düşünceni veya cevabını buraya yaz...',
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
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Cevapladıktan sonra taşı yana kaydırarak uzaklaştır 👉',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
