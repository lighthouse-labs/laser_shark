Activity.delete_all

# W1D1
d = 'w1d1'
Activity.create! day: d, start_time: 900, duration: 90, type: 'Lecture', name: "Morning Class",
  instructions: <<-TEXT
## Welcome to Lighthouse Labs!

Topics:

* Student Introductions
* Teaching Intrductions
* Tour of Space
* Expectations
* Pictures
* What does it mean to be a developer?
* Lighthouse Curriculum
TEXT

Activity.create! day: d, start_time: 1100, duration: 60, type: 'Assignment', name: 'Vagrant Setup', gist_url: 'https://gist.github.com/kvirani/4d0c09da873c26e55477'

Activity.create! day: d, start_time: 1200, duration: 60, type: 'Assignment', name: 'Git Setup (in Vagrant)', gist_url: 'https://gist.github.com/kvirani/2af0ccab06b9dcfe194c'

Activity.create! day: d, start_time: 1300, duration: 30, type: 'Assignment', name: 'Unix Commands - Reference', gist_url: 'https://gist.github.com/kvirani/98d0fea23ea156fe8b69'

Activity.create! day: d, start_time: 1330, duration: 45, type: 'Assignment', name: 'Unix Commands - Discovery', gist_url: 'https://gist.github.com/kvirani/64e71a7cf6581143bd41'

Activity.create! day: d, start_time: 1415, duration: 120, type: 'Assignment', name: 'Unix Commands - Problems', gist_url: 'https://gist.github.com/kvirani/26ab6a66c648c5992e4d'

Activity.create! day: d, start_time: 1500, duration: 90, type: 'Lecture', name: "Afternoon Class / Breakout",
  instructions: <<-TEXT
## Introduction to Git

Topics:

* Background / History
* Branching & Merging
* Remotes
* Conflicts
TEXT

Activity.create! day: d, start_time: 1630, duration: 30, type: 'Assignment', name: 'Git Cheat Sheet (Resource)',
instructions: <<-TEXT

### PDF

Download this concise resource (created by our very own Don Burks) to help you get comfortable with setting up new git repositories: <http://d.pr/f/V0Gz/3kJwGMre>

Read through it to get an idea of what it covers, because you'll likely want to refer to it in the future.

TEXT

Activity.create! day: d, start_time: 1700, duration: 30, type: 'Assignment', name: "Gitting comfortable with Git (Git it?)",
instructions: <<-TEXT
## Git Real

Go through **level 1** (only) of Git Real: <https://www.codeschool.com/courses/git-real>
TEXT

Activity.create! day: d, start_time: 1730, duration: 30, type: 'Assignment', name: "Git it Already!",
instructions: <<-TEXT
## Git Remotes

Load up and go through the "remote" levels 1 through 3 in this interactive lesson: http://pcottle.github.io/learnGitBranching/

### Read this first:

* In the welcome popup, click the red button to bring up all the lessons
* Click on the "remote" tab
* Complete levels 1 through 3 (only)
TEXT

Activity.create! day: d, start_time: 1800, duration: 120, type: 'Assignment', name: "Git Collaboration & Merge Conflicts (Pair Exercise)", gist_url: 'https://gist.github.com/kvirani/ef656ba1dd2eff5f38c2'

Activity.create! day: d, start_time: 2000, duration: 60, type: 'Assignment', name: "Git Branching",
instructions: <<-TEXT

<http://pcottle.github.io/learnGitBranching/>

* In the welcome popup, click the red button to bring up all the lessons
* Click on the **"main"** tab (you went through the "remote" tab earlier)
* Complete levels 1 through 3
TEXT

Activity.create! day: d, start_time: 2100, duration: 60, type: 'Homework', name: 'Readings & Questions',
gist_url: 'https://gist.github.com/kvirani/fc767cf8eef1741da6cf'

Activity.create! day: d, start_time: 2200, duration: 15, type: 'Homework', name: 'Sublime Configuration',
gist_url: 'https://gist.github.com/kvirani/d00a24eadf7dd93b93e8'

# W1D2
d = 'w1d2'
Activity.create! day: d, start_time: 900, duration: 90, type: 'Lecture', name: "Morning Class",
instructions: <<-TEXT

## 1. Take up Unix Homework

## 2. Introduction to Ruby & Programming
* Basic Standard I/O with Ruby
* REPL
* IRB (Pry)
* Methods
* Basic problem solving & debugging

TEXT

Activity.create! day: d, start_time: 1100, duration: 30, type: 'Assignment', name: 'Interactive Ruby (Lesson)', gist_url: 'https://gist.github.com/kvirani/dc2d610ccc47bfd4214e'

Activity.create! day: d, start_time: 1130, duration: 30, type: 'Assignment', name: 'Interactive Ruby (Practice)', gist_url: 'https://gist.github.com/kvirani/698da396a614b4123420'

Activity.create! day: d, start_time: 1200, duration: 30, type: 'Assignment', name: 'Maximum Value', gist_url: 'https://gist.github.com/kvirani/99deb315bd062252d182'

Activity.create! day: d, start_time: 1230, duration: 30, type: 'Assignment', name: 'FizzBuzz Refactor', gist_url: 'https://gist.github.com/kvirani/b7f3674d6a3b5572471c'

Activity.create! day: d, start_time: 1300, duration: 60, type: 'Assignment', name: 'The Yuppie Vancouverite', gist_url: 'https://gist.github.com/kvirani/e16580bc05c7cac4f3e3'

Activity.create! day: d, start_time: 1400, duration: 120, type: 'Assignment', name: 'Shakil The Dog', gist_url: 'https://gist.github.com/kvirani/871340ef674ec56a6582'

Activity.create! day: d, start_time: 1500, duration: 90, type: 'Lecture', name: "Afternoon Class / Breakout"

Activity.create! day: d, start_time: 1800, duration: 60, type: 'Assignment', name: 'Sorting Algorithm - Stretch (Optional)', gist_url: 'https://gist.github.com/kvirani/075b6acf74a5921c3e93'

Activity.create! day: d, start_time: 1900, duration: 60, type: 'Assignment', name: 'Coding Your Code', gist_url: 'https://gist.github.com/fourmojocto/88d0ae84023edc8939e2'

Activity.create! day: d, start_time: 1900, duration: 120, type: 'Homework', name: 'Readings & Questions', gist_url: 'https://gist.github.com/kvirani/83c26eef733a5399ab8c'


# W1D3
d = 'w1d3'
Activity.create! day: d, start_time: 900, duration: 90, type: 'Lecture', name: "Morning Class",
instructions: <<-TEXT

## Plan (tentative)

1. Symbols
 * How do they compare to strings?
 * When are they used?
2. Take up [homework from previous day](/days/w1d2/activities/63)
3. Break
4. Hashes / Dictionaries

TEXT

Activity.create! day: d, start_time: 1100, duration: 60, type: 'Assignment', name: 'Debugging (Average Calculation)', gist_url: 'https://gist.github.com/kvirani/be0039711272c81f047f'

Activity.create! day: d, start_time: 1200, duration: 90, type: 'Assignment', name: 'States & Cities', gist_url: 'https://gist.github.com/kvirani/cf8683c9e6793a68bb69'

Activity.create! day: d, start_time: 1330, duration: 60, type: 'Assignment', name: 'Character Counting', gist_url: 'https://gist.github.com/kvirani/35bbb470827284f7d4a0'

Activity.create! day: d, start_time: 1500, duration: 90, type: 'Lecture', name: "Afternoon Class / Breakout"

Activity.create! day: d, start_time: 1700, duration: 180, type: 'Assignment', name: 'Roman Numerals', gist_url:
'https://gist.github.com/kvirani/d4e11f7447ba62216331'

Activity.create! day: d, start_time: 2000, duration: 120, type: 'Homework', name: 'Readings & Questions', gist_url: 'https://gist.github.com/kvirani/e3a213620da60bef477f'