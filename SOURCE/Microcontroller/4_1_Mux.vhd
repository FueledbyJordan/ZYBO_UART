----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2018 03:30:41 PM
-- Design Name: 
-- Module Name: 4_1_Mux - Behavioral
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

entity Mux_4_1 is
    Port ( in_0 : in STD_LOGIC_VECTOR (7 downto 0);
           in_1 : in STD_LOGIC_VECTOR (7 downto 0);
           in_2 : in STD_LOGIC_VECTOR (7 downto 0);
           in_3 : in STD_LOGIC_VECTOR (7 downto 0);
           op : in std_logic_vector (1 downto 0);
           out_mux : out STD_LOGIC_VECTOR (7 downto 0));
end Mux_4_1;

architecture Behavioral of Mux_4_1 is

begin
    process(op,in_0,in_1,in_2,in_3)
        begin
            case op is
                when "00" =>
                    out_mux <= in_0;
                when "01" =>
                    out_mux <= in_1;
                when "10" =>
                    out_mux <= in_2;
                when "11" =>
                    out_mux <= in_3;
                when others =>
                    out_mux <= "00000000";
            end case;
end process;

end Behavioral;
