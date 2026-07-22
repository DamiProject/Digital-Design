# APB-Interfaced Dice Roller with Seven-Segment Word Encoding

Status: Under active development
---
## How It Works

This project implements a digital "dice roller" that generates a pseudorandom number (1–6) on a rising clock edge when **roll** is asserted, and displays the result as a word ("one" through "six") across seven-segment displays. 

Once a value is determined, the device translates this numeric data into a word format displayed via a seven-segment display. Because standard seven-segment displays are limited in their character set, the design employs a "visual cheating" technique. For instance, the letter ‘w’ in "two" is approximated using two adjacent display characters, and the ‘x’ in "six" is rendered across three characters. These complex segment encodings are retrieved from a behavioral memory model via an **Advanced Peripheral Bus (APB) read transaction**. The final output is driven to the segments port, with a valid signal asserting once the data is stable.

## Project Scope & Contributions

This project was a structured hierarchical design exercise in Doulos's "Essential Digital Design Techniques" course, where the top-level of the design integrates different subcomponents as seen in Figure 1. The top-level design framework, finite state machine, testbench, and behavioral memory model were provided. 

My specific contributions to the design include:

- **Synchronous Modulo-6 Counters(cnt6):** Designed the Register Transfer Level (RTL) for the synchronous modulo-6 counter, which is instantiated as both the random_counter and address_counter.
- **Synchronizer:** Designed a dual stage flip flop synchronizer to avoid the risk of input and output metastability to the finite state machine (FSM) of the top-level design.
- **APB Manager and Subordinate Logic:** Implemented the APB read transaction timing cycles required to retrieve word encodings from the behavioral memory model (apb_mem) and drive them to the segments port.

**Note:** RTL designs not authored by me are excluded from this repository for copyright compliance.

<img width="510" height="277" alt="image" src="https://github.com/user-attachments/assets/e6b0b55b-7eb8-4acd-82cd-ce8af3e0566e" />

Figure 1: Project Architecture Block Diagram (Source: Essential Digital Design Techniques, Doulos).

### Top-Level Design Features

#### Top-Level Input/Output Ports

**Inputs**

- **Global System Clock:** The primary timing reference for the top-level design and subcomponents.
  
- **Asynchronous Reset:** The system-wide initialization signal that instantly forces the top-level design and all subcomponents into a known starting state.
  
- **Data Input:** The asynchronous `roll` signal is synchronized to the system clock on the rising edge of `clk` before entering the FSM control logic.
  
```vhdl
Synchronizer : process(clk)
begin
    if rising_edge(clk) then
        Roll_Sync1 <= roll;
        Roll_Sync2 <= Roll_Sync1;
    end if;
end process;
```

**Outputs**

- **Segments:** Each element of `segments` corresponds to a single seven-segment display element and displays the generated dice roller value as an array of logic values.

- **Valid:** Asserted when display output is stable and valid.

  



<img width="1000" height="1000" alt="Output_Dice" src="https://github.com/user-attachments/assets/db8a304f-303f-4c63-8558-2b0f5eb6d852" />
