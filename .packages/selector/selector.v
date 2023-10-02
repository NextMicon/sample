module selector (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    input  wire in0,
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);
  reg [3:0] sel_reg;

  always @(posedge clk) begin
    if (!resetn) begin
      sel_reg <= 0;
    end else begin
      ready <= valid;
      rdata <= {sel_reg, 31'b0};
      if (wstrb[0]) sel_reg <= wdata[N-1:0];
    end
  end

  assign out = sel_reg[0] ? in0 : sel_reg[1] ? in1 : sel_reg[2] ? in2 : sel_reg[3] ? in3 : 0;

endmodule
