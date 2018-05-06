----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2018 09:11:55 PM
-- Design Name: 
-- Module Name: PC_reg - Behavioral
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

entity PC_reg is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (7 downto 0);
           PC_out : out STD_LOGIC_VECTOR (7 downto 0):="00000000");
end PC_reg;

architecture Behavioral of PC_reg is

begin
    process(clk,enable)
        begin
            if (clk'event and clk = '1' and enable ='1') then
                PC_out <= PC_in;
            end if;
    end process;

end Behavioral;
