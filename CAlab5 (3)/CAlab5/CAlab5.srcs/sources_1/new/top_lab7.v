//`timescale 1ns / 1ps

//module top_lab7(
//    input clk,
//    input reset_btn,        
//    input [15:0] switches,  
//    output [15:0] leds,     
//    output [6:0] seg,       
//    output [3:0] an         
//    );

//    // Internal Signals
//    wire reset_debounced;
//    wire enable_1hz;
//    wire enable_refresh;
    
//    // Register File & ALU Wiring
//    wire [31:0] rf_ReadData1, rf_ReadData2;
//    reg rf_WriteEnable;
//    reg [4:0] rf_rs1, rf_rs2, rf_rd;
//    reg [31:0] rf_WriteData;
    
//    wire [31:0] alu_result;
//    wire alu_zero;
//    reg [3:0] alu_control;

//    // Expanded FSM States to include Write-Back [cite: 51, 60]
//    localparam S_IDLE       = 4'd0, 
//               S_INIT_X1    = 4'd1, 
//               S_INIT_X2    = 4'd2, 
//               S_ALU_ADD    = 4'd3, S_WRITE_ADD = 4'd4,
//               S_ALU_SUB    = 4'd5, S_WRITE_SUB = 4'd6,
//               S_ALU_AND    = 4'd7, S_WRITE_AND = 4'd8,
//               S_DONE       = 4'd9;

//    reg [3:0] state = S_IDLE;

//    debouncer u_debouncer (
//        .clk(clk),
//        .pbin(reset_btn),
//        .pbout(reset_debounced)
//    );

//    // ONE_HZ_LIMIT set to 10 for simulation; should be 100_000_000 for hardware [cite: 102]
//    clock_divider #(.ONE_HZ_LIMIT(1)) u_clkdiv ( 
//        .clk(clk),
//        .rst(reset_debounced),
//        .enable_1hz(enable_1hz),
//        .enable_refresh(enable_refresh)
//    );

//    RegisterFile u_regfile (
//        .clk(clk),
//        .rst(reset_debounced),
//        .WriteEnable(rf_WriteEnable),
//        .rs1(rf_rs1), .rs2(rf_rs2), .rd(rf_rd),
//        .WriteData(rf_WriteData),
//        .ReadData1(rf_ReadData1), .ReadData2(rf_ReadData2)
//    );

//    ALU_wrapper u_alu (
//        .A(rf_ReadData1),
//        .B(rf_ReadData2),
//        .ALUControl(alu_control),
//        .ALUResult(alu_result),
//        .Zero(alu_zero)
//    );

//    // FSM Control Logic [cite: 46, 52]
//    always @(posedge clk) begin
//        if (reset_debounced) begin
//            state <= S_IDLE;
//            rf_WriteEnable <= 0;
//        end else if (enable_1hz) begin
//            case (state)
//                S_IDLE: state <= S_INIT_X1;
                
//                // Initialize Registers [cite: 47, 87]
//                S_INIT_X1: begin 
//                    rf_WriteEnable <= 1; rf_rd <= 5'd1; 
//                    rf_WriteData <= 32'h10101010;
//                    state <= S_INIT_X2;
//                end
                
//                S_INIT_X2: begin 
//                    rf_WriteEnable <= 1; rf_rd <= 5'd2; 
//                    rf_WriteData <= 32'h01010101;
//                    state <= S_ALU_ADD;
//                end
                
//                // ADD Operation 
//                S_ALU_ADD: begin 
//                    rf_WriteEnable <= 0; // Prepare ALU inputs
//                    rf_rs1 <= 5'd1; rf_rs2 <= 5'd2;
//                    alu_control <= 4'b0000;
//                    state <= S_WRITE_ADD;
//                end

//                S_WRITE_ADD: begin 
//                    rf_WriteEnable <= 1; rf_rd <= 5'd4; // Store result in x4
//                    rf_WriteData <= alu_result;
//                    state <= S_ALU_SUB;
//                end

//                // SUB Operation 
//                S_ALU_SUB: begin 
//                    rf_WriteEnable <= 0;
//                    rf_rs1 <= 5'd1; rf_rs2 <= 5'd2;
//                    alu_control <= 4'b0001;
//                    state <= S_WRITE_SUB;
//                end

//                S_WRITE_SUB: begin 
//                    rf_WriteEnable <= 1; rf_rd <= 5'd5; // Store result in x5
//                    rf_WriteData <= alu_result;
//                    state <= S_ALU_AND;
//                end

//                // AND Operation 
//                S_ALU_AND: begin 
//                    rf_WriteEnable <= 0;
//                    rf_rs1 <= 5'd1; rf_rs2 <= 5'd2;
//                    alu_control <= 4'b0010;
//                    state <= S_WRITE_AND;
//                end

//                S_WRITE_AND: begin 
//                    rf_WriteEnable <= 1; rf_rd <= 5'd6; // Store result in x6
//                    rf_WriteData <= alu_result;
//                    state <= S_DONE;
//                end

//                S_DONE: begin
//                    rf_WriteEnable <= 0;
//                    state <= S_DONE;
//                end
                
//                default: state <= S_IDLE;
//            endcase
//        end
//    end

//    // Visualizing the lower bits of the current ALU result [cite: 85, 94]
//    assign leds = alu_result[15:0]; 

//    seven_segment u_7seg (
//        .clk(clk), .rst(reset_debounced),
//        .enable_refresh(enable_refresh),
//        .val(alu_result[15:0]),
//        .seg(seg), .an(an)
//    );

//endmodule




`timescale 1ns / 1ps

module top_lab7(
    input clk,
    input reset_btn,        
    input [15:0] switches,  
    output [15:0] leds,     
    output [6:0] seg,       
    output [3:0] an         
    );

    // =========================
    // Debounced Button
    // =========================
    wire write_enable;

    debouncer u_debouncer (
        .clk(clk),
        .pbin(reset_btn),
        .pbout(write_enable)   // one-pulse write enable
    );

    // =========================
    // ALU + Register File Wiring
    // =========================
    wire [31:0] rf_ReadData1;
    wire [31:0] rf_ReadData2;
    wire [31:0] alu_result;
    wire alu_zero;

    wire [4:0] rf_rs1;
    wire [4:0] rf_rs2;
    wire [4:0] rf_rd;
    wire [3:0] alu_control;

    // =========================
    // Switch Assignments
    // =========================

    // ALU operation
    assign alu_control = switches[2:0];

    // Source registers
    assign rf_rs1 = switches[7:3];
    assign rf_rs2 = switches[12:8];

    // Destination register (limit to x0-x7)
    assign rf_rd = {2'b00, switches[15:13]};

    // =========================
    // Register File
    // =========================
    RegisterFile u_regfile (
        .clk(clk),
        .rst(1'b0),                    // no reset clearing
        .WriteEnable(write_enable),    
        .rs1(rf_rs1),
        .rs2(rf_rs2),
        .rd(rf_rd),
        .WriteData(alu_result),
        .ReadData1(rf_ReadData1),
        .ReadData2(rf_ReadData2)
    );

    // =========================
    // ALU
    // =========================
    ALU_wrapper u_alu (
        .A(rf_ReadData1),
        .B(rf_ReadData2),
        .ALUControl(alu_control),
        .ALUResult(alu_result),
        .Zero(alu_zero)
    );

    // =========================
    // LEDs show ALU result
    // =========================
    assign leds = alu_result[15:0];

    // =========================
    // 7-Segment Display
    // =========================
    // Left 2 digits  = Write Data (upper byte)
    // Right 2 digits = ALU result (lower byte)

    wire [15:0] display_val;

    assign display_val[7:0]   = alu_result[7:0];      // right side
    assign display_val[15:8]  = alu_result[15:8];     // left side

    // If you instead want to show:
    // left = WriteData, right = ALU
    // change second line to:
    // assign display_val[15:8] = rf_ReadData1[7:0];

    // Refresh clock (reuse your divider)
    wire enable_refresh;

    clock_divider u_clkdiv (
        .clk(clk),
        .rst(1'b0),
        .enable_1hz(),          // unused
        .enable_refresh(enable_refresh)
    );

    seven_segment u_7seg (
        .clk(clk),
        .rst(1'b0),
        .enable_refresh(enable_refresh),
        .val(display_val),
        .seg(seg),
        .an(an)
    );

endmodule