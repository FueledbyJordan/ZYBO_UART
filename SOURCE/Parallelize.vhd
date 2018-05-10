library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Parallelize is
    Generic(
        DATA_WIDTH : INTEGER := 8
    );

    Port (
        Din : in STD_LOGIC;
        Dout : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        clk : in STD_LOGIC
    );
end Parallelize;

architecture Arch of Parallelize is

begin

    process(clk)
    variable temp : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := (others => '0');
    variable counts : INTEGER := 0;
    begin
        if (rising_edge(clk)) then
            temp(7) := temp(6);
            temp(6) := temp(5);
            temp(5) := temp(4);
            temp(4) := temp(3);
            temp(3) := temp(2);
            temp(2) := temp(1);
            temp(1) := temp(0);
            temp(0) := Din;
            counts := counts + 1;
            if (counts = 8) then
                Dout <= temp;
                counts := 0;
                temp := "00000000";
            else
                Dout <= "00000000";
            end if;
        end if;
    end process;
    
end Arch;