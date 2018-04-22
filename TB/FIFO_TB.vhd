----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2018 03:02:57 PM
-- Design Name: 
-- Module Name: FIFO_TB - Behavioral
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

entity FIFO_TB is
--  Port ( );
end FIFO_TB;

architecture Behavioral of FIFO_TB is

    constant T : TIME := 20 ns;
    constant DATA_WIDTH : INTEGER := 8;
    
    signal rst : STD_LOGIC := '1';
    signal clk : STD_LOGIC := '0';
    signal wr_en : STD_LOGIC := '0';
    signal rd_en : STD_LOGIC := '0';
    signal wr_data : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := "10101110";
    signal rd_data : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal empty : STD_LOGIC;
    signal full : STD_LOGIC;
begin

    p0 : entity work.FIFO(arch) port map(rst => rst, clk => clk, wr_en => wr_en, rd_en => rd_en, wr_data => wr_data, rd_data => rd_data, empty => empty, full => full);

    clk <= not clk after T/2;
    rst <= '0' after T;
    
    process is
    begin
        wait until clk = '1';
        wr_en <= '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wr_en <= '0';
        rd_en <= '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wr_en <= '1';
        rd_en <= '0';
        wait until clk = '1';
        wait until clk = '1';
        rd_en <= '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wr_en <= '0';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';
        wait until clk = '1';

    end process;

end Behavioral;
