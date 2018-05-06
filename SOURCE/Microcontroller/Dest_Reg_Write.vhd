----------------------------------------------------------------------------------
-- Company: The University of North Carolina at Charlotte
-- Engineer: Roy Helms
-- 
-- Create Date: 03/19/2018 07:24:40 AM
-- Design Name: Project 1 - Intro to VHDL
-- Module Name: Dest_Reg_Write - Behavioral
-- Project Name: Team 6
-- Target Devices: 
-- Tool Versions: 
-- Description: This file contains the dwrite logic using a 16x1 and a 4x1 MUX
--              and the table included in the project description on page 7.
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

entity Dest_Reg_Write is
  Port ( 
  op1:      in std_logic_vector(1 downto 0);
  op2:      in std_logic_vector(1 downto 0);
  stage:    in std_logic_vector(1 downto 0);
  dwrite:   out std_logic
  );
end Dest_Reg_Write;

architecture Behavioral of Dest_Reg_Write is
signal operator: std_logic_vector(3 downto 0);

begin
operator <= op1&op2;
  process(operator, stage)
    begin
      if (stage = "10") then
        case operator is
          when "0000"|"0001"|"0010"|"0011"|"0100"|"0110"|"1100"|"1110" => -- values from table
            dwrite <= '1'; -- set signal between MUXs to HIGH
          when others =>
            dwrite <= '0'; -- set signal between MUXs to HIGH
        end case;
      else
        dwrite <= '0';
      end if;
    end process;

end Behavioral;
