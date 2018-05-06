library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PCL is
    Port ( zero: in  STD_LOGIC;
       negative: in  STD_LOGIC;
          irbit: in  STD_LOGIC_VECTOR(7 downto 0);
            op2: in  STD_LOGIC_VECTOR(1 downto 0);
          stage: in  STD_LOGIC_VECTOR(1 downto 0);
         pcload: out STD_LOGIC);
end PCL;

architecture dataflow of PCL is
component mux
    Port ( a: in  STD_LOGIC;
           b: in  STD_LOGIC;
           c: in  STD_LOGIC;
           d: in  STD_LOGIC;
          s1: in  STD_LOGIC;
          s0: in  STD_LOGIC;
           y: out STD_LOGIC);
end component;

signal m: STD_LOGIC;
signal n: STD_LOGIC;
signal o: STD_LOGIC;
signal p: STD_LOGIC;
signal q: STD_LOGIC;
signal r: STD_LOGIC;
signal s: STD_LOGIC;

begin
    m0: mux port map ( a => zero,
                       b => m, --not zero
                       c => n, --not zero(m) and not negative(s)
                       d => negative,
                      s1 => op2(1),
                      s0 => op2(0),
                       y => o); --m0
    m1: mux port map ( a => '1',
                       b => irbit(7),
                       c => p, --q or r
                       d => '0',
                      s1 => stage(1),
                      s0 => stage(0),
                       y => pcload);
    m <= not zero;
    n <= m and p;
    p <= q or r;
    q <= o and irbit(7) and (not irbit(6));
    r <= irbit(4) and irbit(5) and irbit(6) and irbit(7);
    s <= not negative;
end dataflow;