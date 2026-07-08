# APB-Interfaced Dice Roller with Seven-Segment Word Encoding

Status: Under active development
---
## How It Works

This project implements a digital "dice roller" that generates a pseudorandom number (1–6) on a rising clock edge when **roll** is asserted, and displays the result as a word ("one" through "six") across seven-segment displays. 

Once a value is determined, the device translates this numeric data into a word format displayed via a seven-segment display. Because standard seven-segment displays are limited in their character set, the design employs a "visual cheating" technique. For instance, the letter ‘w’ in "two" is approximated using two adjacent display characters, and the ‘x’ in "six" is rendered across three characters. These complex segment encodings are retrieved from a behavioral memory model via an **Advanced Peripheral Bus (APB) read transaction**. The final output is driven to the segments port, with a valid signal asserting once the data is stable.

## Project Scope & Contributions

This project was developed as part of a structured hierarchical design exercise. While the behavioral memory model,  






