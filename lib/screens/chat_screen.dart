import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final currentLanguage = chat.selectedLanguage;

    return Scaffold(
      backgroundColor: Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A2A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.grey[300],
            size: 24,
          ),
          onPressed: () {
            chat.clearChat();
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentLanguage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              "AI Language Practice",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFF0F0F1A),
              child: ListView.builder(
                reverse: false,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: chat.messages.length,
                itemBuilder: (context, index) {
                  final msg = chat.messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg.isUser)
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xFF7C4DFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        Expanded(
                          child: Align(
                            alignment: msg.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: msg.isUser
                                    ? Color(0xFF7C4DFF)
                                    : Color(0xFF1A1A2A),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: msg.isUser
                                      ? Colors.transparent
                                      : Colors.grey[800]!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: msg.isUser ? Colors.white : Colors.grey[100],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (msg.isUser)
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xFF1A1A2A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.grey[400],
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          if (chat.isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFF7C4DFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1A2A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[800]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF7C4DFF),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "AI is thinking...",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A2A),
              border: Border(
                top: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF0F0F1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type your message here...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFF7C4DFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;

                      String msg = controller.text;
                      chat.addUserMessage(msg);
                      chat.sendMessageToGemini(msg);

                      controller.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}