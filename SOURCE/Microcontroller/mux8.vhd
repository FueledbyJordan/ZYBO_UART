library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux8 is
    Port ( a: in  STD_LOGIC_VECTOR(7 downto 0);
           b: in  STD_LOGIC_VECTOR(7 downto 0);
           c: in  STD_LOGIC_VECTOR(7 downto 0);
           d: in  STD_LOGIC_VECTOR(7 downto 0);
           s: in  STD_LOGIC_VECTOR(1 downto 0);
      output: out STD_LOGIC_VECTOR(7 downto 0));
end mux8;

architecture dataflow of mux8 is
begin
    process(a,b,c,d,s)
    begin
    case(s) is
        when   "00" => output <= a;
        when   "01" => output <= b;
        when   "10" => output <= c;
        when   "11" => output <= d;
        when others => NULL;
        end case;
    end process;
end dataflow;