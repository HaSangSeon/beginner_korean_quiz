/// Editorial learning order, independent of legacy level labels.
/// Keep IDs stable: progress, bookmarks and recorded audio depend on them.
class LearningOrder {
  // Simple objects, basic particles/time, then short everyday exchanges.
  static const beginnerQuestionIds = [
    601, 602, 603, 604, 605, 606, 607, 608, 609, 610,
    611, 612, 613, 614, 615, 616, 617, 618, 619, 620,
    623, 630, 622, 621, 624, 625, 626, 628, 629, 627,
    11, 12, 13, 15, 17, 18, 19, 20, 23, 25, 27,
    49, 50, 53, 57, 58, 59, 60, 61, 62, 63,
    29, 31, 34, 35, 37, 38, 40, 46, 47, 48,
    77, 78, 80, 83, 84, 85, 86, 87, 95, 96,
    133, 134, 135, 138, 139, 149, 150, 151, 152,
    97, 98, 99, 101, 104, 109, 110, 112, 125, 130,
  ];

  // Administrative, contractual and specialist vocabulary comes later.
  static const advancedQuestionIds = {
    124, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333,
    336, 338, 339, 350, 351, 374, 375, 378, 379, 382,
    530, 541, 542,
    565, 575, 576, 579, 580, 584, 597, 598, 599, 600,
  };

  static int questionPriority(int id) {
    final beginnerIndex = beginnerQuestionIds.indexOf(id);
    if (beginnerIndex >= 0) return beginnerIndex;
    return advancedQuestionIds.contains(id) ? 1001 : 1000;
  }

  // Greetings and short daily exchanges before specialist appointments.
  static const dialogueIds = [
    1, 2, 3, 4, 42, 47, 49, 46,
    7, 9, 11, 41, 43, 44, 45, 48, 51, 8, 6, 30,
    10, 12, 25, 37, 28, 50, 5, 13, 21, 24,
    16, 18, 19, 34, 35, 22, 32, 39, 38, 40,
    29, 26, 27, 31, 17, 15, 14, 23, 33, 36, 20,
  ];

  static int dialoguePriority(int id) {
    final index = dialogueIds.indexOf(id);
    return index < 0 ? dialogueIds.length : index;
  }
}
