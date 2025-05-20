module MIPS_uC(
	input wire 			sys_clk,
	input wire 			rst_sync,
	// input wire 			clk,
	// input wire 			rst,
	inout wire [31:0] 	port_io
);

	// constants
	parameter MARS_INSTRUCTION_OFFSET	= 32'h00000000;
	parameter MARS_DATA_OFFSET			= 32'h00000000;
	parameter PORT_ENABLE_ADDR			= 4'b0000;
	parameter PORT_CONFIG_ADDR			= 4'b0001;
	parameter PORT_DATA_ADDR			= 4'b0010;
	parameter PORT_INTERRUPT_ADDR		= 4'b0011;
	parameter PORT_COUNTER_ADDR			= 4'b0100;


	// CPU interface
	wire [31:0] 	data_address;
	wire [31:0] 	data_out;
	wire [31:0] 	data_in;
	wire 			ce;
	wire [3:0] 		wbe;
	wire [31:0]		instruction;
	wire [31:0]		instruction_address;
	wire			ack;
	wire 			irq;

	// data memory interface
	wire			ce_mem;
	wire [31:0]		data_out_mem;

	// decoder interface
	wire 			rw_decoder;
	wire [15:0]		rw_out;
	wire [15:0]		ce_out;
	wire [15:0]		irq_source;
	wire			ce_decoder;
	wire [3:0]		data_out_decoder;
	wire [3:0]		address_decoder;
	
	// timer interface
	wire 			time_out;
	wire [31:0]		data_in_timer;

	// portio interface
	wire [31:0]		data_in_portio;
	wire [31:0]		data_out_portio;
	wire [3:0]		address_portio;

	// clock manager interface
	// wire			sys_clk;

	// reset synchronyzer interface
	// wire			rst_sync;

	// data_in MIPS mux
	wire [31:0]		data_in_periph;

	// inverted clock
	wire 			sys_clk_n;

	// intermediate wire assignments
	// decoder 
	assign rw_decoder 		= (|wbe);
	assign ce_decoder 		= ce && data_address[31];
	assign address_decoder 	= data_address[11:8];
	// portio
	// assign data_in_portio 	= data_out;
	assign address_portio 	= data_address[7:4];
	// data_in CPU
	assign data_in_periph 	= (rw_out[15] == 1'b0) ? data_out_portio : data_out_decoder;
	assign data_in 			= (data_address[31] == 1'b1) ? data_in_periph : data_out_mem;
	// data_in TIMER
	assign data_in_timer 	= data_out;
	// data memory
	assign ce_mem 			= ce && ~data_address[31];
	// clock
	assign sys_clk_n		= ~sys_clk;

	// modules instantiation

	// MIPS CPU
	MIPS_monocycle #(
		.PC_START_ADDRESS	(MARS_INSTRUCTION_OFFSET)
	) mips_instance (
		.clk                 (sys_clk),
		.rst                 (rst_sync),
		.intr                (irq),
		.instructionAddress  (instruction_address),    
		.instruction         (instruction),        
		.dataAddress         (data_address),
		.data_in             (data_in),
		.data_out            (data_out),
		.ce                  (ce),
		.wbe                 (wbe),
		.ack				 (ack)
	);

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

	Decoder #(
		.DATA_WIDTH			(32),
		.DATA_WIDTH_MIPS	(32)
	) decoder_instance (
		.clk				(sys_clk_n),
        .rst				(rst_sync),
        .address			(address_decoder),
        .data_out			(data_out_decoder),
        .rw					(rw_decoder),
        .ce					(ce_decoder),
        .ce_out				(ce_out),
        .rw_out				(rw_out),
        .irq				(irq),
        .irq_source			(irq_source),
        .ack				(ack)
	);

	BidirectionalPort #(
        .DATA_WIDTH         (32),
        .PORT_DATA_ADDR     (PORT_DATA_ADDR),
        .PORT_CONFIG_ADDR   (PORT_CONFIG_ADDR),
        .PORT_ENABLE_ADDR   (PORT_ENABLE_ADDR),
        .PORT_INTERRUPT_ADDR(PORT_INTERRUPT_ADDR),
		.PORT_COUNTER_ADDR	(PORT_COUNTER_ADDR)
	) gp_port_io (
        .clk				(sys_clk),
        .rst             	(rst_sync),
        .data_in			(data_out),
        .data_out			(data_out_portio),
        .address			(address_portio),
        .rw					(rw_out[0]),
        .ce					(ce_out[0]),
        .irq				(irq_source[0]),
        .port_io			(port_io)
    );

	Timer #(
		.DATA_WIDTH			(32)
	) timer_instance (
		.clk				(sys_clk),
        .rst				(rst_sync),
        .data				(data_in_timer),
        .rw					(rw_out[1]),
        .ce					(ce_out[1]),
        .time_out			(irq_source[1])
	);

	// ClockManager clk_mgr (
    //     .clk_100MHz			(clk),
    //     .clk_25MHz			(sys_clk)
    // );

    // ResetSynchonizer rst_synchronizer (
    //     .clk				(sys_clk),
    //     .rst_in				(rst),
    //     .rst_out			(rst_sync)
    // );

endmodule