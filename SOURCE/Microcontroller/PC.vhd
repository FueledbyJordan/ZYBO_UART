----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2018 09:21:34 PM
-- Design Name: 
-- Module Name: PC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( Immed_in : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in std_logic;
           pcsel : in std_logic;
           pcload : in std_logic;
           sbus : in std_logic_vector (7 downto 0 );
           dbus : in std_logic_vector (7 downto 0 );
           addrsel  : in std_logic_vector (1 downto 0);
           stage : in std_logic_vector(1 downto 0);
           address : out STD_LOGIC_VECTOR (7 downto 0):="00000000");
end PC;

architecture Behavioral of PC is
    component PC_reg
        Port ( clk : in STD_LOGIC;
               enable : in STD_LOGIC;
               PC_in : in STD_LOGIC_VECTOR (7 downto 0);
               PC_out : out STD_LOGIC_VECTOR (7 downto 0):="00000000");
    end component;

    component mux_2_1
        Port ( in_0 : in STD_LOGIC_VECTOR (7 downto 0);
               in_1 : in std_logic_vector (7 downto 0);
               out_mux : out STD_LOGIC_vector (7 downto 0);
               op : in STD_LOGIC);
    end component;
    
    component mux_4_1
        Port ( in_0 : in STD_LOGIC_VECTOR (7 downto 0);
               in_1 : in STD_LOGIC_VECTOR (7 downto 0);
               in_2 : in STD_LOGIC_VECTOR (7 downto 0);
               in_3 : in STD_LOGIC_VECTOR (7 downto 0);
               op : in std_logic_vector (1 downto 0);
               out_mux : out STD_LOGIC_VECTOR (7 downto 0)); 
    end component;
 signal mux_PC,temp_PC_out,PC_plus,temp_address : std_logic_vector (7 downto 0);
 shared variable plus : boolean := false;
 
begin
PC_mux : mux_2_1
    port map (in_0=>Immed_in,in_1=>PC_plus,out_mux=>mux_PC,op=>pcsel);
REGPC : PC_reg
    port map (clk=>clk,enable=>pcload,PC_in=>mux_PC,PC_out=>temp_PC_out);
AddrMUX : mux_4_1
    port map (in_0=>temp_PC_out,in_1=>Immed_in,in_2=>sbus,in_3=>dbus,
                op=>addrsel,out_mux=>temp_address);
process(stage)
    begin
    if stage = "00" then
        plus := true;
    end if;
    if plus then 
        plus := false;               
        PC_plus <= std_logic_vector(unsigned(temp_PC_out) + "00000001");
    end if;   
end process;
address <= temp_address;
end Behavioral;
