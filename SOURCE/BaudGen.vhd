----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2018 02:13:23 PM
-- Design Name: 
-- Module Name: BaudGen - Behavioral
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

entity BaudGen is
    generic(
        N : integer := 10;
        M : integer := 354
    );
    
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           max_tick : out STD_LOGIC;
           tick_out : out STD_LOGIC_vector(N-1 downto 0));
end BaudGen;

architecture Behavioral of BaudGen is
  signal r_reg : unsigned(N-1 downto 0) := (others => '0');
  signal r_next : unsigned(N-1 downto 0) := (others => '0');
begin
    process(clk,reset)
      begin
        if(reset='1') then
            r_reg <= (others => '0');
        elsif (clk'event and clk='1') then
            r_reg <= r_next;
        end if;
    end process;
    
    r_next <= (others =>'0') when r_reg=(M-1) else
        r_reg + 1;
    tick_out <= std_logic_vector(r_reg);
    max_tick <= '1' when r_reg=(M-1) else '0';

end Behavioral;
