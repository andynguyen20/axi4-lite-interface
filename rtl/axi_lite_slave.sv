`timescale 1ns / 1ps

module axi_lite_slave(
    //Global Signals
    input logic aclk,
    input logic aresetn,
    
    //Read Address Channel
    input logic [31:0] s_axi_araddr,
    input logic [2:0] s_axi_arprot,
    input logic s_axi_arvalid,
    output logic s_axi_arready,
    
    //Read Data Channel
    output logic [31:0] s_axi_rdata,
    output logic [1:0] s_axi_rresp,
    output logic s_axi_rvalid,
    input logic s_axi_rready, 
    
    //Write Address Channel
    input logic [31:0] s_axi_awaddr,
    input logic [2:0] s_axi_awprot,
    input logic s_axi_awvalid,
    output logic s_axi_awready,
    
    //Write Data Channel
    input logic [31:0] s_axi_wdata,
    input logic [3:0] s_axi_wstrb,
    input logic s_axi_wvalid,
    output logic s_axi_wready,
    
    //Write Response Channel
    output logic [1:0] s_axi_bresp,
    output logic s_axi_bvalid,
    input logic s_axi_bready
    );
    
    reg [31:0] rfile[3:0];
    
    logic [1:0] windex = s_axi_awaddr[3:2];  // 4 regs at 0x0,0x4,0x8,0xC
    
    logic aw_hs;
    logic w_hs;
    logic ar_hs;
    logic r_hs;
    logic b_hs;
    
    assign aw_hs = s_axi_awvalid && s_axi_awready;
    assign w_hs = s_axi_wvalid && s_axi_wready;
    assign ar_hs = s_axi_arvalid && s_axi_arready;
    assign r_hs =s_axi_rvalid && s_axi_rready;
    assign b_hs = s_axi_bvalid && s_axi_bready;
    
    assign s_axi_awready = 1'b1; 
    assign s_axi_wready = 1'b1;
    assign s_axi_arready = 1'b1;
    
    always_ff @(posedge aclk) begin
        if(~aresetn) begin
            s_axi_arready <= 1'b0;
            s_axi_rdata <= 32'b0;
            s_axi_rresp <= 2'b0;
            s_axi_rvalid <= 1'b0;
            s_axi_awready <= 1'b0;
            s_axi_wready <= 1'b0;
            s_axi_bresp <= 2'b00;
            s_axi_bvalid <= 1'b0;
        end
        else begin
        end
     end
            
             
        
endmodule
