`timescale 1ns / 1ps

module mbist_mem_mux #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH = 8,
    parameter integer DEPTH = 256
) (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire bist_busy,

    // Host port
    input wire host_req,
    input wire host_we,
    input wire [ADDR_WIDTH-1:0] host_addr,
    input wire [DATA_WIDTH-1:0] host_wdata,
    output wire host_ready,
    output wire host_rvalid,
    output wire [DATA_WIDTH-1:0] host_rdata,

    // MBIST port
    input wire bist_en,
    input wire bist_we,
    input wire [ADDR_WIDTH-1:0] bist_addr,
    input wire [DATA_WIDTH-1:0] bist_wdata,
    output reg [DATA_WIDTH-1:0] bist_rdata,

    // LUTRAM port
    output wire mem_en,
    output wire mem_we,
    output wire [ADDR_WIDTH-1:0] mem_addr,
    output wire [DATA_WIDTH-1:0] mem_wdata,
    input wire [DATA_WIDTH-1:0] mem_rdata
);

    wire host_accept;

    assign host_ready = rst_n && !start && !bist_busy && (host_addr < DEPTH);
    assign host_accept = host_req && host_ready;
    assign host_rvalid = host_accept && !host_we;
    assign host_rdata = mem_rdata;

    assign mem_en = rst_n && (bist_busy ? bist_en : host_accept);
    assign mem_we = bist_busy ? bist_we : host_we;
    assign mem_addr = bist_busy ? bist_addr : host_addr;
    assign mem_wdata = bist_busy ? bist_wdata : host_wdata;

    always @(posedge clk) begin
        if (!rst_n)
            bist_rdata <= {DATA_WIDTH{1'b0}};
        else if (bist_busy && bist_en && !bist_we)
            bist_rdata <= mem_rdata;
    end

endmodule
