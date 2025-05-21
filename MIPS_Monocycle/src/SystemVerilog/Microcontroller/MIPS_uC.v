module MIPS_uC(
	//input wire 			sys_clk,
	//input wire 			rst_sync,
	input wire 				clk,
	input wire 				rst,
	inout wire [31:0] 		port_io
);

	//////////////////////////////////////////////////////////////////////
	// parameters

	// offset das memoricas
	parameter MARS_INSTRUCTION_OFFSET	= 32'h00000000;
	parameter MARS_DATA_OFFSET			= 32'h00000000;
	// endereco dos registradores da porta de E/S
	parameter PORT_ENABLE_ADDR			= 4'b0000;
	parameter PORT_CONFIG_ADDR			= 4'b0001;
	parameter PORT_DATA_ADDR			= 4'b0010;
	parameter PORT_INTERRUPT_ADDR		= 4'b0011;
	parameter PORT_COUNTER_ADDR			= 4'b0100;
	// endereco dos registradores do controlador de interrupcoes
	parameter IRQ_ID_ADDR				= 2'b00;
	parameter MASK_ADDR					= 2'b01;
	parameter INT_ACK_ADDR				= 2'b10;
	// endereco dos perifericos
	parameter PORT_CONFIG_ADDR			= 4'b0000;
	parameter TIMER_ADDR				= 4'b0001;
	parameter INTR_CTRL_ADDR			= 4'b0010;
	parameter PERIPH_CONTR				= 4'b1111;
	//////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////
	// interface wires

	// CPU interface
	wire [31:0] 	data_address;
	wire [31:0] 	data_out;
	wire [31:0] 	data_in;
	wire 			ce;
	wire [3:0] 		wbe;
	wire [31:0]		instruction;
	wire [31:0]		instruction_address;
	wire 			intr;

	// data memory interface
	wire			ce_mem;
	wire [31:0]		data_out_mem;

	// peripheral controller interface
	wire 			rw_ctrl;
	wire [15:0]		rw_out;
	wire [15:0]		ce_out;
	wire [31:0]		data_from_periph;
	wire [31:0]		data_periph;
	wire [3:0]		address_reg;
	wire [31:0]		data_out_ctrl;
	

	// controlador interrupcoes interface
	wire [7:0]		irq;

	// clock manager interface
	wire			sys_clk;

	// reset synchronyzer interface
	wire			rst_sync;

	// negative clock
	wire 			sys_clk_n;
	//////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////
	// intermediate wire assignments
	// data in cpu
	assign data_in = (address[31]) ? data_out_ctrl : data_out_mem;
	// decoder 
	assign rw_ctrl 		= (|wbe);
	// data memory
	assign ce_mem 			= ce && ~data_address[31];
	// clock
	assign sys_clk_n		= ~sys_clk;
	//////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////
	// modules instantiation

	// MIPS CPU instance
	MIPS_monocycle #(
		.PC_START_ADDRESS	(MARS_INSTRUCTION_OFFSET)
	) mips_instance (
		.clk                (sys_clk),
		.rst                (rst_sync),
		.intr               (intr),
		.instructionAddress (instruction_address),    
		.instruction        (instruction),        
		.dataAddress        (data_address),
		.data_in            (data_in),
		.data_out           (data_out),
		.ce                 (ce),
		.wbe                (wbe)
	);

	// instruction memory instance
	Memory #(
		.SIZE				(2048),
		.ADDR_WIDTH			(30),
		.COL_WIDTH			(8),
		.NB_COL				(4),
		.OFFSET				(MARS_INSTRUCTION_OFFSET),
		.imageFileName		("code.txt")
	) instruction_memory (
		.data_out			(instruction),
		.address			(instruction_address[31:2]),
		.clk				(sys_clk),
		.ce					(1'b1),
		.wbe				(4'b0000),
		.data_in			(32'b0)
	);

	// data memory instance
	Memory #(
		.SIZE				(2048),
		.ADDR_WIDTH			(30),
		.COL_WIDTH			(8),
		.NB_COL				(4),
		.OFFSET				(MARS_DATA_OFFSET),
		.imageFileName		("data.txt")
	) data_memory (
		.data_out			(data_out_mem),
		.address			(data_address[31:2]),
		.clk				(sys_clk_n),
		.ce					(ce_mem),
		.wbe				(wbe),
		.data_in			(data_out)
	);

	// peripheral controller instance
	peripheral_controller #(
		.DATA_WIDTH			(32),
		.PERIPH_1_ADDR		(PORT_IO_ADDR),
		.PERIPH_2_ADDR		(TIMER_ADDR),
		.PERIPH_3_ADDR		(INTR_CTRL_ADDR)
	) peripheral_controller_instance (
        .address			(address),
        .rw					(rw_ctrl),
        .ce					(ce),
		.data_from_periph	(data_periph),
		.data_from_mips		(data_out),
        .ce_out				(ce_out),
        .rw_out				(rw_out),
		.data_to_periph		(data_periph),
		.data_to_mips		(data_out_ctrl),
		.address_reg		(address_reg)
	);

	// port i/o instance
	BidirectionalPort #(
        .DATA_WIDTH         (32),
        .PORT_DATA_ADDR     (PORT_DATA_ADDR),
        .PORT_CONFIG_ADDR   (PORT_CONFIG_ADDR),
        .PORT_ENABLE_ADDR   (PORT_ENABLE_ADDR),
        .PORT_INTERRUPT_ADDR(PORT_INTERRUPT_ADDR),
		.PORT_COUNTER_ADDR	(PORT_COUNTER_ADDR)
	) port_io_instance (
        .clk				(sys_clk),
        .rst             	(rst_sync),
        .data				(data_periph),
        .address			(address_reg),
        .rw					(rw_out[0]),
        .ce					(ce_out[0]),
        .irq				(irq[15:12]),
        .port_io			(port_io)
    );

	// timer instance
	Timer #(
		.DATA_WIDTH			(32)
	) timer_instance (
		.clk				(sys_clk),
        .rst				(rst_sync),
        .data				(data_periph),
        .rw					(rw_out[1]),
        .ce					(ce_out[1]),
        .time_out			(irq[0])
	);

	// PIC instance
	InterruptController #(
		.IRQ_ID_ADDR		(IRQ_ID_ADDR),
		.MASK_ADDR			(MASK_ADDR),
		.INT_ACK_ADDR		(INT_ACK_ADDR)
	) PIC (
		.clk				(sys_clk),
		.rst				(rst_sync),
		.data				(data_periph),
		.address			(address_reg[1:0]),
		.rw					(rw_out[2]),
		.ce					(ce_out[2]),
		.intr				(intr),
		.irq				(irq)
	);

	// clock manager instance
	ClockManager clk_mgr (
        .clk_100MHz			(clk),
        .clk_10MHz			(sys_clk)
	);

	// reset synchronizer instance
	ResetSynchonizer rst_synchronizer (
        .clk				(sys_clk),
        .rst_in				(rst),
        .rst_out			(rst_sync)
	);
	//////////////////////////////////////////////////////////////////////

endmodule