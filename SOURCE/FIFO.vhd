library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is

    Generic(
        DATA_WIDTH : INTEGER := 8;
        MAX_HEIGHT : INTEGER := 16
    );

    Port (
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        wr_en : in STD_LOGIC;
        rd_en : in STD_LOGIC;
        wr_data : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        rd_data : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        empty : out STD_LOGIC;
        full : out STD_LOGIC
    );
end FIFO;

architecture arch of FIFO is

    type FIFO_TYPE is array(0 to MAX_HEIGHT - 1) of STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    
    signal t_FIFO : FIFO_TYPE := (others => (others => '0'));
    signal t_count : INTEGER range -1 to MAX_HEIGHT + 1 := 0;
    signal t_rd_index : INTEGER range 0 to MAX_HEIGHT - 1 := 0;
    signal t_wr_index : INTEGER range 0 to MAX_HEIGHT - 1 := 0;
    signal t_full : STD_LOGIC;
    signal t_empty : STD_LOGIC;
   
begin

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                t_rd_index <= 0;
                t_wr_index <= 0;
                t_count <= 0;
            else
                if (wr_en = '1' and rd_en = '0') then
                    t_count <= t_count + 1;
                elsif (wr_en = '0' and rd_en = '1') then
                    t_count <= t_count - 1;
                end if;
                
                if (wr_en = '1'and t_full = '0') then
                    if (t_wr_index = MAX_HEIGHT - 1) then
                        t_wr_index <= 0;
                    else
                        t_wr_index <= t_wr_index + 1;
                    end if;
                end if;
                
                if (rd_en = '0'and t_empty = '0') then
                    if (t_rd_index = MAX_HEIGHT - 1) then
                        t_rd_index <= 0;
                    else
                        t_rd_index <= t_rd_index + 1;
                    end if;
                end if;
                
                if (wr_en = '1') then
                    t_FIFO(t_wr_index) <= wr_data;
                end if;
                
                if (rd_en = '1') then
                    rd_data <= t_FIFO(t_rd_index);
                end if;
            end if;
        end if;
    end process;
    
    t_full <= '1' when t_count = MAX_HEIGHT else '0';
    t_empty <= '1' when t_count = 0 else '0';
    
    full <= t_full;
    empty <= t_empty;
    
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (wr_en = '1' and t_full = '1') then
                report "CANNOT WRITE, FIFO FULL." severity failure;
            end if;
            
            if (rd_en = '1' and t_empty = '1') then
                report "CANNOT READ, FIFO EMPTY." severity failure;
            end if;
        end if;
    end process;

end arch;
