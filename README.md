this repo is a portfolio project that enable user to preview a song that are available on apple music.

in this repo, 
1. I use MVVM based architecture emphasized clean code that divide the codebase into 3 layer of Presentation, Domain, and Data.
2. publisher and subscriber pattern using Combine, and a native delegation pattern in the list view
3. in this repo I also use the github action to do CI that automate the testplan, build the .app for simulator and another .app for the github artifact

---

How to run in Xcode Simulator..

steps:
1. download the .app from the release or the actions tab
2. unzip the .zip containing the .app
3. run cmd bash => xcrun simctl install booted <<PATH TO THE .app>>
4. run cmd bash => xcrun simctl launch booted <<the bundle id of the APP, this can be check from xcode Bundle Identifier


<img width="1440" alt="Screenshot 2025-03-02 at 15 42 04" src="https://github.com/user-attachments/assets/70e4f8d7-8b43-467e-8e90-422c8f966ca5" />

Thank you
