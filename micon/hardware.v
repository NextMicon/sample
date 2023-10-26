module hardware (
    input  fpga_clk,
    inout  fpga_flash_csb,
    inout  fpga_flash_clk,
    inout  fpga_flash_io0,
    inout  fpga_flash_io1,
    inout  fpga_flash_io2,
    inout  fpga_flash_io3,
/* iopin */
    input  pin1,
    output pin2,
    inout  pin3,
    output led1,
    output led2,
    input  pin11
/* end */
);

/* iobuffer */
tristate pin3_iobuf(
    .pin(pin3),
    .iosel(led_IOSEL),
    .out(led_OUT),
    .in(pin3_in)
);
/* end */

  ///////////////////////////////////
  // Wire Deffinitions

  wire clk = fpga_clk;
  wire resetn;

  ///////////////////////////////////
  // Parameters

  parameter integer MEM_WORDS = 2048;
  parameter [31:0] STACKADDR = (4 * MEM_WORDS);  // end of memory
  parameter [31:0] PROGADDR_RESET = 32'h0005_0000;  // 1 MB into flash
  parameter [31:0] PROGADDR_IRQ = 32'h0005_0010;  // 1 MB into flash

/* parameters */
/* end */

  ///////////////////////////////////
  // Interrupts Request

  reg [31:0] irq;
  always @* begin
    if (!resetn) irq <= 0;
    else begin
      irq = 0;
/* irq */
      irq3 <= pin11_in;
/* end */
    end
  end

  ///////////////////////////////////
  // CPU

  picorv32 #(
      .STACKADDR(STACKADDR),
      .PROGADDR_RESET(PROGADDR_RESET),
      .PROGADDR_IRQ(PROGADDR_IRQ),
      .BARREL_SHIFTER(1),
      .COMPRESSED_ISA(1),
      .ENABLE_MUL(1),
      .ENABLE_DIV(1),
      .ENABLE_IRQ(1),
      .ENABLE_IRQ_QREGS(1)
  ) cpu (
      .clk      (clk),
      .resetn   (resetn),
      .mem_valid(mem_valid),
      .mem_ready(mem_ready),
      .mem_addr (mem_addr),
      .mem_wdata(mem_wdata),
      .mem_wstrb(mem_wstrb),
      .mem_rdata(mem_rdata),
      .irq      (irq)
  );

  ///////////////////////////////////
  // Memory map interface

  wire mem_valid;
  wire mem_ready;
  wire [3:0] mem_wstrb;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [31:0] mem_rdata;
  assign mem_ready = |{ram_ready, rom_ready, rom_cfg_ready,
/* mem_ready */

/* end */};
  assign mem_rdata = ram_ready ? ram_rdata : rom_ready ? rom_rdata : rom_cfg_ready ? rom_cfg_rdata
/* mem_rdata */

/* end */ : 32'b0;

  ///////////////////////////////////
  // Modules

  por por (
      .clk(clk),
      .resetn(resetn)
  );

  ram #(
      .WORDS(MEM_WORDS)
  ) ram (
      .clk(clk),
      .resetn(resetn),
      .valid(ram_valid),
      .ready(ram_ready),
      .wstrb(ram_valid ? mem_wstrb : 4'b0),
      .addr(mem_addr),
      .wdata(mem_wdata),
      .rdata(ram_rdata)
  );
  wire ram_sel = mem_addr[31:14] == 19'h0;
  wire ram_valid = mem_valid && ram_sel;
  wire ram_ready;
  wire [31:0] ram_rdata;

  spirom rom (
      .clk(clk),
      .resetn(resetn),
      .valid(rom_valid),
      .ready(rom_ready),
      .wstrb(rom_valid ? mem_wstrb : 4'b0),
      .addr (mem_addr),
      .wdata(mem_wdata),
      .rdata(rom_rdata),
      .cfg_valid(rom_cfg_valid),
      .cfg_ready(rom_cfg_ready),
      .cfg_wstrb(rom_cfg_valid ? mem_wstrb : 4'b0),
      .cfg_addr (mem_addr),
      .cfg_wdata(mem_wdata),
      .cfg_rdata(rom_cfg_rdata),
      .flash_io0_iosel(flash_io0_iosel),
      .flash_io0_in   (flash_io0_in),
      .flash_io0_out  (flash_io0_out),
      .flash_io1_iosel(flash_io1_iosel),
      .flash_io1_in   (flash_io1_in),
      .flash_io1_out  (flash_io1_out),
      .flash_io2_iosel(flash_io2_iosel),
      .flash_io2_in   (flash_io2_in),
      .flash_io2_out  (flash_io2_out),
      .flash_io3_iosel(flash_io3_iosel),
      .flash_io3_in   (flash_io3_in),
      .flash_io3_out  (flash_io3_out),
      .flash_csb(fpga_flash_csb),
      .flash_clk(fpga_flash_clk)
  );
  wire rom_sel = (mem_addr[31:20] == 12'h000) && (4'h5 <= mem_addr[19:16]);
  wire rom_valid = mem_valid && rom_sel;
  wire rom_ready;
  wire [31:0] rom_rdata;
  wire rom_cfg_sel = mem_addr[31:24] == 8'h02;
  wire rom_cfg_valid = mem_valid && rom_cfg_sel;
  wire rom_cfg_ready;
  wire [31:0] rom_cfg_rdata;
  wire flash_io0_iosel;
  wire flash_io0_in;
  wire flash_io0_out;
  wire flash_io1_iosel;
  wire flash_io1_in;
  wire flash_io1_out;
  wire flash_io2_iosel;
  wire flash_io2_in;
  wire flash_io2_out;
  wire flash_io3_iosel;
  wire flash_io3_in;
  wire flash_io3_out;
  tristate flash_io0_iobuf (
      .pin  (fpga_flash_io0),
      .iosel(flash_io0_iosel),
      .in   (flash_io0_in),
      .out  (flash_io0_out)
  );
  tristate flash_io1_iobuf (
      .pin  (fpga_flash_io1),
      .iosel(flash_io1_iosel),
      .in   (flash_io1_in),
      .out  (flash_io1_out)
  );
  tristate flash_io2_iobuf (
      .pin  (fpga_flash_io2),
      .iosel(flash_io2_iosel),
      .in   (flash_io2_in),
      .out  (flash_io2_out)
  );
  tristate flash_io3_iobuf (
      .pin  (fpga_flash_io3),
      .iosel(flash_io3_iosel),
      .in   (flash_io3_in),
      .out  (flash_io3_out)
  );

/* instances */
UART  #(
) serial (
.clk(clk),
.resetn(resetn),
.valid(serial_valid),
.ready(serial_ready),
.wstrb(serial_valid ? mem_wstrb : 4'b0),
.addr (mem_addr),
.wdata(mem_wdata),
.rdata(serial_rdata),
.RX(0),
.TX(serial_TX)
);
wire serial_sel = mem_addr[31:24] == 8'h3;
wire serial_valid = mem_valid && serial_sel;
wire serial_ready;
wire [31:0] serial_rdata;
wire serial_TX;

GPIO  #(
) led (
.clk(clk),
.resetn(resetn),
.valid(led_valid),
.ready(led_ready),
.wstrb(led_valid ? mem_wstrb : 4'b0),
.addr (mem_addr),
.wdata(mem_wdata),
.rdata(led_rdata),
.IOSEL(led_IOSEL),
.OUT(led_OUT),
.IN(pin3_in)
);
wire led_sel = mem_addr[31:24] == 8'h4;
wire led_valid = mem_valid && led_sel;
wire led_ready;
wire [31:0] led_rdata;
wire led_IOSEL;
wire led_OUT;

PWM  #(
) pwm (
.clk(clk),
.resetn(resetn),
.valid(pwm_valid),
.ready(pwm_ready),
.wstrb(pwm_valid ? mem_wstrb : 4'b0),
.addr (mem_addr),
.wdata(mem_wdata),
.rdata(pwm_rdata),
.OUT(pwm_OUT)
);
wire pwm_sel = mem_addr[31:24] == 8'h5;
wire pwm_valid = mem_valid && pwm_sel;
wire pwm_ready;
wire [31:0] pwm_rdata;
wire pwm_OUT;
/* end */

endmodule
