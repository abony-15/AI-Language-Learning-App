import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> languages = [
    "English",
    "Spanish",
    "Japanese",
    "French",
    "Chinese"
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Color(0xFF1A1A2A),
            child: Text(
              currentUser?.displayName?.isNotEmpty == true
                  ? currentUser!.displayName![0].toUpperCase()
                  : currentUser?.email?[0].toUpperCase() ?? "U",
              style: TextStyle(
                color: Color(0xFF7C4DFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello,",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            Text(
              currentUser?.displayName?.isNotEmpty == true
                  ? currentUser!.displayName!
                  : currentUser?.email?.split('@')[0] ?? "User",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.grey[400],
              size: 24,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Select Language",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose a language to start practicing",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        context.read<ChatProvider>().setLanguage(lang);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ChatScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A2A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[800]!,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Color(0xFF7C4DFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                _getLanguageFlag(lang),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF7C4DFF),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            lang,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "Start conversation practice",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF7C4DFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF7C4DFF),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Select a language to begin your AI-powered conversation practice",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getLanguageFlag(String language) {
    switch (language) {
      case "English":
        return "🇺🇸";
      case "Spanish":
        return "🇪🇸";
      case "Japanese":
        return "🇯🇵";
      case "French":
        return "🇫🇷";
      case "Chinese":
        return "🇨🇳";
      default:
        return "🌐";
    }
  }
}