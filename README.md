# Assembly
Learning Assembly for Reverse Engineering as apart of my University module

Assembly Project 4th Year SETU Cybersecurity & IT Security © 2024 by David Williams is licensed under Attribution-NonCommercial-NoDerivatives 4.0 International. 
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
C00263768

**Project Description:**

>Write an assembly program that does a swapcase on a string. For example "Hello JOE!" would become "hELLO joe!"
>This must be commented and assemble correctly using "nasm" on linux. A starter assembly program that takes in input, does a rot47 encoding on it and outputs the result is included here for your reference.

>You must hand up:
>1. Commented Assembly program
>2. Readme.md file that uses markdown and contains the following:

    Author Name
    Student Number
    Licence Details (GPL recommended)
    Project Description
    Instructions on producing an executable
    Issues/Notes

**Instructions on producing an executable:**
Turn into an executable with the following two commands
nasm -f elf64 <filename>.asm
ld <filename>.o
assembles to code to produce the object file <filename>".o"
links to produce the executable "a.out"

**Issues:**
Had issues with the original ROT47 code working for me as it wasn't encrypting the original swapcase text.
Decided to try something different where it would checking the strings end while also checking the ASCII values range. If the character is not within the ASCII range, then do not store it and contiue if so.

Wanted to add some extra functionality to make this code unique by adding output strings for readability. Had some issues making it work at first due to some syntax errors, but got the outputs working.
