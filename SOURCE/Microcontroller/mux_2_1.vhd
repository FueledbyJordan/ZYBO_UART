----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2018 09:23:31 PM
-- Design Name: 
-- Module Name: mux_2_1 - Behavioral
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

entity mux_2_1 is
    Port ( in_0 : in STD_LOGIC_VECTOR (7 downto 0);
           in_1 : in std_logic_vector (7 downto 0);
           out_mux : out STD_LOGIC_vector (7 downto 0);
           op : in STD_LOGIC);
end mux_2_1;

architecture Behavioral of mux_2_1 is

begin
    process(op,in_0,in_1)
    begin
        case op is
            when '0' =>
                out_mux <= in_0;
            when '1' =>
                out_mux <= in_1;
            when others =>
                out_mux <= "00000000";
        end case;
end process;

end Behavioral;
