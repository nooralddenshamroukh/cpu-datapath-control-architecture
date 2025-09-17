# Basic Computer CPU – VLSI Design (Datapath & Control Unit)

This project was developed as part of my **Computer Architecture course**.  
It demonstrates the design and implementation of a **basic CPU** using Verilog, including its **datapath**, **control unit**, and support for fundamental **low-level instructions**.

---

## 🖥️ Project Overview
- **Datapath Design**:
  - Memory Unit (4096 × 16-bit)
  - Register File (PC, AR, IR, DR, TR, AC, INPR, OUTR)
  - Arithmetic Logic Unit (ALU)
  - Input/Output handling
- **Control Unit**:
  - 29-bit control word to manage micro-operations
  - Sequencing and synchronization of CPU operations
- **Instruction Set**:
  - Memory-reference instructions: LDA, ADD, STA, ISZ, BUN, BSA
  - Register-reference instructions: CLA, CMA, etc.
  - Logical & arithmetic operations: AND, XOR, COM, shifts
- **Testing**:
  - Each module tested individually with Verilog testbenches
  - Waveform simulations to validate datapath and control logic
  - Execution of instruction cycles step by step (Fetch, Decode, Execute)

---

## 📂 Project Structure
- `Registers/` → Verilog modules for PC, AR, IR, DR, TR, AC, INPR, OUTR
- `Memory/` → Memory module with synchronous read/write
- `ALU/` → Arithmetic and Logic Unit implementation
- `ControlUnit/` → Control word and instruction sequencing
- `Datapath/` → Integration of all modules
- `Testbenches/` → Simulation files for unit and system-level testing
- `Docs/` → Reports and explanation of the design

---

## ⚙️ How It Works
1. **Fetch Cycle**: PC → AR → IR loads next instruction.
2. **Decode**: Control word sets micro-operations.
3. **Execute**: Instruction executed via ALU, Memory, and Registers.
4. **Output**: Results stored in memory or OUTR register.

---

## 🛠️ Technologies Used
- **Verilog HDL**
- **ModelSim** (for simulation and waveform analysis)
- **VLSI concepts** for datapath and control design

---

## 👨‍💻 Team Members
- Noor Aldden Shamroukh  
- Amro Ghaleb Al-Qudimat  
- Ward Mohammad Ghnaim  
- Ahmad Ramzi Ali Al-Shaer  
- Osama Ghassan Nawaf  

---

## 📚 Course
Computer Architecture – The Hashemite University
