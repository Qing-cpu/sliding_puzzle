import 'package:games_services/games_services.dart';

class GameAchievements {
  static void gameCompleted(int cl) {
    Achievements.unlock(
      achievement: Achievement(
        androidID: 'CgkI6bD4m_odEAIQAg',
        iOSID: 'game_completed',
        percentComplete: cl / 11 * 100,
      ),
    );
  }

  static void allLevels3Starred(int startCount) {
    Achievements.unlock(
      achievement: Achievement(
        androidID: 'CgkI6bD4m_odEAIQAw',
        iOSID: 'all_levels_3_starred',
        percentComplete: startCount / 33 * 100,
      ),
    );
  }

  static void speedLeaderboardAchievements(double score) {
    Achievements.unlock(
      achievement: Achievement(
        androidID: 'CgkI6bD4m_odEAIQBA',
        iOSID: 'score_10000',
        percentComplete: score / 100,
      ),
    );

    Achievements.unlock(
      achievement: Achievement(
        androidID: 'CgkI6bD4m_odEAIQBQ',
        iOSID: 'score_3w',
        percentComplete: score / 300,
      ),
    );

    Achievements.unlock(
      achievement: Achievement(
        androidID: 'CgkI6bD4m_odEAIQBg',
        iOSID: 'score_6w',
        percentComplete: score / 600,
      ),
    );

    Achievements.unlock(
      achievement: Achievement(
        androidID: 'CgkI6bD4m_odEAIQBw',
        iOSID: 'score_10w',
        percentComplete: score / 1000,
      ),
    );
  }

  static void skyLeaderboardAchievements(int l) {
    Achievements.unlock(
      achievement: Achievement(androidID: 'CgkI6bD4m_odEAIQCA', iOSID: 'sky10', percentComplete: l / 10 * 100),
    );

    Achievements.unlock(
      achievement: Achievement(androidID: 'CgkI6bD4m_odEAIQCQ', iOSID: 'sky18', percentComplete: l / 18 * 100),
    );

    Achievements.unlock(
      achievement: Achievement(androidID: 'CgkI6bD4m_odEAIQCg', iOSID: 'sky27', percentComplete: l / 27 * 100),
    );
    Achievements.unlock(
      achievement: Achievement(androidID: 'CgkI6bD4m_odEAIQCw', iOSID: 'sky36', percentComplete: l / 36 * 100),
    );
  }
}
