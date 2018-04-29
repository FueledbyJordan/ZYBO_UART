----------------------------------------------------------------------------------
-- Company: the University of North Carolina at Charlotte
-- Engineer: Roy Helms
-- 
-- Create Date: 04/22/2018 03:18:11 PM
-- Design Name: Team 6
-- Module Name: Receiver_Sim - Behavioral
-- Project Name: Project 2
-- Target Devices: 
-- Tool Versions: 
-- Description: This file is a test bench for Receiver.vhd
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
library UNISIM;
use UNISIM.VComponents.all;

entity Receiver_Sim is
--  Port ( );
end Receiver_Sim;

architecture Behavioral of Receiver_Sim is
signal clock, reset : std_logic;
signal receive, sTick, rxDoneTick : std_logic;
signal dataOut : std_logic_vector(7 downto 0);
signal stateOut : std_logic_vector(1 downto 0);

begin
p0: entity work.Receiver(Behavioral) Port Map(clk=>clock, rst=>reset, rx=>receive, s_tick=>sTick, rx_done_tick=>rxDoneTick, dout=>dataOut, state_out=>stateOut);
  
  process
    begin
      while true loop
        clock <= '0';
        wait for 1ns;
        clock <= '1';
        wait for 1ns;
      end loop;
    end process;

  process
    begin
      while true loop
        sTick <= '0';
        wait for 5ns;
        sTick <= '1';
        wait for 5ns;
      end loop;
    end process;

  process
    begin
      wait for 100ns;
      reset <= '1';
      receive <= '1';
      wait for 60ns;
      reset <= '0';
      receive <= '0';
--      wait for 60ns;
--      sTick <= '0';
--      wait for 60ns;
--      sTick <= '1';
      wait for 100ns;
      receive <= '1';
      wait for 2000ns;
      --reset <= '1';
      
    end process;
      
end Behavioral;
