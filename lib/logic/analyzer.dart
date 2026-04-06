class AnalysisResult {
  AnalysisResult({required this.level, required this.insight});

  final String level;
  final String insight;
}

class Analyzer {
  static AnalysisResult fromStudyHours(double hours) {
    if (hours <= 2) {
      return AnalysisResult(
        level: 'bad',
        insight: 'Very light study day. Try at least one focused session tomorrow.',
      );
    }

    if (hours <= 5) {
      return AnalysisResult(
        level: 'medium',
        insight: 'Balanced effort. One extra deep-work block can push this higher.',
      );
    }

    return AnalysisResult(
      level: 'good',
      insight: 'Excellent focus today. Keep consistency and avoid burnout.',
    );
  }
}
