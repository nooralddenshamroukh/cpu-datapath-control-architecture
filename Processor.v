module Processor (
    input clk,
    input rst,
    input [7:0]inpt,                       // input from external device
    output S,
    output [15:0] instruction,
    output [3:0] Time,
    output wire [15:0] mem_out,       // Data read from memory
    output wire [15:0] dout_IR, dout_TR, dout_DR, dout_AC,
    output wire [11:0] dout_PC, dout_AR,
    output wire [7:0] dout_INPR, dout_OUTR,
    output wire [28:0]control_word,
    output wire [15:0] bus_data,
    output wire [15:0] alu_result
);
   
    //wire [28:0]control_word;
    wire zero;
    wire load_INPR;

    DataPath uut (
        .clk(clk), .rst(rst),
        .control_word(control_word),
        .load_INPR(load_INPR),
        .inpt(inpt),
        .zero(zero),
        .instruction(instruction),
        .S(S),
        .mem_out(mem_out),
        .dout_IR(dout_IR), .dout_TR(dout_TR), .dout_DR(dout_DR), .dout_AC(dout_AC), .dout_PC(dout_PC), .dout_AR(dout_AR),
        .dout_INPR(dout_INPR), .out(dout_OUTR),.bus_data(bus_data),.alu_result(alu_result)
    );
    ControlUnit CU(
        .rst(rst),.clk(clk),.zero(zero),.I(instruction),
        .S(S),.control_word(control_word),.load_INPR(load_INPR), .T(Time)
        
    );
    
endmodule
