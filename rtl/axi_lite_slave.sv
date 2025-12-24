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
    
    reg [31:0] reg_file[3:0];
    
    logic aw_hs;
    logic w_hs;
    logic b_hs;
    
    assign aw_hs = s_axi_awvalid && s_axi_awready;
    assign w_hs = s_axi_wvalid && s_axi_wready;
    assign b_hs = s_axi_bvalid && s_axi_bready;
    
    assign s_axi_awready = 1'b1; 
    assign s_axi_wready = 1'b1;
    
    logic [31:0] awaddr_buf;
    logic [31:0] wdata_buf;
    logic [31:0] wdata_mask;
    logic [3:0] wstrb_buf;
    
    logic aw_pending;
    logic w_pending;
    
    logic [1:0] aw_index;
    assign aw_index = awaddr_buf[3:2];  // 4 regs at 0x0,0x4,0x8,0xC
    
    always_comb begin                       //write strobe logic
        wdata_mask = 32'b0;
        for(int i = 0; i < 4; i++) begin
            wdata_mask[i*8 +: 8] = {8{wstrb_buf[i]}};
        end
     end
    
    always_ff @(posedge aclk) begin
        if(~aresetn) begin
            s_axi_arready <= 1'b0;
            s_axi_rdata <= 32'b0;
            s_axi_rresp <= 2'b0;
            s_axi_rvalid <= 1'b0;
            s_axi_bresp <= 2'b00;
            s_axi_bvalid <= 1'b0;
            aw_pending <= 1'b0;
            w_pending <= 1'b0;
        end
        else begin
            if(aw_hs) begin                 // write logic
                awaddr_buf <= s_axi_awaddr;
                aw_pending <= 1'b1;
            end
            if(w_hs) begin
                wdata_buf <= s_axi_wdata;
                wstrb_buf <= s_axi_wstrb;
                w_pending <= 1'b1;
            end
            if(aw_pending && w_pending && !s_axi_bvalid) begin
            end
        end
     end
            
             
        
endmodule