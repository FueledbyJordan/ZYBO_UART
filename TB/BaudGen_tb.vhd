----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 02:25:01 PM
-- Design Name: 
-- Module Name: BaudGen_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BaudGen_tb is
--  Port ( );
end BaudGen_tb;

architecture Behavioral of BaudGen_tb is
    signal clk, reset,max_tick : std_logic;
    signal tick_out : std_logic_vector (9 downto 0);    
begin
BG1 : entity work.BaudGen(Behavioral)
    port map (clk=>clk,reset=>reset,max_tick=>max_tick,tick_out=>tick_out);


process
    begin
        reset <= '0';
        clk <='0';
        wait for 1.6ns;
        clk <= not(clk);
        wait for 1.6ns;
end process;

end Behavioral;
