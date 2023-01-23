# Integer operations and data validation the hard way with String Primitives and Macros

## GIF Demonstration
![](https://github.com/samuelcoding97/String-Primitives-and-Macros/blob/main/String%20Primitives%20and%20Macros/program-demonstration.gif)

<img src=/blob/main/String%20Primitives%20and%20Macros/program-demonstration.gif width="300"/>

## About
To get into the grit of software, is to recognize that integers are represented as ASCII symbols onscreen, rather than their true values. This program performs basic integer operations and data validation *without* using the standard ReadInt, ReadDec, WriteInt and WriteDec. Furthermore, the program does not use WriteString, but rather invokes Macros to display string primitives onscreen. 

To perform data validation and basic integer operations the input is stored as a byte sized array otherwise known as a string primitive. In this program 10 numbers are requested from the user. Each "number" is stored as a string primitive. That string is checked to make sure the ASCII values correspond with an integer, and that the integer can fit in a 32-bit register. If the input is invalid for one of the aforementioned reasons, the input is rejected and the user is re-prompted to enter valid input.

After 10 valid integers have been entered the program returns the numbers in a list, the sum, the truncated average, and a farewell message.

Some of the challenges in writing this program included not being able to use the standard assembly procedures, namely WriteInt WriteDec ReadInt ReadDec and WriteString which increased the number of lines of code. While assembly is already "re-inventing the wheel" in some regard, the procedures created in this program were re-inventing already established standard procedures of assembly. Additionally, loading string bytes and converting them from ASCII symbols to integers was particularly difficult. This process required several loops of loading and storing string bytes to operate correctly.

## How to run the project
Viewing MASM files requires Windows, or <a href="https://www.citrix.com/products/receiver.html">Citrix</a> for Mac and Linux OS users. This project can be loaded in <a href="https://learn.microsoft.com/en-us/visualstudio/releases/2019/release-notes">Visual Studio 2019</a> (not VS Code). To run the program follow these steps:
1. If not on Windows OS, download the Citrix software.
2. Download Visual Studio 2019
3. Download the project folder from the repository. 
4. Open the Project.sln file with Visual Studio.
5. Proj6_millsamu.asm (the solution file with the program) should already be loaded on screen.
6. Press Ctrl + F5, or click "Debug" at the top of the screen and then "Start Without Debugging"
