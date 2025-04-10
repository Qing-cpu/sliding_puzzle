import 'package:games_services/games_services.dart';

class GameAchievements {
  static void gameCompleted(int cl) {
    Achievements.unlock(
      achievement: Achievement(
        androidID: 'game_completed',
        iOSID: 'game_completed',
        percentComplete: cl / 11 * 100,
      ),
    );
  }

  static void allLevels3Starred(int startCount) {
    Achievements.unlock(
      achievement: Achievement(
        androidID: 'all_levels_3_starred',
        iOSID: 'all_levels_3_starred',
        percentComplete: startCount / 33 * 100,
      ),
    );
  }

  static void speedLeaderboardAchievements(double score) {
    Achievements.unlock(
      achievement: Achievement(
        androidID: 'score_10000',
        iOSID: 'score_10000',
        percentComplete: score / 100,
      ),
    );

    Achievements.unlock(
      achievement: Achievement(
        androidID: 'score_3w',
        iOSID: 'score_3w',
        percentComplete: score / 300,
      ),
    );

    Achievements.unlock(
      achievement: Achievement(
        androidID: 'score_6w',
        iOSID: 'score_6w',
        percentComplete: score / 600,
      ),
    );

    Achievements.unlock(
      achievement: Achievement(
        androidID: 'score_10w',
        iOSID: 'score_10w',
        percentComplete: score / 1000,
      ),
    );
  }

  static void skyLeaderboardAchievements(int l) {
    Achievements.unlock(
      achievement: Achievement(androidID: 'sky10', iOSID: 'sky10', percentComplete: l / 10),
    );

    Achievements.unlock(
      achievement: Achievement(androidID: 'sky18', iOSID: 'sky18', percentComplete: l / 18),
    );

    Achievements.unlock(
      achievement: Achievement(androidID: 'sky27', iOSID: 'sky27', percentComplete: l / 27),
    );
    Achievements.unlock(
      achievement: Achievement(androidID: 'sky36', iOSID: 'sky36', percentComplete: l / 36),
    );
  }
}
