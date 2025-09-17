module Register #(parameter WIDTH = 16) (
    input clk,
    input rst,
    input load,
    input increment,
    input clear,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);
    reg [WIDTH-1:0] reg_data; // Internal register to store data

    // Write operation on the falling edge of the clock
    always @(negedge clk or posedge rst) begin
        if (rst)
            reg_data <= 0; // Reset internal register to 0
        else if (clear)
            reg_data <= 0; // Clear the internal register
        else if (load)
            reg_data <= din; // Load data into internal register
        else if (increment)
            reg_data <= reg_data + 1; // Increment internal register by 1
    end

    // Read operation on the rising edge of the clock
    always @(posedge clk or posedge rst) begin
        if (rst)
            dout <= 0; // Reset output to 0
        else
            dout <= reg_data; // Update output with the value from the internal register
    end
endmodule





module RegisterFile (
    input clk,
    input rst,
    input load_PC, load_AR, load_IR, load_TR, load_DR, load_AC, load_OUTR, load_INPR,
    input increment_PC, increment_AR, increment_TR, increment_DR, increment_AC,
    input clear_PC, clear_AR, clear_TR, clear_DR, clear_AC,
    input [11:0] din_PC, din_AR,        // 12-bit inputs for PC and AR
    input [15:0] din_IR, din_TR, din_DR, din_AC, // 16-bit inputs for IR, TR, DR, and AC
    input [7:0] din_INPR, din_OUTR,      // 8-bit inputs for INPR and OUTR
    output [11:0] dout_PC, dout_AR,      // 12-bit outputs for PC and AR
    output [15:0] dout_IR, dout_TR, dout_DR, dout_AC, // 16-bit outputs for IR, TR, DR, and AC
    output [7:0] dout_INPR, dout_OUTR    // 8-bit outputs for INPR and OUTR
);
    // Instantiate each register with appropriate width, load, and increment signals

    // 12-bit registers
    Register #(12) PC (.clk(clk), .rst(rst), .load(load_PC), .clear(clear_PC), .increment(increment_PC), .din(din_PC), .dout(dout_PC));
    Register #(12) AR (.clk(clk), .rst(rst), .load(load_AR), .clear(clear_AR), .increment(increment_AR), .din(din_AR), .dout(dout_AR));

    // 16-bit registers
    Register #(16) IR (.clk(clk), .rst(rst), .load(load_IR), .clear(0), .increment(0), .din(din_IR), .dout(dout_IR));
    Register #(16) TR (.clk(clk), .rst(rst), .load(load_TR), .clear(clear_TR), .increment(increment_TR), .din(din_TR), .dout(dout_TR));
    Register #(16) DR (.clk(clk), .rst(rst), .load(load_DR), .clear(clear_DR), .increment(increment_DR), .din(din_DR), .dout(dout_DR));
    Register #(16) AC (.clk(clk), .rst(rst), .load(load_AC), .clear(clear_AC), .increment(increment_AC), .din(din_AC), .dout(dout_AC));

    // 8-bit registers
    Register #(8) INPR (.clk(clk), .rst(rst), .load(load_INPR), .clear(0), .increment(0), .din(din_INPR), .dout(dout_INPR));
    Register #(8) OUTR (.clk(clk), .rst(rst), .load(load_OUTR), .clear(0), .increment(0), .din(din_OUTR), .dout(dout_OUTR));
    
endmodule



module tb_RegisterFile();
    reg clk, rst;
    reg load_PC, load_AR, load_IR, load_TR, load_DR, load_AC, load_OUTR, load_INPR;
    reg increment_PC, increment_AR, increment_TR, increment_DR, increment_AC;
    reg clear_PC, clear_AR, clear_TR, clear_DR, clear_AC;
    reg [11:0] din_PC, din_AR;
    reg [15:0] din_IR, din_TR, din_DR, din_AC;
    reg [7:0] din_INPR, din_OUTR;
    wire [11:0] dout_PC, dout_AR;
    wire [15:0] dout_IR, dout_TR, dout_DR, dout_AC;
    wire [7:0] dout_INPR, dout_OUTR;

    // Instantiate the RegisterFile
    RegisterFile uut (
        .clk(clk), .rst(rst),
        .load_PC(load_PC), .din_PC(din_PC), .dout_PC(dout_PC), .clear_PC(clear_PC), .increment_PC(increment_PC),
        .load_AR(load_AR), .din_AR(din_AR), .dout_AR(dout_AR), .clear_AR(clear_AR), .increment_AR(increment_AR),
        .load_IR(load_IR), .din_IR(din_IR), .dout_IR(dout_IR),
        .load_TR(load_TR), .din_TR(din_TR), .dout_TR(dout_TR), .clear_TR(clear_TR), .increment_TR(increment_TR),
        .load_DR(load_DR), .din_DR(din_DR), .dout_DR(dout_DR), .clear_DR(clear_DR), .increment_DR(increment_DR),
        .load_AC(load_AC), .din_AC(din_AC), .dout_AC(dout_AC), .clear_AC(clear_AC), .increment_AC(increment_AC),
        .load_INPR(load_INPR), .din_INPR(din_INPR), .dout_INPR(dout_INPR),
        .load_OUTR(load_OUTR), .din_OUTR(din_OUTR), .dout_OUTR(dout_OUTR)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Reset all registers
        rst = 1;
        #10 rst = 0;

        // Verify reset behavior
        if (dout_PC !== 0 || dout_AR !== 0 || dout_IR !== 0 || dout_TR !== 0 || dout_DR !== 0 || dout_AC !== 0 || dout_INPR !== 0 || dout_OUTR !== 0)
            $display("ERROR: Reset failed!");

        // Load values into registers
        load_PC = 1; din_PC = 12'hABC; #10 load_PC = 0;
        load_AR = 1; din_AR = 12'h123; #10 load_AR = 0;
        load_IR = 1; din_IR = 16'hBEEF; #10 load_IR = 0;
        load_TR = 1; din_TR = 16'hCAFE; #10 load_TR = 0;
        load_DR = 1; din_DR = 16'h1234; #10 load_DR = 0;
        load_AC = 1; din_AC = 16'h5678; #10 load_AC = 0;
        load_OUTR = 1; din_OUTR = 8'h5A; #10 load_OUTR = 0;

        // Increment registers
        increment_PC = 1; #10 increment_PC = 0;
        increment_AC = 1; #10 increment_AC = 0;

        // Clear registers
        clear_PC = 1; clear_AC = 1; #10 clear_PC = 0; clear_AC = 0;

        // End the simulation
        #20;
        $stop;
    end
endmodule


