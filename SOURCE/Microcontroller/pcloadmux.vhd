library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux is
    Port ( a: in  STD_LOGIC;
           b: in  STD_LOGIC;
           c: in  STD_LOGIC;
           d: in  STD_LOGIC;
          s1: in  STD_LOGIC;
          s0: in  STD_LOGIC;
           y: out STD_LOGIC);
end mux;

architecture dataflow of mux is
begin
    y <= (a and (not s1) and (not s0)) or (b and (not s1) and s0) or (c and s1 and (not s0)) or (d and s1 and s0);
end dataflow;