----------------------------------------------------------------------------------
-- Company: The University of North Carolina at Charlotte
-- Engineer: Roy Helms
-- 
-- Create Date: 03/19/2018 07:49:00 AM
-- Design Name: Project 1 - Intro to VHDL
-- Module Name: Address_Select - Behavioral
-- Project Name: Team 6
-- Target Devices: 
-- Tool Versions: 
-- Description: This file contains the Address Select logic using a 16x1 and a 4x1 MUX
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

entity Address_Select is
  Port ( 
  op1:          in std_logic_vector(1 downto 0);
  op2:          in std_logic_vector(1 downto 0);
  stage:        in std_logic_vector(1 downto 0);
  PC:           in std_logic_vector(1 downto 0);
  Rs:           in std_logic_vector(1 downto 0);
  Rd:           in std_logic_vector(1 downto 0);
  Immediate:    in std_logic_vector(1 downto 0);
  addrsel:       out std_logic_vector(1 downto 0)
  );
end Address_Select;

architecture Behavioral of Address_Select is
signal operator: std_logic_vector(3 downto 0);

begin
operator <= op1&op2;
  process(operator, stage)
    begin
      if (stage = "10") then
        case operator is
              when "0100" =>
                addrsel <= Rs; -- load the signal between the MUXs with Source Register value
              when "0101" =>
                addrsel <= Rd; -- load the signal between the MUXs with Destination Register value
              when "1100"|"1101" =>
                addrsel <= Immediate; -- load the signal between the MUXs with Immediate value
              when others =>
                addrsel <= PC;-- load the signal between the MUXs with PC value
            end case;
      else
        addrsel <= PC;
      end if;
    end process;  

end Behavioral;
