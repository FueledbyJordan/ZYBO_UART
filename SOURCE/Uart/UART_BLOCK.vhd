----------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity uart is
    port (
        clock : in std_logic;
        uart_read_en : in std_logic;
        uart_write_en : in std_logic;
        uart_byte_in : in std_logic_vector(7 downto 0);
        uart_byte_out : out std_logic_vector(7 downto 0);
        uart_tx_done : out std_logic
    );
end uart;
 
architecture behave of uart is
 
    component uart_tx is
        generic (
            g_CLKS_PER_BIT : integer := 1085   -- Needs to be set correctly
        );
        port (
            i_clk : in std_logic;
            i_tx_dv : in std_logic;
            i_tx_byte : in std_logic_vector(7 downto 0);
            o_tx_active : out std_logic;
            o_tx_serial : out std_logic;
            o_tx_done : out std_logic
        );
    end component uart_tx;
  
    component UART_RX is
        generic (
            g_CLKS_PER_BIT : integer := 1085     -- Needs to be set correctly
        );
        port (
            i_Clk       : in  std_logic;
            i_RX_Serial : in  std_logic;
            o_RX_DV     : out std_logic;
            o_RX_Byte   : out std_logic_vector(7 downto 0)
        );
    end component;
 
   
  -- Clock Frequency is 125MHz
  -- Want to interface to 115,200 baud UART
  -- 125,000,000 / 115,200 = 1085 Clocks Per Bit.
constant c_CLKS_PER_BIT : integer := 1085;

signal tx_pin : std_logic; 
signal rx_pin : std_logic;
signal rx_DV : std_logic;
  
begin
 
  -- Instantiate UART transmitter
    UART_TX_INST : uart_tx
        generic map (
            g_CLKS_PER_BIT => c_CLKS_PER_BIT
        )
        port map (
            i_clk       => clock,
            i_tx_dv     => uart_write_en,
            i_tx_byte   => uart_byte_in,
            o_tx_active => open,
            o_tx_serial => tx_pin,
            o_tx_done   => uart_tx_done
        );
      
    UART_RX_INST : uart_rx
        generic map (
            g_CLKS_PER_BIT => c_CLKS_PER_BIT
        )
        port map (
            i_Clk       => clock,
            i_RX_Serial => rx_pin,
            o_RX_DV     => rx_DV,
            o_RX_Byte   => uart_byte_out
        ); 
end behave;