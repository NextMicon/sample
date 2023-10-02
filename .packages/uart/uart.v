module uart (
    input wire clk,
    input wire resetn,

    input wire valid,
    output wire ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output wire [31:0] rdata,

    output tx,
    input  rx
);

  assign ready = |{div_ready, dat_ready};
  assign rdata = div_ready ? div_rdata : dat_ready ? dat_rdata : 32'h0000_0000;

  simpleuart uart (
      .clk   (clk),
      .resetn(resetn),

      .reg_div_we(div_valid ? wstrb : 4'b0),
      .reg_div_di(wdata),
      .reg_div_do(div_rdata),

      .reg_dat_we  (dat_wstrb),
      .reg_dat_re  (dat_valid && !dat_wstrb),
      .reg_dat_di  (wdata),
      .reg_dat_do  (dat_rdata),
      .reg_dat_wait(reg_dat_wait),

      .ser_tx(tx),
      .ser_rx(rx)
  );

  wire div_valid = valid && addr[2] == 1'b0;
  wire div_ready = div_valid;
  wire [31:0] div_rdata;

  wire reg_dat_wait;
  wire dat_valid = valid && addr[2] == 1'b1;
  wire dat_ready = dat_valid && !reg_dat_wait;
  wire dat_wstrb = dat_valid ? wstrb[0] : 1'b0;
  wire [31:0] dat_rdata;

endmodule
