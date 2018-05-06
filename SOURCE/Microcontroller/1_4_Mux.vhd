----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2018 03:30:41 PM
-- Design Name: 
-- Module Name: 1_4_Mux - Behavioral
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

entity Mux_1_4 is
    Port ( Mux_in : in STD_LOGIC;
           clk : in std_logic;
           op : in std_logic_vector(1 downto 0);
           out_0 : out STD_LOGIC;
           out_1 : out STD_LOGIC;
           out_2 : out STD_LOGIC;
           out_3 : out STD_LOGIC);
end Mux_1_4;

architecture Behavioral of Mux_1_4 is

begin
    process(Mux_in,op)
        begin  
            case op is 
                when "00" =>
                    out_0 <= Mux_in;
                    out_1 <= '0';
                    out_2 <= '0';
                    out_3 <= '0';
                when "01" =>
                    out_0 <= '0';
                    out_1 <= Mux_in;
                    out_2 <= '0';
                    out_3 <= '0';
                when "10" =>
                    out_0 <= '0';
                    out_1 <= '0';
                    out_2 <= Mux_in;
                    out_3 <= '0';
                when "11" =>
                    out_0 <= '0';
                    out_1 <= '0';
                    out_2 <= '0';
                    out_3 <= Mux_in;
                when others =>
                    out_0 <= '0';
                    out_1 <= '0';
                    out_2 <= '0';
                    out_3 <= '0';
            end case;
    end process;
end Behavioral;
