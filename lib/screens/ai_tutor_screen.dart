import 'package:flutter/material.dart';
import '../services/ai_tutor_service.dart';

class AiTutorScreen extends StatefulWidget {
  final String chapterTitle;
  final String chapterText;
  final String level;
  final String space;

  const AiTutorScreen({
    super.key,
    required this.chapterTitle,
    required this.chapterText,
    required this.level,
    this.space = '',
  });

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<AiMessage> _messages = [];
  bool _loading = false;

  static const _indigo = Color(0xFF3F3D9E);

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _loading) return;

    final history = List<AiMessage>.from(_messages);
    setState(() {
      _messages.add(AiMessage(fromUser: true, text: question));
      _loading = true;
      _controller.clear();
    });
    _scrollToEnd();

    try {
      final answer = await AiTutorService.ask(
        question: question,
        chapterTitle: widget.chapterTitle,
        chapterText: widget.chapterText,
        level: widget.level,
        space: widget.space,
        history: history,
      );
      if (!mounted) return;
      setState(() => _messages.add(AiMessage(fromUser: false, text: answer)));
    } on AiTutorException catch (e) {
      if (!mounted) return;
      setState(() => _messages.add(AiMessage(fromUser: false, text: e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _bubble(AiMessage m) {
    return Align(
      alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: m.fromUser ? _indigo : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SelectableText(
          m.text,
          style: TextStyle(
            color: m.fromUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle, overflow: TextOverflow.ellipsis),
        backgroundColor: _indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        "Pose-moi une question sur ce chapitre.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _bubble(_messages[i]),
                  ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 1000,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: "Ta question...",
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _loading ? null : _send,
                    style: IconButton.styleFrom(backgroundColor: _indigo),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}