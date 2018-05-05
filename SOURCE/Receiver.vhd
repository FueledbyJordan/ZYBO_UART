----------------------------------------------------------------------------------
-- Company: the University of North Carolina at Charlotte
-- Engineer: Roy Helms
-- 
-- Create Date: 04/22/2018 02:29:59 PM
-- Design Name: Team 6
-- Module Name: Receiver - Behavioral
-- Project Name: Project 2 - UART communication
-- Target Devices: 
-- Tool Versions: 
-- Description: This file will generater the receiver in the UART system.
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Receiver is
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
end Receiver;

architecture Behavioral of Receiver is
type state_type is (idle, start, data, stop);
signal state_reg, state_next: state_type;
signal s_reg, s_next: unsigned(3 downto 0);
signal n_reg, n_next: unsigned(2 downto 0);
signal b_reg, b_next: std_logic_vector(7 downto 0);

begin

  process(clk,rst)
    begin
      if (rst = '1') then
        state_reg <= idle;
        s_reg <= (others => '0');
        n_reg <= (others => '0');
        b_reg <= (others => '0');
      
      elsif(clk'event and clk = '1') then
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
      end if;
    end process;
    
  process(state_next)
    begin
      case state_next is
        when idle =>
          state_out <= "00";
        when start =>
          state_out <= "01";
        when data =>
          state_out <= "10";
        when stop =>
          state_out <= "11";
        end case;
      end process;
      
  process(state_reg, s_tick, rx, s_reg, n_reg, b_reg, s_tick, rx)
    begin
      state_next <= state_reg;
      s_next <= s_reg;
      n_next <= n_reg;
      b_next <= b_reg;
      rx_done_tick <= '0';
      
      case state_reg is
        when idle =>
          if (rx = '0') then
            s_next <= (others => '0');
            state_next <= start;
          else
            state_next <= idle;
          end if;
        
        when start =>
          if (s_tick'event and s_tick = '1') then
            if (s_reg = 7) then
              s_next <= (others => '0');
              n_next <= (others => '0');
              state_next <= data;
            else
              s_next <= s_reg + 1;
              state_next <= start;
            end if;
          end if;
        
        when data =>
          if (s_tick'event and s_tick = '1') then
            if (s_reg = 15) then
              s_next <= (others => '0');
              b_next <= rx & b_reg(7 downto 1);
              if (n_reg = (DBIT - 1)) then
                state_next <= stop;
              else
                n_next <= n_reg + 1;
                state_next <= data;
              end if;
            else
              s_next <= s_reg + 1;
              state_next <= data;
            end if;
          end if;
          dout <= b_reg;
          
        when stop =>
          if (s_tick'event and s_tick = '1') then
            if (s_reg = (SB_TICK - 1)) then 
              rx_done_tick <= '1';
              state_next <= idle;
            else
              s_next <= s_reg + 1;
              state_next <= stop;
            end if;
          end if;
      end case;
    end process;   


end Behavioral;
