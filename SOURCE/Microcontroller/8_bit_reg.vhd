----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2018 03:30:41 PM
-- Design Name: 
-- Module Name: 8_bit_reg - Behavioral
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

entity bit_reg_8 is
    Port ( clk : in std_logic;
           reset : in std_logic;
           enable : in std_logic;
           Reg_in : in STD_LOGIC_VECTOR (7 downto 0);
           Reg_out : out STD_LOGIC_VECTOR (7 downto 0) := "00000000");
end bit_reg_8;

architecture Behavioral of bit_reg_8 is

begin
    process(clk,reset,enable)
        begin
            if (reset='1') then
                Reg_out <= "00000000";
            end if;
            
            if (clk'event and clk = '1' and enable ='1') then
                Reg_out <= Reg_in;
            end if;
    end process;

end Behavioral;
