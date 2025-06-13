`default_nettype none

module bus_arbitrer #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
    // mips controller port
    input wire      mips_ce,
    input wire      mips_rw,        // 0 for read, 1 for write
    // dma controller port
    input wire      dma_io,         // DMA request
    input wire      dma_write,      // 0 for read, 1 for write
    // data inputs
    input wire [DATA_WIDTH-1:0]     mips_data_out,
    input wire [DATA_WIDTH-1:0]     mem_data_out,       // Data from memory/peripheral for the DMA to write
    input wire [ADDR_WIDTH-1:0]     dma_address,
    input wire [ADDR_WIDTH-1:0]     mips_data_address,
    // bus outputs
    output reg [ADDR_WIDTH-1:0]     bus_addr,
    output reg [DATA_WIDTH-1:0]     bus_data,
    // sel signals output
    output reg      sel_controller_dma,
    output reg      sel_controller_mips
);

    // This combinational block determines who controls the bus in a prioritized manner
    always @* begin
        // --- Step 1: Define a safe default state ---
        // By default, no controller is selected and the bus outputs are high-impedance.
        // This is crucial to prevent bus conflicts and inferred latches.
        sel_controller_mips = 1'b0;
        sel_controller_dma  = 1'b0;
      bus_addr            = {ADDR_WIDTH{1'b0}}; // High-impedance
      bus_data            = {DATA_WIDTH{1'b0}}; // High-impedance

        // --- Step 2: Implement the priority logic ---
        // The MIPS processor has the highest priority. If it asserts its chip enable, it gets the bus.
        if (mips_ce == 1'b1) begin
            sel_controller_mips = 1'b1;
            bus_addr            = mips_data_address;
            
            if (mips_rw == 1'b1) begin
                // MIPS Write: Drive the MIPS data onto the bus
                bus_data        = mips_data_out;
            end
            // For a MIPS Read (mips_rw == 0), bus_data remains high-Z,
            // allowing the selected slave device (memory/peripheral) to drive its data.
        end
        // If MIPS is not active, check if the DMA is requesting the bus.
        else if (dma_io == 1'b1) begin
            sel_controller_dma  = 1'b1;
            bus_addr            = dma_address;

            if (dma_write == 1'b1) begin
                // DMA Write: Drive the DMA's data onto the bus.
                // NOTE: Assuming `mem_data_out` is the data the DMA wants to write to a peripheral.
                // A better port name would be `dma_data_out`.
                bus_data        = mem_data_out;
            end
            // For a DMA Read (dma_write == 0), bus_data remains high-Z,
            // allowing the selected slave device to drive its data.
        end
    end

endmodule