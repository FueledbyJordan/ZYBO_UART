----------------------------------------------------------------------------------
-- Company: The University of North Carolina at Charlotte
-- Engineer: Roy Helms
-- 
-- Create Date: 03/19/2018 06:07:03 AM
-- Design Name: Project 1 - Intro to VHDL
-- Module Name: Register_Select - Behavioral
-- Project Name: Team 6
-- Target Devices: 
-- Tool Versions: 
-- Description: This program will create the Register Select Logic using a
--              16x1 MUX and a 4x1 Mux. The select bits for the 16x1 MUX will
--              be op1op2, and the select bit for the 4x1 MUX will be the stage.
--              (Used the table included in the project description on page 7)
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

entity Register_Select is
  Port ( 
  ALU_out:      in std_logic_vector(1 downto 0);
  Datain:       in std_logic_vector(1 downto 0);
  Rs:           in std_logic_vector(1 downto 0);
  Immediate:    in std_logic_vector(1 downto 0);
  op1:          in std_logic_vector(1 downto 0);
  op2:          in std_logic_vector(1 downto 0); -- may need to make as two inputs of 2- bits each
  stage:        in std_logic_vector(1 downto 0); 
  regsel:       out std_logic_vector(1 downto 0)
  );
end Register_Select;

architecture Behavioral of Register_Select is
--type operator is (zero, one, two, three);
signal operator:    std_logic_vector(3 downto 0);

begin
operator <= op1&op2;
  process(operator, stage)
    begin
      if (stage = "10") then
        case operator is
          when "0000"|"0001"|"0010"|"0011" =>
            regsel <= ALU_out; -- load the signal between the MUXs with ALU output value
          when "0110" =>
            regsel <= Rs; -- load the signal between the MUXs with Source Register value
          when "0100"|"1100" =>
            regsel <= Datain; -- load the signal between the MUXs with Datain value
          when others =>
            regsel <= Immediate; -- load the signal between the MUXs with Immediate value
          end case;
      else
        regsel <= Immediate;
      end if;
    end process;
    
end Behavioral;
