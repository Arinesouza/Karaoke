class PronunciationResult {
  final double score;
  final String transcript;
  final String feedback;

  PronunciationResult({
    required this.score,
    required this.transcript,
    required this.feedback,
  });

  factory PronunciationResult.fromJson(Map<String, dynamic> json) {
    return PronunciationResult(
      score: (json["score"] ?? 0).toDouble(),
      transcript: json["transcript"] ?? "",
      feedback: json["feedback"] ?? "",
    );
  }
}
