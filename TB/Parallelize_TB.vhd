----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2018 12:57:56 PM
-- Design Name: 
-- Module Name: Parallelize_TB - Behavioral
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

entity Parallelize_TB is
--  Port ( );
end Parallelize_TB;

architecture Behavioral of Parallelize_TB is
    constant T : TIME := 20 ns;
    constant DATA_WIDTH : INTEGER := 8;
    
    signal clk : STD_LOGIC := '0';
    signal Din : STD_LOGIC := '0';
    signal Dout : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := (others => '0');    
    
begin
    p0 : entity work.Parallelize(Arch) port map(clk => clk, Din => Din, Dout => Dout);
    clk <= not clk after T/2;

    process
    begin
        Din <= '1';
        wait for T;
        Din <= '1';
        wait for T;
        Din <= '0';
        wait for T;
        Din <= '0';
        wait for T;
        Din <= '1';
        wait for T;
        Din <= '1';
        wait for T;
        Din <= '0';
        wait for T;
        Din <= '1';
        wait for T;
        wait;
    end process;
    

end Behavioral;
