----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 04:05:30 PM
-- Design Name: 
-- Module Name: Transmitter_tb - Behavioral
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

entity Transmitter_tb is
--  Port ( );
end Transmitter_tb;

architecture Behavioral of Transmitter_tb is
  signal clk : STD_LOGIC;
  signal reset : STD_LOGIC;
  signal tx_start : STD_LOGIC;
  signal s_tick : STD_LOGIC;
  signal din : STD_LOGIC_VECTOR (7 downto 0);
  signal tx_done_tick : STD_LOGIC;
  signal tx : STD_LOGIC;
  signal state : std_logic_vector (1 downto 0);
  
begin
TX1 : entity work.Transmitter(Behavioral)
    port map (clk=>clk,reset=>reset,tx_start=>tx_start,s_tick=>s_tick,din=>din,tx_done_tick=>tx_done_tick,tx=>tx,state=>state);

reset <='0';

process
  begin
    clk <='0';
    wait for 1.6ns;
    clk <='1';
    wait for 1.6ns;
end process;

process
  begin
    s_tick<='0';
    wait for 25.6ns;
    s_tick<='1';
    wait for 25.6ns;
end process;

process
  begin
    din <= "11010100";
    wait for 100ns;
    tx_start <='1';
    wait for 4ns;
    tx_start <='0';
    wait for 2000ns;
end process;
end Behavioral;
