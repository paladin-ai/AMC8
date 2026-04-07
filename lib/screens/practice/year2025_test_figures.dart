/// 與各 `year2025_problem*_page.dart` 中插入的示意圖一致（用於自測頁複製版式）。
typedef Y2025FigureSlots = ({List<String> afterQuestion1, List<String> afterQuestion2});

Y2025FigureSlots y2025FigureUrlsForProblem(int problemNumber) {
  return switch (problemNumber) {
    1 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/5/6/6/56638188764158bdffa266bc933d11b6acd2fb76.png',
        ],
        afterQuestion2: <String>[],
      ),
    2 => (
        afterQuestion1: [
          'https://artofproblemsolving.com/wiki/images/d/de/Mathh.PNG',
        ],
        afterQuestion2: [
          'https://artofproblemsolving.com/wiki/images/3/38/Amc8_2025_prob_2_pic.PNG',
        ],
      ),
    5 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/0/2/f/02f4d70dd8e934b785c58b9e171db52b9bca463e.png',
        ],
        afterQuestion2: <String>[],
      ),
    8 => (
        afterQuestion1: [
          'https://artofproblemsolving.com/wiki/images/5/54/Amc8_2025_prob8.PNG',
        ],
        afterQuestion2: <String>[],
      ),
    9 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/a/d/e/ade0d0a5fb7d05e6a8166bee8fda14dbe1c68178.png',
        ],
        afterQuestion2: <String>[],
      ),
    10 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/e/b/f/ebf7ba081139b844707582b61cc44797cabe50bc.png',
        ],
        afterQuestion2: <String>[],
      ),
    11 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/f/2/1/f2172172ab6cb261dfc95f73ad4d68405a6f0ff5.png',
        ],
        afterQuestion2: <String>[],
      ),
    12 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/a/5/2/a52017dd3b0fc3a1b2e79871e510b0ca50e1e4db.png',
        ],
        afterQuestion2: <String>[],
      ),
    13 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/4/c/b/4cba093bf55b34f4838e00be60618cfcab45fd8f.png',
        ],
        afterQuestion2: <String>[],
      ),
    15 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/9/1/d/91d00727a04e32222f0e1b446a0f41cc4ef37b8f.png',
        ],
        afterQuestion2: <String>[],
      ),
    17 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/f/5/e/f5e7042d0e94883a88767c8f17211888ded7845b.png',
        ],
        afterQuestion2: <String>[],
      ),
    18 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/3/c/3/3c36409eb628bca2ace2abc4ce403c841c4f59c4.png',
        ],
        afterQuestion2: <String>[],
      ),
    19 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/6/4/1/641725c025ae42d5b317c98ea4c63ec792d958f4.png',
        ],
        afterQuestion2: <String>[],
      ),
    21 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/e/8/f/e8f0fbafcbb34e76c70c950d31025586b9f5fbc9.png',
        ],
        afterQuestion2: <String>[],
      ),
    22 => (
        afterQuestion1: [
          'https://artofproblemsolving.com/wiki/images/7/78/2025AMC8Prob22.png',
        ],
        afterQuestion2: <String>[],
      ),
    24 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/b/4/8/b48189544c48e3cff17c60db7cfeb51b71838651.png',
        ],
        afterQuestion2: <String>[],
      ),
    25 => (
        afterQuestion1: [
          'https://latex.artofproblemsolving.com/8/b/0/8b026573d3349d28bc765f08414aef75abc1b830.png',
        ],
        afterQuestion2: <String>[],
      ),
    _ => (afterQuestion1: <String>[], afterQuestion2: <String>[]),
  };
}
