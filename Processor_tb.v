module Processor_tb();
    reg rst;
    reg clk;
    reg [7:0]inpt;
    wire S;
    wire [15:0] instruction;
    wire [28:0]control_word;
    wire [3:0] Time;
    wire [15:0] mem_out;
    wire [15:0] dout_IR, dout_TR, dout_DR, dout_AC ;
    wire [11:0] dout_PC,dout_AR;
    wire [7:0] dout_INPR, dout_OUTR;
    wire [15:0] bus_data;
    wire [15:0] alu_result;
    Processor pr(
    .control_word(control_word),
    .clk(clk),
    .rst(rst),
    .S(S),
    .inpt(inpt),                       // input from external device
    .instruction(instruction),
    .Time(Time),
    .mem_out(mem_out),       // Data read from memory
    .dout_IR(dout_IR), .dout_TR(dout_TR), .dout_DR(dout_DR), .dout_AC(dout_AC),
    .dout_PC(dout_PC), .dout_AR(dout_AR),
    .dout_INPR(dout_INPR), .dout_OUTR(dout_OUTR), .bus_data(bus_data),.alu_result(alu_result)
    );
    initial begin
        rst = 1 ; clk = 1; inpt = 8'h00;
        #5;
        rst = 0;
        #5;

        #2000;
        $stop;
    end
    always #5 clk = ~clk;
    
endmodule
