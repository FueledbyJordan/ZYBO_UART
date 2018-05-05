----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2018 06:41:34 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    Port ( clk : in std_logic;
           reset : in std_logic;
           rx_in : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           rx_done,tx_done : out std_logic;
           tx_start : in std_logic;
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           data_in : in STD_LOGIC_VECTOR (7 downto 0));
end UART;

architecture Behavioral of UART is
    component BaudGen 
        generic(
            N : integer := 10;
            M : integer := 354
        );
        
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               max_tick : out STD_LOGIC;
               tick_out : out STD_LOGIC_vector(N-1 downto 0));
    end component;
    
    component Receiver
         generic(
           DBIT: integer := 8;
           SB_TICK: integer := 16
         );
         Port ( 
           clk          : in std_logic;
           rst          : in std_logic;
           rx           : in std_logic;
           s_tick       : in std_logic;
           rx_done_tick : out std_logic;
           dout         : out std_logic_vector(7 downto 0);
           state_out    : out std_logic_vector(1 downto 0)
         );
     end component;
     
     component Transmitter
         generic(
               DBIT : integer := 8;
               SB_TICK : integer := 16
             );
         
         Port ( clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                tx_start : in STD_LOGIC;
                s_tick : in STD_LOGIC;
                din : in STD_LOGIC_VECTOR (7 downto 0);
                tx_done_tick : out STD_LOGIC;
                tx : out STD_LOGIC;
                state : out std_logic_vector(1 downto 0));
    end component;
    
  signal max_tick_temp : std_logic;
  signal tick_out_temp : std_logic_vector(9 downto 0);  
  signal dout_temp,din_temp : std_logic_vector (7 downto 0);
  signal RX_state,TX_state : std_logic_vector (1 downto 0);
  
begin
BG : BaudGen 
    port map (clk=>clk, reset=>reset,max_tick=>max_tick_temp,tick_out=>tick_out_temp); 
RX : Receiver 
    port map (clk=>clk, rst=>reset,rx=>rx_in,s_tick=>max_tick_temp,rx_done_tick=>rx_done,dout=>dout_temp,state_out=>RX_state);
TX : Transmitter
    port map (clk=>clk, reset=>reset,tx_start=>tx_start,s_tick=>max_tick_temp,din=>din_temp,tx_done_tick=>tx_done,tx=>tx_out,state=>tx_state);

end Behavioral;
