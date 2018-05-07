LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY MEMORY IS
    PORT(
        address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        readwrite : IN STD_LOGIC;-- := '0';   --read is 1, write is 0
        clk : in STD_LOGIC := '0';
        rst : in STD_LOGIC := '0';
        DMA_enable : in std_logic;
        DMA_rw : in std_logic;
        DMA_address : in std_logic_vector(7 downto 0);
        DMA_data_in : in std_logic_vector(7 downto 0);
        DMA_data_out : out std_logic_vector(7 downto 0)
    );
END ENTITY;

ARCHITECTURE BEV OF MEMORY IS
    TYPE MEM_2048 IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SHARED VARIABLE MEMORY : MEM_2048;
    SHARED VARIABLE ADDR : INTEGER RANGE 0 TO 255;
    BEGIN
        PROCESS(ADDRESS, DATAIN, readwrite, clk, rst, DMA_enable, DMA_data_in, DMA_address)
        BEGIN        
MEMORY(0) := "00000000";
        MEMORY(1) := "11100100";
        MEMORY(2) := "00000000";
        MEMORY(3) := "11100000";
        MEMORY(4) := "10000000";
        MEMORY(5) := "01001000";
        MEMORY(6) := "10001000";
        MEMORY(7) := "00001110";
        MEMORY(8) := "00100110";
        MEMORY(9) := "11101100";
        MEMORY(10) := "00000001";
        MEMORY(11) := "00100011";
        MEMORY(12) := "11111111";
        MEMORY(13) := "00000101";
        MEMORY(14) := "11010100";
        MEMORY(15) := "01000000";
        MEMORY(16) := "11111111";
        
            ADDR := CONV_INTEGER(DMA_address);
            IF(rising_edge(clk)) THEN
                IF(rst='1') THEN
                    dataout <= "00000000";
                    DMA_data_out <= "00000000";
                ELSE
                    IF DMA_enable = '1' THEN
                        ADDR:=CONV_INTEGER(ADDRESS);
                        IF(readwrite='1')THEN
                            MEMORY(ADDR):=datain;
                        ELSE
                            dataout<=MEMORY(ADDR);
                        END IF;
                    ELSIF DMA_enable = '0' THEN
                        IF(DMA_rw='1')THEN
                            MEMORY(ADDR):=DMA_data_in;
                        END IF;           
                    END IF;
                END IF;
            END IF;     
            DMA_data_out<=MEMORY(ADDR);
        END PROCESS;
END BEV;
