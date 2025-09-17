module E_FlipFlop (
    input wire clk,       // Clock input
    input wire rst,       // Asynchronous reset
    input wire Zero,      // Zero signal input
    input wire J,         // J input
    input wire K,         // K input
    output reg Q,         // Q output
    output wire Qn        // Complement of Q
);

    // Complement of Q
    assign Qn = ~Q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;  
        end else if (J == 1'b0 && K == 1'b0) begin
            
            if (Zero) begin
                Q <= 1'b1; 
            end else begin
                Q <= 1'b0; 
            end
        end else begin
           
            case ({J, K})
                2'b00: Q <= Q;           // No change
                2'b01: Q <= 1'b0;        // Reset Q
                2'b10: Q <= 1'b1;        // Set Q
                2'b11: Q <= ~Q;          // Toggle Q
            endcase
        end
    end
endmodule
module S_FlipFlop (
    input wire clk,    // Clock input
    input wire rst,    // Asynchronous reset
    input wire J,      // J input
    input wire K,      // K input
    output reg Q,      // Q output
    output wire Qn     // Complement of Q
);

    // Complement of Q
    assign Qn = ~Q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;  // Reset Q to 0
        end else begin
            case ({J, K})
                2'b00: Q <= Q;           // No change
                2'b01: Q <= 1'b0;        // Reset Q
                2'b10: Q <= 1'b1;        // Set Q
                2'b11: Q <= ~Q;          // Toggle Q
            endcase
        end
    end
endmodule

module DataPath (
    input wire clk,
    input wire rst,
    // bus_selector(24-22), ALU operation(21-19), mem_write(18), mem_read(17),
    // (load, inc, clr)AR(16-14), (load, inc, clr)PC(13-11),
    // (load, inc, clr)DR(10-8), (load, inc, clr)AC(7-5), load_IR(4), 
    // (load, inc, clr)TR(3-1), load_OUTR(0)
    input wire [28:0] control_word,
    
    input wire [7:0] inpt,       // External input data for INPR
    input wire load_INPR,

    output wire zero,                 // Zero flag from ALU
    output [15:0] instruction,
    output wire [7:0] out,       // Output data from 'OUTR'
    output wire S,
    // JUST FOR TESTING:
    output wire [15:0] mem_out,       // Data read from memory
    output wire [15:0] dout_IR, dout_TR, dout_DR, dout_AC,
    output wire [11:0] dout_PC, dout_AR,
    output wire [7:0] dout_INPR, dout_OUTR,
    output wire [15:0] bus_data,             // 16-bit common bus
    output wire [15:0] alu_result
);

    // Internal wires for component connections
    
    reg [28:0] CW;                   // internal control word
    wire Zero;
    reg CLK;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            CW <= 29'b0;
        end else if (S) begin
            CW[26:0] <= 27'b000000000000000000000000000;
            CW[28:27] <= control_word[28:27];
        end else begin
            CW <= control_word;
        end
    end
    // Instantiate Register File
    RegisterFile reg_file (
        .clk(clk),
        .rst(rst),
        .load_PC(CW[13]),
        .load_AR(CW[16]),
        .load_IR(CW[4]),
        .load_TR(CW[3]),
        .load_DR(CW[10]),
        .load_AC(CW[7]),
        .increment_PC(CW[12]),
        .increment_AR(CW[15]),
        .increment_TR(CW[2]),
        .increment_DR(CW[9]),
        .increment_AC(CW[6]),
        .clear_PC(CW[11]),
        .clear_AR(CW[14]),
        .clear_TR(CW[1]),
        .clear_DR(CW[8]),
        .clear_AC(CW[5]),
        .load_INPR(load_INPR),
        .load_OUTR(CW[0]),
        .din_PC(bus_data[11:0]),
        .din_AR(bus_data[11:0]),
        .din_IR(bus_data),
        .din_TR(bus_data),
        .din_DR(bus_data),
        .din_AC(alu_result),           // AC input is from ALU result
        .din_OUTR(bus_data[7:0]),
        .din_INPR(inpt),          // INPR input is external, not from bus
        .dout_PC(dout_PC),
        .dout_AR(dout_AR),
        .dout_IR(dout_IR),
        .dout_TR(dout_TR),
        .dout_DR(dout_DR),
        .dout_AC(dout_AC),
        .dout_OUTR(dout_OUTR),
        .dout_INPR(dout_INPR)
    );

    // Bus Multiplexer
    assign bus_data = (CW[24:22] == 3'b001) ? {4'b0, dout_AR} :  // PC to bus
                      (CW[24:22] == 3'b010) ? {4'b0, dout_PC} :  // AR to bus
                      (CW[24:22] == 3'b011) ? dout_DR :          // DR to bus
                      (CW[24:22] == 3'b100) ? dout_AC :          // AC to bus
                      (CW[24:22] == 3'b101) ? dout_IR :          // IR to bus
                      (CW[24:22] == 3'b110) ? dout_TR :          // TR to bus
                      (CW[24:22] == 3'b111) ? mem_out :          // memory
                      (CW[24:22] == 3'b000) ? bus_data:
                      bus_data;                                            // Default: bus is bus

    assign instruction = dout_IR;
    assign out = dout_OUTR;

    
    // Instantiate ALU (Arithmetic Logic Unit)
    ALU alu (
        .enable(1'b1),                  // Always enabled
        .data1(dout_AC),                // AC as ALU input 1
        .data2(dout_DR),                // DR as ALU input 2
        .INPR(dout_INPR),               // input register
        .operation(CW[21:19]),
        .result(alu_result),
        .zero(Zero)
    );

    // Instantiate Memory Unit
    memory_unit mem (
        .clk(clk),
        .rst(rst),
        .address(dout_AR),              // Memory address comes from AR
        .write_enable(CW[18]),
        .read_enable(CW[17]),
        .data_in(bus_data),             // Memory data input from bus
        .data_out(mem_out)
    );
    E_FlipFlop EFF(
        .clk(clk),
        .rst(rst),
        .Zero(Zero),
        .J(CW[26]),
        .K(CW[25]),
        .Q(zero),
        .Qn()
    );
    S_FlipFlop SFF(
        .clk(clk),
        .rst(rst),
        .J(CW[28]),
        .K(CW[27]),
        .Q(S),
        .Qn()
    );
    
endmodule
