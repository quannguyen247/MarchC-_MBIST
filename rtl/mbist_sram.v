`timescale 1ns / 1ps

module mbist_sram #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH = 8,
    parameter integer DEPTH = 256
) (
    input wire clk,
    input wire en,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] wdata,
    output wire [DATA_WIDTH-1:0] rdata
);

    (* ram_style = "distributed" *) reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (en && we)
            mem[addr] <= wdata;
    end

    assign rdata = mem[addr];

endmodule
