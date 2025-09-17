module memory_unit (
    input wire clk,
    input wire rst,
    input wire [11:0] address,    // 12-bit address input (4096 locations)
    input wire write_enable,      // Control signal for writing data to memory
    input wire read_enable,       // Control signal for reading data from memory
    input wire [15:0] data_in,    // Data to write to memory
    output reg [15:0] data_out    // Data read from memory
);   

    reg [15:0] memory [0:4095];   // Declare 4096 x 16-bit memory array
    integer i;                    // Declare integer variable for initialization

    // Memory Initialization (garbage for simulation, 0 for synthesis)
    initial begin
        for (i = 0; i < 50; i = i + 1) begin
            memory[i] = i + i*i;    // Garbage data (simulation-only)
        end
        for (i = 50; i < 4096; i = i + 1) begin
            memory[i] = 16'b0;      // Default to 0
        end
        memory[0] = 16'h0032; // Custom initialization to program 1
        //instructions
        memory[50] = 16'h7800; // CLA: Clear AC (AC = 0)
        memory[51] = 16'h7400; // CLE: Clear E (E = 0)

        memory[52] = 16'h2064; // LDA 64: Load AC from memory address 64
        memory[53] = 16'h1065; // ADD 65: Add memory word at address 65 to AC
        memory[54] = 16'h3066; // STA 66: Store the content of AC into memory address 66
        memory[55] = 16'h7200; // CMA: Complement AC (AC = ~AC)
        memory[56] = 16'h7020; // INC: Increment AC (AC = AC + 1)
        memory[57] = 16'h3067; // STA 67: Store the content of AC into memory address 67
        memory[58] = 16'h2066; // LDA 66: Load AC from memory address 66
        memory[59] = 16'h7010; // SPA: Skip next instruction if AC is positive
        memory[60] = 16'h4043; // BUN 43: Branch unconditionally to address 43

        memory[61] = 16'h2065; // LDA 65: Load AC from memory address 65
        memory[62] = 16'h7080; // CIR: Circulate right AC and E
        memory[63] = 16'h3068; // STA 68: Store the content of AC into memory address 68
        memory[64] = 16'h2064; // LDA 64: Load AC from memory address 64
        memory[65] = 16'h7040; // CIL: Circulate left AC and E
        memory[66] = 16'h3069; // STA 69: Store the content of AC into memory address 69
        memory[67] = 16'h7001; // HLT: Halt computer

        memory[69] = 16'h7200; // CMA: Complement AC (AC = ~AC)
        memory[70] = 16'h606A; // ISZ 6A: Increment memory word at address 6A and skip next instruction if zero
        memory[71] = 16'h4034; // BUN 34: Branch unconditionally to address 34
        
        
        //MEMORY INITIALIZATION:
        memory[100] = 16'h0019; //NUM1
        memory[101] = 16'h0008; //NUM2
        memory[102] = 16'h0000; //RESULT
        memory[103] = 16'h0000; //COMP_RESULT
        memory[104] = 16'h0000; //CIRC_RIGHT
        memory[105] = 16'h0000; //CIRC_LEFT
        memory[106] = 16'hFFFB; //COUNT
        
    end

    // Synchronous Read/Write Operations
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            // Optional reset behavior: Clear data_out
            data_out <= 16'b0;
        end else begin
            if (write_enable) begin
                memory[address] <= data_in;  // Write data to memory
            end
            if (read_enable) begin
                data_out <= memory[address];  // Read data from memory
            end
        end
    end
   
endmodule


