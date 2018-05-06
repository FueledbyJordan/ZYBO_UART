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
        rst : in STD_LOGIC := '0'
    );
END ENTITY;

ARCHITECTURE BEV OF MEMORY IS
    TYPE MEM_2048 IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SHARED VARIABLE MEMORY : MEM_2048;
    SHARED VARIABLE ADDR : INTEGER RANGE 0 TO 255;
    BEGIN
        PROCESS(ADDRESS, DATAIN, readwrite, clk, rst)
        BEGIN
        MEMORY(0) := "11100100"; --LI R1, 0x00
        MEMORY(1) := "00000000"; --Immediate Val
        MEMORY(2) := "11100000"; --LI R0, 0x80
        MEMORY(3) := "10000000"; --Immediate Val
        MEMORY(4) := "01001000"; --LW R2 (R0)
        MEMORY(5) := "10001000"; --JEQ R2 end
        MEMORY(6) := "00001110"; --Immediate Val
        MEMORY(7) := "00100110"; --ADD R1 (R2)
        MEMORY(8) := "11101100"; --LI R3, 0x01
        MEMORY(9) := "00000001"; --Immediate Val
        MEMORY(10) := "00100011"; --ADD R0 (R3)
        MEMORY(11) := "11111111"; --JMP loop
        MEMORY(12) := "00000101"; --Immmediate Val
        MEMORY(13) := "11010100"; --SW R1, 0x40
        MEMORY(14) := "01000000"; --Immediate Val
        MEMORY(15) := "11111111"; --JMP inf
        MEMORY(16) := "00010000"; --Immediate Val
        
        MEMORY(128) := "10000000";
        MEMORY(129) := "10000001";
        MEMORY(130) := "10000010";
        MEMORY(131) := "10000011";
        MEMORY(132) := "10000100";
        MEMORY(133) := "10000101";
        MEMORY(134) := "10000110";
        MEMORY(135) := "10000111";
        MEMORY(136) := "10001000";
        MEMORY(137) := "10001001";
        MEMORY(138) := "10001010";
        MEMORY(139) := "10001011";
        MEMORY(140) := "10001100";
        MEMORY(141) := "10001101";
        MEMORY(142) := "10001110";
        MEMORY(143) := "10001111";
        MEMORY(144) := "10010000";
        MEMORY(145) := "10010001";
        MEMORY(146) := "10010010";
        MEMORY(147) := "10010011";
        MEMORY(148) := "10010100";
        MEMORY(149) := "10010101";
        MEMORY(150) := "10010110";
        MEMORY(151) := "10010111";
        MEMORY(152) := "10011000";
        MEMORY(153) := "10011001";
        MEMORY(154) := "10011010";
        MEMORY(155) := "10011011";
        MEMORY(156) := "10011100";
        MEMORY(157) := "10011101";
        MEMORY(158) := "10011110";
        MEMORY(159) := "10011111";
        MEMORY(160) := "00000000";
        
            IF(rising_edge(clk)) THEN
                IF(rst='1') THEN
                    dataout <= "00000000";
                ELSE
                    ADDR:=CONV_INTEGER(ADDRESS);
                    IF(readwrite='1')THEN
                        MEMORY(ADDR):=datain;
                    ELSE
                        dataout<=MEMORY(ADDR);
                    END IF;
                END IF;
            END IF;
        END PROCESS;
END BEV;
