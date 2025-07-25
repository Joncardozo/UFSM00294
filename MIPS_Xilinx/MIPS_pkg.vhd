
-------------------------------------------------------------------------
-- Design unit: MIPS package
-- Description: Types and functions used in the processor description
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package MIPS_pkg is 
    
    -- Implemented instructions
    type Instruction_type is (
        UNIMPLEMENTED_INSTRUCTION, NOP, ADDU, SUBU, AAND, ANDI, OOR, SW, LW, ADDIU, 
        ORI, SLT, BEQ, BNE, J, JR, JAL, LUI, XXOR, XORI, NNOR, SSLL, SSRL, SSRA, SLLV,
        SRLV, SRAV, SLTI, SLTIU, BGEZ, BLEZ, LB, LBU, LH, LHU, SB, SH, JALR, SLTU
    );
    
    -- Functions used to facilitate the processor description
    function Decode(instruction: std_logic_vector(31 downto 0)) return Instruction_type;
    function R_Type(instruction: std_logic_vector(31 downto 0)) return boolean;
    function WriteRegisterFile(instruction: Instruction_type) return boolean;
    function LoadInstruction(instruction: Instruction_type) return boolean;
    function StoreInstruction(instruction: Instruction_type) return boolean;    
  
         
end MIPS_pkg;

package body MIPS_pkg is

    function R_Type(instruction: std_logic_vector(31 downto 0)) return boolean is
    begin
        if instruction(31 downto 26) = "000000" then
            return true;
        else
            return false;
        end if;
    end R_Type;

      
    -- Instruction decoding
    function Decode(instruction: std_logic_vector(31 downto 0)) return Instruction_type is
        variable decodedInstruction : Instruction_type;
    begin
    
        decodedInstruction := UNIMPLEMENTED_INSTRUCTION; -- Invalid or not implemented instruction
    
        case(instruction(31 downto 26)) is
            when "000000" => -- R-Type        
                if instruction(5 downto 0) = "100001" then
                    decodedInstruction := ADDU;
                
                elsif instruction(5 downto 0) = "100011" then
                    decodedInstruction := SUBU;
                
                elsif instruction(5 downto 0) = "100100" then
                    decodedInstruction := AAND;
                
                elsif instruction(5 downto 0) = "100101" then
                    decodedInstruction := OOR;
                
                elsif instruction(5 downto 0) = "101010" then
                    decodedInstruction := SLT;
                
                elsif instruction(5 downto 0) = "100110" then
                    decodedInstruction := XXOR;

                elsif instruction(5 downto 0) = "001000" then
                    decodedInstruction := JR;

                elsif instruction(5 downto 0) = "001001" then
                    decodedInstruction := JALR;

                elsif instruction(5 downto 0) = "100111" then
                    decodedInstruction := NNOR;

                elsif instruction(5 downto 0) = "000000" then
                    decodedInstruction := SSLL;

                elsif instruction(5 downto 0) = "000010" then
                    decodedInstruction := SSRL;

                elsif instruction(5 downto 0) = "000011" then
                    decodedInstruction := SSRA;

                elsif instruction(5 downto 0) = "000100" then
                    decodedInstruction := SLLV;

                elsif instruction(5 downto 0) = "000110" then
                    decodedInstruction := SRLV;

                elsif instruction(5 downto 0) = "000111" then
                    decodedInstruction := SRAV;

                elsif instruction(5 downto 0) = "101011" then
                    decodedInstruction := SLTU;

                end if;

        when "000001" => --REGIMM GROUP
            if instruction(20 downto 16) = "00001" then
                decodedInstruction := BGEZ; 
            end if;

        when "101011" =>
            decodedInstruction := SW;
        
        when "000110" =>
            decodedInstruction := BLEZ;

        when "100011" =>
            decodedInstruction := LW;

        when "100000" =>
            decodedInstruction := LB;

        when "100100" =>
            decodedInstruction := LBU;
        
        when "100001" =>
            decodedInstruction := LH;

        when "100101" =>
            decodedInstruction := LHU;
        
        when "001001" =>
            decodedInstruction := ADDIU;
        
        when "001101" =>
            decodedInstruction := ORI;

        when "001011" =>
            decodedInstruction := SLTIU;

        when "001010" =>
            decodedInstruction := SLTI;

        when "001110" =>
            decodedInstruction := XORI;

        when "001100" =>
            decodedInstruction := ANDI;
        
        when "000100"  =>
            decodedInstruction := BEQ;

        when "000101" => 
            decodedInstruction := BNE;
        
        when "000010" =>
            decodedInstruction := J;
        
        when "000011" =>
            decodedInstruction := JAL;

        when "101000" =>
            decodedInstruction := SB;

        when "101001" =>
            decodedInstruction := SH;
        
        when "001111" => 
            if instruction(25 downto 21) = "00000" then
                decodedInstruction := LUI;
            end if;
        
        when others=>    
            decodedInstruction := UNIMPLEMENTED_INSTRUCTION;
        end case;
        
        return decodedInstruction;
    
    end Decode;

    -- Returns 
    --      true, if the instruction writes to the register file
    --      false, otherwise
    function WriteRegisterFile(instruction: Instruction_type) return boolean is
        variable result : boolean;
    begin
        
        case (instruction) is
            when ADDU | SUBU | AAND | OOR | SLT | LW | ADDIU | ORI | LUI | JAL | XXOR
                | XORI | ANDI | NNOR | SSLL | SSRL | SSRA | SLLV | SRLV | SRAV | SLTI 
                | SLTIU | LB  | LBU | LH | LHU | SLTU =>
                result := true;
            
            when others =>
                result := false;
        end case;
        
        return result;
    
    end WriteRegisterFile;
    
    -- Returns 
    --      true, if the instruction is load
    --      false, otherwise
    function LoadInstruction(instruction: Instruction_type) return boolean is
        variable result : boolean;
    begin
        
        case (instruction) is
            when LW | LB | LBU | LH | LHU => -- LB, LBU, LH, LHU
                result := true;
            
            when others =>
                result := false;
        end case;
        
        return result;
        
    end LoadInstruction;
    
    -- Returns 
    --      true, if the instruction is store
    --      false, otherwise    
    function StoreInstruction(instruction: Instruction_type) return boolean is
        variable result : boolean;
    begin
        
        case (instruction) is
            when SW | SB | SH => -- SB, SH
                result := true;
            
            when others =>
                result := false;
        end case;
        
        return result;
    
    end StoreInstruction;
    
    
end MIPS_pkg;