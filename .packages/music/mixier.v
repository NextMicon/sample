//////////////////////////////////////////////////////////////////
// Mixier ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//        : _   _  :_   _   _   _   _   _   _  :_   _  :_   _   //
// clk    :  |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_ //
//        :        :                           :       :        //
// state  :  out   | add                       | out   | add    //
// ch_cnt :        | 0         |...| NCH-1     |       :        //
// cnt    :  0 | 1 | 0 | 1 | 2 |...| 0 | 1 | 2 |       :        //
//        :        :           :               :       :        //
//       [I]      [N]         [N]             [O] [R] [S]       //
//////////////////////////////////////////////////////////////////

module mixier #(
    parameter N_CH = 8,  // チャンネル数 (0~8)
    parameter CALC_CNT = 2  // 計算に必要な待ち時間 (0~15)
) (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    input wire [7:0] ch0,
    input wire [7:0] ch1,
    input wire [7:0] ch2,
    input wire [7:0] ch3,
    input wire [7:0] ch4,
    input wire [7:0] ch5,
    input wire [7:0] ch6,
    input wire [7:0] ch7,

    output reg [11:0] out
);

  wire [7:0] ch[8];
  assign ch[0] = ch0;
  assign ch[1] = ch1;
  assign ch[2] = ch2;
  assign ch[3] = ch3;
  assign ch[4] = ch4;
  assign ch[5] = ch5;
  assign ch[6] = ch6;
  assign ch[7] = ch7;

  reg [3:0] vol[8];
  integer i;
  always @(posedge clk) begin
    if (!resetn) begin
      for (i = 0; i < 4; i = i + 1) begin
        vol[i] <= 4'b0;
      end
    end else begin
      ready <= valid;
      rdata <= vol[addr[4:2]];
      if (wstrb[0]) vol[addr[4:2]] <= wdata[3:0];
    end
  end

  reg state;
  parameter state_add = 1'b1;
  parameter state_out = 1'b0;
  reg [3:0] ch_cnt;
  reg [3:0] cnt;
  reg [11:0] tmp;
  wire [11:0] calc = (ch[ch_cnt] << vol[ch_cnt]) + tmp;

  always @(posedge clk) begin
    if (!resetn) begin  // [I] Initialize
      state <= state_add;
      ch_cnt <= 0;
      cnt <= 0;
      tmp <= 0;
      out <= 0;
    end else begin
      case (state)
        state_add: begin
          case (cnt == CALC_CNT - 1)
            0: begin
              cnt <= cnt + 1;
            end
            1: begin  // [N] Next Count
              tmp <= calc;
              case (ch_cnt == N_CH - 1)
                0: begin
                  ch_cnt <= ch_cnt + 1;
                  cnt <= 0;
                end
                1: begin  // [O] Output result
                  state <= state_out;
                end
              endcase
            end
          endcase
        end
        state_out: begin
          out <= tmp;
          state <= state_add;
          ch_cnt <= 0;
          cnt <= 0;
          tmp <= 0;
        end
      endcase
    end
  end

endmodule
