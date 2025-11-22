📌 Society Management System (SMS)

A MASM (Assembly) based Console Application for University Society & Member Management

👥 Team Members

Syed Abdullah Kamran (24K-0723)

Hasan Mujtaba (24K-0852)

Muhammad Shabbir (24K-0502)

📝 Overview

The Society Management System (SMS) is a console-based application developed using MASM (Assembly Language) and the Irvine32 library.
It provides an efficient way to manage university societies and their members, allowing users to add, delete, edit, view, and search records through a menu-driven interface.

This project serves as a solution to the difficulties of managing multiple societies manually using Excel sheets or paper records.

🎯 Features
✓ Society Management

Add a new society

View all societies

Edit society details

Delete a society

Maintain and display total member count

✓ Member Management

Add member

View member list

Edit member details

Delete member

Search for a specific member

✓ Navigation

Simple menu-based interface

Easy switching between society and member modules

🛠 Technical Details

Language: MASM Assembly

Assembler: Visual Studio using MASM + Irvine32 library

Storage Type: In-memory arrays (No file handling)

Interface: Console-based

Limits:

Maximum 5 societies

Each society can have up to 5 members
(scalable later)

🧩 System Design
Data Structure Approach

Array-based design for storing societies and members

Index shifting used during deletions to avoid empty gaps

Simple linear search mechanism for finding members

Modular Approach

Society module

Member module

Main menu for navigation

🚀 Development Methodology

Initial research & problem breakdown

Implementation of society management (Muhammad & Abdullah)

Implementation of member management (Muhammad & Hasan)

Integration & testing of menu navigation, add/delete/edit/search features

📊 Results

Fully functional system meeting all defined objectives

Efficient handling of societies and members

Clean navigation through menu-driven interface

Demonstrates strong command of:

Assembly programming

Array manipulation

User input validation

🧪 Challenges Faced

Shifting array elements during deletions

Managing fixed-size data structures

Ensuring smooth navigation in pure assembly

🔮 Future Improvements

Add file I/O for persistent storage

Expand limit for societies & members

Implement dynamic arrays

Add advanced search & sorting features

Introduce GUI or more advanced console UI

📂 How to Run

Install Microsoft Visual Studio

Add MASM and Irvine32 library

Open the project folder

Assemble and run using Visual Studio build options

Use menu commands to navigate through the system
