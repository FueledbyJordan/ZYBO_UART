----------------------------------------------------------------------------------
-- Company: The University of North Carolina at Charlotte
-- Engineer: John Humphries
-- 
-- Create Date: 03/24/2018 01:49:00 PM
-- Design Name: Project 1 - Intro to VHDL
-- Module Name: Decode_Logic - Behavioral
-- Project Name: Team 6
-- Target Devices: 
-- Tool Versions: 
-- Description: This program will implement the decode logic based on input from
--              the instruciton register.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decode_Logic is
    port(
        instruction : in std_logic_vector(7 downto 0); --instruction input from IR
        zero : in std_logic; --zero line from Register File; pass to pcload
        negative : in std_logic; --negative from Register File; pass to pcload
        stage : in std_logic_vector(1 downto 0); --input from the stage counter
        addrsel : out std_logic_vector(1 downto 0);
        irload : out std_logic;
        imload : out std_logic;
        regsel: out std_logic_vector(1 downto 0);
        dwrite: out std_logic;
        aluop: out std_logic_vector(1 downto 0);
        readwrite: out std_logic;
        pcsel: out std_logic;
        pcload: out std_logic;
        sregsel: out std_logic_vector(1 downto 0);
        dregsel: out std_logic_vector(1 downto 0)
);
end entity;

architecture Behavioral of Decode_Logic is

--Address Select Decode Logic Block
component Address_Select
    port(
        op1 : in std_logic_vector(1 downto 0);
        op2 : in std_logic_vector(1 downto 0);
        stage : in std_logic_vector(1 downto 0);
        PC : in std_logic_vector(1 downto 0);
        Rs : in std_logic_vector(1 downto 0);
        Rd : in std_logic_vector(1 downto 0);
        Immediate : in std_logic_vector(1 downto 0);
        addrsel : out std_logic_vector(1 downto 0)
      );
end component;

--Destination Register Write Logic Block
component Dest_Reg_Write
    port(
        op1 : in std_logic_vector(1 downto 0);
        op2 : in std_logic_vector(1 downto 0);
        stage : in std_logic_vector(1 downto 0);
        dwrite : out std_logic
    );
end component;

--Register Select Logic Block
component Register_Select
    port(
        ALU_out : in std_logic_vector(1 downto 0);
        Datain : in std_logic_vector(1 downto 0);
        Rs : in std_logic_vector(1 downto 0);
        Immediate : in std_logic_vector(1 downto 0);
        op1 : in std_logic_vector(1 downto 0);
        op2 : in std_logic_vector(1 downto 0); 
        stage : in std_logic_vector(1 downto 0); 
        regsel : out std_logic_vector(1 downto 0)
    );
end component;

component PCL
    port(
        zero: in std_logic;
        negative : in std_logic;
        irbit : in std_logic_vector(7 downto 0);
        op2 : in std_logic_vector(1 downto 0);
        stage : in std_logic_vector(1 downto 0);
        pcload : out std_logic
    );
end component;

--signal split declarations
signal irbit4, irbit5, irbit6, irbit7 : std_logic := '0';
signal op1, op2 : std_logic_vector(1 downto 0) := (others => '0');
signal op1op2 : std_logic_vector(3 downto 0) := (others => '0');

--shared variables for logic within the process block
shared variable irload_temp : std_logic := '0';
--shared variable imload_temp : std_logic := '0';
signal imload_temp : std_logic := '0';
shared variable readwrite_temp : std_logic := '0';
shared variable pcsel_temp : std_logic := '0';
shared variable irbit4_temp : std_logic := instruction(4);
shared variable irbit5_temp : std_logic := instruction(5);
shared variable irbit6_temp : std_logic := instruction(6);
shared variable irbit7_temp : std_logic := instruction(7);

--Options for addrsel/regsel
constant PC : std_logic_vector(1 downto 0) := "00"; --addrsel PC option
constant ALU_out : std_logic_vector(1 downto 0) := "11"; --regsel ALU option
constant Datain : std_logic_vector(1 downto 0) := "10"; --regsel Datain option
constant Immediate : std_logic_vector(1 downto 0) := "01"; --addrsel Immediate option
constant Rd : std_logic_vector(1 downto 0) := "11"; --addrsel destination reg option
constant Rs : std_logic_vector(1 downto 0) := "01"; --addrsel source reg option

begin
    --split IR into lines
    irbit4 <= instruction(4);
    irbit5 <= instruction(5);
    irbit6 <= instruction(6);
    irbit7 <= instruction(7);
    --split into op codes
    op1op2 <= instruction(7 downto 4);
    op1 <= instruction(7 downto 6);
    op2 <= instruction(5 downto 4);
    
    --direct wire, not stage based 
    dregsel <= instruction(3 downto 2);
    sregsel <= instruction(1 downto 0);
    aluop <= op2; 
    
    --instantiate Address_Select, Dest_Reg_Write, Register_Select, and pcload
    Addr_Sel : Address_Select port map(op1=>op1,op2=>op2,stage=>stage,PC=>PC,Rs=>Datain,Rd=>Rd,Immediate=>Immediate,addrsel=>addrsel);
    Dest_Write : Dest_Reg_Write port map(op1=>op1,op2=>op2,stage=>stage,dwrite=>dwrite);
    Reg_Sel : Register_Select port map(ALU_out=>ALU_out,Datain=>Datain,Rs=>Rs,Immediate=>PC,op1=>op1,op2=>op2,stage=>stage,regsel=>regsel);
    PC_Load : PCL port map(zero=>zero,negative=>negative,irbit=>instruction,op2=>op2,stage=>stage,pcload=>pcload);
        
    process(stage,instruction)
    begin
        irbit4_temp := irbit4;
        irbit5_temp := irbit5;
        irbit6_temp := irbit6;
        irbit7_temp := irbit7;
        --Handle simple control lines based on stage     
        if stage = "00" then
            --stage 0 decoding
            pcsel_temp := '1';
            irload_temp := '1';
            imload_temp <= '0';
            readwrite_temp := '0';
        elsif stage = "01" then
            --stage 1 decoding
            if instruction(7) = '1' then
                pcsel_temp := '1';
                irload_temp := '0';
                imload_temp <= '1';
                readwrite_temp := '0';
            elsif instruction(7) = '0' then
                pcsel_temp := '0';
                irload_temp := '0';
                imload_temp <= '0';
                readwrite_temp := '0';
            end if;
            --stage 2 decoding
        elsif stage = "10" then
            pcsel_temp := '0';
            irload_temp := '0';
            imload_temp <= '0';
            if instruction(6) = '1' and instruction(5) = '0' and instruction(4) = '1' then
                readwrite_temp := '1';
            else
                readwrite_temp := '0';
            end if;
        end if;
        pcsel <= pcsel_temp;
        irload <= irload_temp;
        imload <= imload_temp;
--        if stage = "01" then
--            imload <= imload_temp1;
--        else
--            imload <= imload_temp2;
--        end if;
        readwrite <= readwrite_temp;
        end process;
end Behavioral;