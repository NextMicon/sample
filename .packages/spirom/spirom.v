module spirom (
    input wire clk,
    input wire resetn,

    input wire valid,
    output wire ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output wire [31:0] rdata,

    input wire cfg_valid,
    output wire cfg_ready,
    input wire [3:0] cfg_wstrb,
    input wire [31:0] cfg_addr,
    input wire [31:0] cfg_wdata,
    output wire [31:0] cfg_rdata,

    inout wire flash_csb,
    inout wire flash_clk,

    output wire flash_io0_iosel,
    input  wire flash_io0_in,
    output wire flash_io0_out,

    output wire flash_io1_iosel,
    input  wire flash_io1_in,
    output wire flash_io1_out,

    output wire flash_io2_iosel,
    input  wire flash_io2_in,
    output wire flash_io2_out,

    output wire flash_io3_iosel,
    input  wire flash_io3_in,
    output wire flash_io3_out
);

  assign cfg_ready = cfg_valid;

  spimemio rom (
      .clk   (clk),
      .resetn(resetn),

      .valid(valid),
      .ready(ready),
      .addr (addr[23:0]),
      .rdata(rdata),

      .cfgreg_we(cfg_wstrb),
      .cfgreg_di(cfg_wdata),
      .cfgreg_do(cfg_rdata),

      .flash_csb(flash_csb),
      .flash_clk(flash_clk),

      .flash_io0_oe(flash_io0_iosel),
      .flash_io0_di(flash_io0_in),
      .flash_io0_do(flash_io0_out),

      .flash_io1_oe(flash_io1_iosel),
      .flash_io1_di(flash_io1_in),
      .flash_io1_do(flash_io1_out),

      .flash_io2_oe(flash_io2_iosel),
      .flash_io2_di(flash_io2_in),
      .flash_io2_do(flash_io2_out),

      .flash_io3_oe(flash_io3_iosel),
      .flash_io3_di(flash_io3_in),
      .flash_io3_do(flash_io3_out)
  );

endmodule
