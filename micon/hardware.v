module hardware (
    input  fpga_clk,
    inout  fpga_flash_csb,
    inout  fpga_flash_clk,
    inout  fpga_flash_io0,
    inout  fpga_flash_io1,
    inout  fpga_flash_io2,
    inout  fpga_flash_io3,
    /* iopin */
    input  fpga_pin11,
    input  fpga_pin2,
    output fpga_pin1,
    output fpga_user_led,
    output fpga_pin24,
    output fpga_pin23,
    output fpga_pin22,
    output fpga_pin21
    /* end */
);

  /* iopin_assign */
  assign fpga_pin1 = serial_tx;
  assign fpga_user_led = sel_out;
  assign fpga_pin24 = dac_cs;
  assign fpga_pin23 = dac_scl;
  assign fpga_pin22 = dac_sdi;
  assign fpga_pin21 = dac_ldac;
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
      irq[5] = fpga_pin11;
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
  assign mem_ready = |{ram_ready, rom_ready, rom_cfg_ready,  /* mem_ready */
      serial_ready,gpio_ready,pwm_ready,sel_ready,square1_ready,square2_ready,square3_ready,sawtooth_ready,triangle_ready,mixier_ready,sampling_ready,dac_ready
      /* end */};
  assign mem_rdata = ram_ready ? ram_rdata : rom_ready ? rom_rdata : rom_cfg_ready ? rom_cfg_rdata /* mem_rdata */
      : serial_ready ? serial_rdata : gpio_ready ? gpio_rdata : pwm_ready ? pwm_rdata : sel_ready ? sel_rdata : square1_ready ? square1_rdata : square2_ready ? square2_rdata : square3_ready ? square3_rdata : sawtooth_ready ? sawtooth_rdata : triangle_ready ? triangle_rdata : mixier_ready ? mixier_rdata : sampling_ready ? sampling_rdata : dac_ready ? dac_rdata
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
UART serial (

);

GPIO led (

);

PWM pwm (

);
/* end */

endmodule
