-------------------------------------------------------------------------
-- Design unit: MIPS_monocycle
-- Description: Behavioral processor description
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_pkg.all;

entity MIPS_monocycle is
    generic (
        PC_START_ADDRESS    : UNSIGNED(31 downto 0) := (others=>'0') -- First instruction address
    );
    port ( 
        clk, rst            : in std_logic;
        
        -- Interupt interface
        intr 		    : in std_logic;
        
        -- Instruction memory interface
        instructionAddress  : out std_logic_vector(31 downto 0);
        instruction         : in  std_logic_vector(31 downto 0);
        
        -- Data memory interface
        dataAddress         : out std_logic_vector(31 downto 0);
        data_in             : in  std_logic_vector(31 downto 0);      
        data_out            : out std_logic_vector(31 downto 0);
        ce                  : out std_logic;
        wbe                 : out std_logic_vector(3 downto 0)
    );
end MIPS_monocycle;

architecture behavioral of MIPS_monocycle is

    signal pc, readData2, writeData, instructionFetchAddress: UNSIGNED(31 downto 0);
    signal signExtended, zeroExtended : UNSIGNED(31 downto 0);
    signal ALUoperand1, ALUoperand2, result: UNSIGNED(31 downto 0);
    signal result64b : UNSIGNED(63 downto 0);
    signal HI, LO : UNSIGNED(31 downto 0);
    signal branchOffset, branchTarget, jumpTarget: UNSIGNED(31 downto 0);
    signal writeRegister   : UNSIGNED(4 downto 0);
    signal regWrite : std_logic;
    signal selectedByte : std_logic_vector(7 downto 0);
    signal selectedByteExtended : UNSIGNED(31 downto 0);
    signal selectedHalfWord : std_logic_vector(15 downto 0);
    signal selectedHalfWordExtended : UNSIGNED(31 downto 0);
    -- Suporte a interrupção 
    signal interruptionTreatment : std_logic := '0';

    -- signal nextPc : UNSIGNED(31 downto 0);
    -- constant ISR_ADDR : UNSIGNED(31 downto 0) := x"000000FF";  
    
    -- Register file
    type RegisterArray is array (natural range <>) of UNSIGNED(31 downto 0);
    signal registerFile: RegisterArray(0 to 31);
    
    -- Alias to the instruction fields
    alias instruction_rs    : std_logic_vector(4 downto 0) is instruction(25 downto 21); 
    alias instruction_rt    : std_logic_vector(4 downto 0) is instruction(20 downto 16);        
    alias instruction_rd    : std_logic_vector(4 downto 0) is instruction(15 downto 11);
    alias instruction_shamt : std_logic_vector(4 downto 0) is instruction(10 downto 6);
    alias instruction_imm   : std_logic_vector(15 downto 0) is instruction(15 downto 0);
       
    -- ALU zero flag
    signal zero : std_logic;
    
    -- Locks the processor until the first clk rising edge
    signal lock: boolean;

    -- Coprocessor exception register
    signal ISR_AD           :   std_logic_vector(31 downto 0); --$31
    signal EPC              :   std_logic_vector(31 downto 0);  -- Exception Program Counter --$14
    signal STATUS           :   std_logic_vector(31 downto 0); --$12
    
    signal decodedInstruction: Instruction_type;
       
begin

    -- Instruction decoding
    decodedInstruction <=   NOP when lock else
                            Decode(instruction);
            
    assert not (decodedInstruction = UNIMPLEMENTED_INSTRUCTION and rst = '0')    
        report "******************* UNIMPLEMENTED INSTRUCTION *************"
        --severity error;   -- Produces only an error message in simulator
        severity failure;  -- Stops the simulation  
    
    -- Register PC and adder --
	REG_PC: process(clk, rst)
    begin
        if rst = '1' then
            pc                    <= PC_START_ADDRESS;
            lock                  <= true;
        elsif rising_edge(clk) then
            pc <= instructionFetchAddress + 4;
            if lock = true then
                lock <= false;
            elsif decodedInstruction = ERET then
                pc <= instructionFetchAddress;
            end if;
        end if;
    end process;


        
    -- Selects the instruction field which contains the register to be written
    -- In R-type instructions the destination register is in the 'instruction_rd' field
    -- MUX at the register file input (datapath diagram)
    MUX_RF: writeRegister <= UNSIGNED(instruction_rd) when R_Type(instruction) else -- R-type instructions
                             "11111" when (decodedInstruction = JAL or decodedInstruction = JALR) else    -- $ra ($31)
                             UNSIGNED(instruction_rt); -- Load instructions
      
    -- Sign extends the low 16 bits of instruction (I-Type immediate constant)
    -- Below the register file (datapath diagram)
    SIGN_EXT: signExtended <= UNSIGNED(RESIZE(SIGNED(instruction_imm), signExtended'length));
                           
    -- Zero extends the low 16 bits of instruction (I-Type immediate constant)
    -- Not present in datapath diagram
    ZERO_EXT: zeroExtended <= RESIZE(UNSIGNED(instruction_imm), zeroExtended'length);

    -- Converts the branch offset from words to bytes (multiply by 4) 
    -- Hardware at the second Branch ADDER input (datapath diagram)
    SHIFT_L: branchOffset <= signExtended(29 downto 0) & "00";

    -- Branch target address
    -- Branch ADDER above the ALU (datapath diagram)
    ADDER_BRANCH: branchTarget <= pc + branchOffset;

    -- Builds the jump target address
    -- Top of datapath diagram
    jumpTarget <= (pc(31 downto 28) & UNSIGNED(instruction(25 downto 0)) & "00");

    -- MUX which selects the source address of the next instruction 
    -- Not present in datapath diagram
    -- In case of jump/branch, PC must be bypassed due to synchronous memory read


    instructionFetchAddress <=      UNSIGNED(ISR_AD) when (intr = '1' and STATUS(0) = '1') else
                                    UNSIGNED(EPC) when decodedInstruction = ERET else
                                    branchTarget when ((decodedInstruction = BEQ and zero = '1') or (decodedInstruction = BNE and zero = '0')) else 
                                    branchTarget when (decodedInstruction = BGTZ and SIGNED(registerFile(TO_INTEGER(UNSIGNED(instruction_rs)))) > 0) else
                                    branchTarget when (decodedInstruction = BGEZ and SIGNED(registerFile(TO_INTEGER(UNSIGNED(instruction_rs)))) >= 0) else
                                    branchTarget when (decodedInstruction = BLTZ and SIGNED(registerFile(TO_INTEGER(UNSIGNED(instruction_rs)))) < 0) else
                                    branchTarget when (decodedInstruction = BLEZ and SIGNED(registerFile(TO_INTEGER(UNSIGNED(instruction_rs)))) <= 0) else
                                    jumpTarget when decodedInstruction = J or decodedInstruction = JAL else
                                    ALUoperand1 when (decodedInstruction = JR or decodedInstruction = JALR) else
                                    pc;

    -- Instruction memory addressing
    instructionAddress <= STD_LOGIC_VECTOR(instructionFetchAddress);

    ------------------------------
    -- Behavioral register file --
    ------------------------------
    readData2 <=    RESIZE(UNSIGNED(instruction_shamt), readData2'length) when decodedInstruction = SSLL or 
                                                decodedInstruction = SSRL or decodedInstruction = SSRA else
                    registerFile(TO_INTEGER(UNSIGNED(instruction_rt)));

    ---------------------------------------------
    -- Select byte for LB, LBU, SB instruction --
    ---------------------------------------------
    selectedByte <= data_in(7 downto 0) when result(1 downto 0) = "00" and (decodedInstruction = LB or decodedInstruction = LBU) else
                    data_in(15 downto 8) when result(1 downto 0) = "01" and (decodedInstruction = LB or decodedInstruction = LBU) else
                    data_in(23 downto 16) when result(1 downto 0) = "10" and (decodedInstruction = LB or decodedInstruction = LBU) else
                    data_in(31 downto 24) when result(1 downto 0) = "11" and (decodedInstruction = LB or decodedInstruction = LBU) else
                    std_logic_vector(readData2(7 downto 0)) when decodedInstruction = SB else
                    (others => '0');

    selectedByteExtended <= UNSIGNED(RESIZE(SIGNED(selectedByte), selectedByteExtended'length)) when decodedInstruction = LB or decodedInstruction = SB else
                            RESIZE(UNSIGNED(selectedByte), selectedByteExtended'length) when decodedInstruction = LBU else
									 (others => '0');

    ----------------------------------------
    -- Select word for LH, SH instruction --
    ----------------------------------------
    selectedHalfWord <=     data_in(15 downto 0) when result(1 downto 0) = "00" and (decodedInstruction = LH or decodedInstruction = LHU) else
                            data_in(31 downto 16) when result(1 downto 0) = "10" and (decodedInstruction = LH or decodedInstruction = LHU) else
                            std_logic_vector(readData2(15 downto 0)) when decodedInstruction = SH else
									 (others => '0');

    selectedHalfWordExtended <= UNSIGNED(RESIZE(SIGNED(selectedHalfWord), selectedHalfWordExtended'length)) when decodedInstruction = LH or decodedInstruction = SH else
                                RESIZE(UNSIGNED(selectedHalfWord), selectedHalfWordExtended'length) when decodedInstruction = LHU else
										  (others => '0');
    
    -- checks if half word is aligned
    process(clk)
    begin
        if rising_edge(clk) then
            if decodedInstruction = LH or decodedInstruction = LHU or decodedInstruction = SH then
                assert not (result(1 downto 0) = "01" or result(1 downto 0) = "11")
                    report "LH desalinhado, deve ser 00 ou 01"
                    severity failure;
            end if;
        end if;
    end process;

    -- Selects the data to be written in the register file
    -- In load instructions the data comes from the data memory
    -- MUX at the data memory output
    MUX_DATA_MEM: writeData <=  UNSIGNED(data_in) when decodedInstruction = LW else
                                selectedByteExtended when decodedInstruction = LB or decodedInstruction = LBU else
                                selectedHalfWordExtended when decodedInstruction = LH or decodedInstruction = LHU else
                                UNSIGNED(EPC) when decodedInstruction = MFC0 and TO_INTEGER(UNSIGNED(instruction_rd)) = 14 else
                                UNSIGNED(STATUS) when decodedInstruction = MFC0 and TO_INTEGER(UNSIGNED(instruction_rd)) = 12 else
                                UNSIGNED(ISR_AD) when decodedInstruction = MFC0 and TO_INTEGER(UNSIGNED(instruction_rd)) = 31 else
                                pc when decodedInstruction = JAL  or decodedInstruction = JALR else
                                HI when decodedInstruction = MFHI else
                                LO when decodedInstruction = MFLO else
                                result;
    
    -- R-type, ADDIU, ORI and load instructions, store the result in the register file
    regWrite <= '1' when WriteRegisterFile(decodedInstruction) else '0';
    

    
    -- Register $0 is read-only (constant 0)
    REGISTER_FILE: process(clk, rst)
    begin
    
        if rst = '1' then
            registerFile(0) <= (others=>'0');
            --for i in 0 to 31 loop   
            --    registerFile(i) <= (others=>'0');  
            --end loop;
               
        elsif rising_edge(clk) then
            if regWrite = '1' and writeRegister /= 0 then
                registerFile(TO_INTEGER(writeRegister)) <= writeData;
            end if;
        end if;
    end process;

    -- Coprocessor 0 register file
    COPR0_REG_FILE: process(clk, rst)
    begin
    if rst = '1' then
        STATUS  <= x"00000001";
        EPC     <= x"00000000";
        ISR_AD  <= x"00000000";
    elsif rising_edge(clk) then
        if decodedInstruction = MTC0 then
            if TO_INTEGER(UNSIGNED(instruction_rd)) = 31 then
                ISR_AD <=   STD_LOGIC_VECTOR(readData2);
            elsif TO_INTEGER(UNSIGNED(instruction_rd)) = 14 then
                EPC <=      STD_LOGIC_VECTOR(readData2);
            elsif TO_INTEGER(UNSIGNED(instruction_rd)) = 12 then
                STATUS <=   std_logic_vector(readData2);
            end if;
        elsif intr = '1' and STATUS = x"00000001" then
            EPC <= std_logic_vector(pc);                       -- salva PC atualS
            STATUS <= x"00000000";
        elsif decodedInstruction = ERET then
            STATUS <= x"00000001";    -- libera tratamento ao ERET
        end if;
    end if;
    end process;

    -- The first ALU operand always comes from the register file
    ALUoperand1 <=  registerFile(TO_INTEGER(UNSIGNED(instruction_rt))) when decodedInstruction = SSLL or 
                                    decodedInstruction = SSRL or decodedInstruction = SSRA else
                    registerFile(TO_INTEGER(UNSIGNED(instruction_rs)));

    -- Selects the second ALU operand
    -- In R-type or BEQ instructions, the second ALU operand comes from the register file
    -- In ORI instruction the second ALU operand is zeroExtended
    -- MUX at the ALU second input
    MUX_ALU: ALUoperand2 <= readData2 when R_Type(instruction) or decodedInstruction = BEQ or decodedInstruction = BNE else 
                            zeroExtended when decodedInstruction = ORI or decodedInstruction = XORI or decodedInstruction = ANDI else
                            signExtended;

    ---------------------
    -- Behavioural ALU --
    ---------------------
    result <=   ALUoperand1 - ALUoperand2 when decodedInstruction = SUBU or decodedInstruction = BEQ or decodedInstruction = BNE else --SUBU, BEQ, BNE
                ALUoperand1 and ALUoperand2 when decodedInstruction = AAND or decodedInstruction = ANDI else --AND, ANDI
                ALUoperand1 xor ALUoperand2 when decodedInstruction = XXOR or decodedInstruction = XORI else --XOR, XORI
                ALUoperand1 or  ALUoperand2 when decodedInstruction = OOR or decodedInstruction = ORI else --OR, ORI
                ALUoperand1 nor ALUoperand2 when decodedInstruction = NNOR else --NOR
                shift_left(ALUoperand1, TO_INTEGER(ALUoperand2)) when decodedInstruction = SSLL else --SSLL
                shift_left(ALUoperand2, TO_INTEGER(ALUoperand1)) when decodedInstruction = SLLV else --SLLV
                shift_right(ALUoperand1, TO_INTEGER(ALUoperand2)) when decodedInstruction = SSRL else --SSRL
                shift_right(ALUoperand2, TO_INTEGER(ALUoperand1)) when decodedInstruction = SRLV else --SRLV
                UNSIGNED(shift_right(SIGNED(ALUoperand2), TO_INTEGER(ALUoperand1))) when decodedInstruction = SRAV else --SRAV
                UNSIGNED(shift_right(SIGNED(ALUoperand1), TO_INTEGER(ALUoperand2))) when decodedInstruction = SSRA else --SSRA
                (0=>'1', others=>'0') when decodedInstruction = SLT and SIGNED(ALUoperand1) < SIGNED(ALUoperand2) else --SLT
                (others=>'0') when decodedInstruction = SLT and not (SIGNED(ALUoperand1) < SIGNED(ALUoperand2)) else --SLT
                (0=>'1', others=>'0') when decodedInstruction = SLTI and SIGNED(ALUoperand1) < SIGNED(ALUoperand2) else --SLTI
                (others=>'0') when decodedInstruction = SLTI and not (SIGNED(ALUoperand1) < SIGNED(ALUoperand2)) else --SLTI
                (0=>'1', others=>'0') when decodedInstruction = SLTIU and ALUoperand1 < ALUoperand2 else --SLTIU
                (others=>'0') when decodedInstruction = SLTIU and not (ALUoperand1 < ALUoperand2) else --SLTIU
                (0=>'1', others=>'0') when decodedInstruction = SLTU and (ALUoperand1 < ALUoperand2) else --SLTU
                (others=>'0') when decodedInstruction = SLTU and not (ALUoperand1 < ALUoperand2) else
                ALUoperand2(15 downto 0) & x"0000" when decodedInstruction = LUI else --LUI
                ALUoperand1 + ALUoperand2;    -- default for ADDU, ADDIU, SW, LW, LB   

    result64b <= UNSIGNED(SIGNED(ALUoperand1) * SIGNED(ALUoperand2)) when decodedInstruction = MULT else
                (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            if decodedInstruction = MULT then
                HI <= result64b(63 downto 32);
                LO <= result64b(31 downto 0);
            end if;
        end if;
    end process;

    -- Generates the zero flag
    zero <= '1' when result = 0 else '0';

    ---------------------------
    -- Data memory interface --
    ---------------------------

    -- ALU output address the data memory
    dataAddress <= STD_LOGIC_VECTOR(result);

    -- Data to data memory comes from the second read register at register file
    data_out <= STD_LOGIC_VECTOR(shift_left(selectedByteExtended, TO_INTEGER(result(1 downto 0))*8)) when decodedInstruction = SB else 
                STD_LOGIC_VECTOR(shift_left(selectedHalfWordExtended, TO_INTEGER(result(1 downto 0))*8)) when decodedInstruction = SH else
                STD_LOGIC_VECTOR(readData2);

    wbe <=  "1111" when decodedInstruction = SW else
            "0001" when result(1 downto 0) = "00" and decodedInstruction = SB else
            "0010" when result(1 downto 0) = "01" and decodedInstruction = SB else
            "0100" when result(1 downto 0) = "10" and decodedInstruction = SB else
            "1000" when result(1 downto 0) = "11" and decodedInstruction = SB else
            "0011" when result(1 downto 0) = "00" and decodedInstruction = SH else
            "1100" when result(1 downto 0) = "10" and decodedInstruction = SH else
            "0000";

    ce <= '1' when LoadInstruction(decodedInstruction) or StoreInstruction(decodedInstruction) else '0';
	

end behavioral;
