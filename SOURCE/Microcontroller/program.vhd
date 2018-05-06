library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program is
end program;

architecture BEV of program is
    constant T : TIME := 125 ns;
    constant MEM_WIDTH : INTEGER := 8;
    constant INSTRUCTION_POINTER : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0) := (others => '0');
    constant NUM_INSTRUCTIONS : INTEGER := 17;
    type INSTRUCTIONS is array(NUM_INSTRUCTIONS - 1 downto 0) of STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);


    --signal ISA : INSTRUCTIONS;
    signal address : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);-- := (others=>'0');
    --signal dataout : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0) := (others=>'0');
    --signal datain : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);
    --signal readwrite : STD_LOGIC;
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal enable : std_logic := '0';
    
    signal sbus : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);
    signal dbus : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);
    signal aluout : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);
    signal immed : STD_LOGIC_VECTOR(MEM_WIDTH - 1 downto 0);
    signal aluop : STD_LOGIC_VECTOR(1 downto 0);
    signal negative : STD_LOGIC;
    signal zero : STD_LOGIC;
    signal pcsel : STD_LOGIC;
    signal pcload : STD_LOGIC;
    signal dataout : std_logic_vector(7 downto 0);
    signal stage : std_logic_vector (1 downto 0);
    signal readwrite : std_logic;
    
    begin
    p1 : entity work.Microcontroller port map(readwrite=>readwrite,stage=>stage,dataout=>dataout,mcenable=>enable,address=>address, clk=>clk, sbus=>sbus, dbus=>dbus, aluout=>aluout, immed=>immed, aluop=>aluop, negative=>negative, zero=>zero, pcsel=>pcsel, pcload=>pcload);


    process
    begin       
        enable <= '0';
        while true loop
            clk <= '0';
            wait for T/2;
            clk <= '1';
            wait for T/2;
            enable <= '1';
        end loop;
        wait;

    end process;
end BEV; 
