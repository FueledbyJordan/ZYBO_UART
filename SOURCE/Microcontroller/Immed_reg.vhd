----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2018 08:49:35 PM
-- Design Name: 
-- Module Name: Immed_reg - Behavioral
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

entity Immed_reg is
    Port ( Immed_in : in STD_LOGIC_VECTOR (7 downto 0);
           Immed_out : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC);
end Immed_reg;

architecture Behavioral of Immed_reg is

begin
    process(clk,enable)
    begin
    if (clk'event and clk = '1' and enable ='1') then
        Immed_out <= Immed_in;
    end if;
end process;


end Behavioral;
