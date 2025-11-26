import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController urlController = TextEditingController();
  bool isLoading = false;
  String? lyrics;
  List<dynamic>? aligned;

  Future<void> generateKaraoke() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.generateKaraoke(
        urlController.text.trim(),
      );

      setState(() {
        lyrics = result["lyrics"];
        aligned = result["aligned"];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Karaoke Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "URL do YouTube",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : generateKaraoke,
              child: const Text("Gerar Karaoke"),
            ),
            const SizedBox(height: 32),
            if (isLoading) const CircularProgressIndicator(),
            if (lyrics != null) ...[
              Text(
                "Letra completa:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(lyrics!),
              const Divider(),
              const Text(
                "Segmentos:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: aligned?.length ?? 0,
                  itemBuilder: (c, i) {
                    final item = aligned![i];
                    return ListTile(
                      title: Text(item["text"]),
                      subtitle: Text("Time: ${item["time"]}"),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
