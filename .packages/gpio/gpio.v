module gpio (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    output reg  io_iosel,
    output reg  io_out,
    input  wire io_in
);

  always @(posedge clk) begin
    if (!resetn) begin
      io_iosel <= 0;
      io_out   <= 0;
    end else begin
      ready <= valid;
      (* full_case *)
      case (addr[3:2])
        2'b00: begin  // 0x...0
          rdata <= io_iosel;
          if (wstrb[0]) io_iosel <= wdata[0];
        end
        2'b01: begin  // 0x...4
          rdata <= io_out;
          if (wstrb[0]) io_out <= wdata[0];
        end
        2'b10: begin  // 0x...8
          rdata <= io_in;
        end
      endcase
    end
  end

endmodule
