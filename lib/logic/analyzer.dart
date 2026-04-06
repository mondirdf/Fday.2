class AnalysisResult {
  AnalysisResult({required this.level, required this.insight});

  final String level;
  final String insight;
}

class Analyzer {
  static AnalysisResult fromStudyHours(double hours) {
    if (hours <= 2) {
      return AnalysisResult(
        level: 'Bad',
        insight: 'Low study output today. Add one focused block to recover momentum.',
      );
    }

    if (hours <= 5) {
      return AnalysisResult(
        level: 'Medium',
        insight: 'Steady progress. One extra deep session can make this a strong day.',
      );
    }

    return AnalysisResult(
      level: 'Good',
      insight: 'Great focus today. Keep this consistency and protect your energy.',
    );
  }
}
