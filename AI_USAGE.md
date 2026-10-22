# AI usage: dsc26-flt-w02

AI tools are allowed in this task. Fill in every section in your own words. Short is fine; honest is required. This file is read by your Track Mentor, not by the grader.

## 1. Tools I used

I used **ChatGPT** and **Claude** to assist with the development of this assignment.

## 2. The two or three most useful prompts

<!-- Paraphrasing is fine. Say what you were trying to get. -->

1.- **Understanding & Planning:** Analyzing task requirements and organizing the project structure.
2.- **Architecture Guidance:** Reviewing implementation guidelines to ensure compliance with architectural rules.
3.- **Testing & Debugging:** Drafting additional tests and troubleshooting Dart analyzer warnings.

## 3. One thing the AI got wrong or left out, and how I found it

During the planning phase, the AI suggested that using **Bloc / Cubit** was the best approach for the view model. However, the task requirements explicitly specified (or suggested) using **`ChangeNotifier` + `Provider`**. 

## 4. Why `visibleAlerts` lives in the view model and not in the screen

`visibleAlerts` resides in the view model because it is part of the application state and business logic. The view model is responsible for managing data and executing operations like filtering, searching, and sorting. In contrast, the screen (UI) should strictly be responsible for rendering and visualizing this data.