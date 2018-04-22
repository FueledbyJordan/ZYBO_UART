library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Little Endian PISO

entity Serialize is

    generic(
        DATA_WIDTH : INTEGER := 8
    );
    
    port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        en : in STD_LOGIC;
        d_in : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        d_out : out STD_LOGIC
    );

end Serialize;

architecture arch of Serialize is
    constant ZERO : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal temp : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    TYPE STATES is (WAITING, SHIFTING);
    signal state : STATES;
    
begin

    process(clk)
        variable count : INTEGER := 0;
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                state <= WAITING;
                temp <= ZERO;
                count := 0;
            else
                case state is
                    when waiting =>
                        count := 0;
                        temp <= d_in;
                        d_out <= '0';
                        if (en = '1') then
                            state <= SHIFTING;
                        else
                            state <= WAITING;
                        end if;
                    when shifting =>
                        count := count + 1;
                        d_out <= temp(0);
                        temp <= '0' & temp(DATA_WIDTH - 1 downto 1);
                        if (count > DATA_WIDTH - 1) then
                            state <= WAITING;
                        else
                            state <= SHIFTING;
                        end if;
                end case;
            end if;
        end if;
    end process;

end arch;
