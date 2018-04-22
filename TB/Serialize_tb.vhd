library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Serialize_tb is
end Serialize_tb;

architecture arch of Serialize_tb is
    constant T : TIME := 20 ns;
    constant DATA_WIDTH : INTEGER := 8;
    
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal en : STD_LOGIC := '0';
    signal parallel_in : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal serial_out : STD_LOGIC;
begin
    p0 : entity work.Serialize(arch) port map(clk => clk, rst => rst, en => en, d_in => parallel_in, d_out => serial_out);

    clk <= not clk after T/2;
    rst <= '0' after T;
    en <= '1' after 2 * T;
    parallel_in <= "11111111" after T;

end arch;
