----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2018 12:34:47 PM
-- Design Name: 
-- Module Name: Register_File - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_File is
    Port ( dwrite : in STD_LOGIC;
           dval : in STD_LOGIC_VECTOR (7 downto 0);
           sregsel : in STD_LOGIC_vector (1 downto 0);
           dregsel : in STD_LOGIC_vector (1 downto 0);
           sbus : out STD_LOGIC_VECTOR (7 downto 0);
           dbus : out STD_LOGIC_VECTOR (7 downto 0);
           Zero : out STD_LOGIC;
           Negative : out STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end Register_File;

architecture Behavioral of Register_File is
    component bit_reg_8
        Port ( clk : in std_logic;
               reset : in std_logic;
               enable : in std_logic;
               Reg_in : in STD_LOGIC_VECTOR (7 downto 0);
               Reg_out : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Mux_4_1
        Port ( in_0 : in STD_LOGIC_VECTOR (7 downto 0);
               in_1 : in STD_LOGIC_VECTOR (7 downto 0);
               in_2 : in STD_LOGIC_VECTOR (7 downto 0);
               in_3 : in STD_LOGIC_VECTOR (7 downto 0);
               op : in std_logic_vector (1 downto 0);
               out_mux : out STD_LOGIC_VECTOR (7 downto 0)
               );
    end component;
    
    component Mux_1_4
        Port ( Mux_in : in STD_LOGIC;
               clk : in std_logic;
               op : in std_logic_vector(1 downto 0);
               out_0 : out STD_LOGIC;
               out_1 : out STD_LOGIC;
               out_2 : out STD_LOGIC;
               out_3 : out STD_LOGIC);
   end component;
   
   signal R0_e,R1_e,R2_e,R3_e : std_logic;
   signal R0_out,R1_out,R2_out,R3_out : std_logic_vector (7 downto 0);
   signal temp_dbus, temp_sbus : std_logic_vector (7 downto 0);
   signal temp_dval : std_logic_vector (7 downto 0);
   signal temp_dregsel : std_logic_vector ( 7 downto 0);
   signal temp_sregsel : std_logic_vector ( 7 downto 0);
begin
temp_dval <= dval;

DMX1 : Mux_1_4 
    port map (Mux_in=>dwrite,clk=>clk,op=>dregsel,out_0=>R0_e,out_1=>R1_e,out_2=>R2_e,out_3=>R3_e);

REG0 : bit_reg_8 
    port map (clk=>clk,reset=>reset,enable=>R0_e,Reg_in=>temp_dval,Reg_out=>R0_out);
REG1 : bit_reg_8 
    port map (clk=>clk,reset=>reset,enable=>R1_e,Reg_in=>temp_dval,Reg_out=>R1_out);
REG2 : bit_reg_8 
    port map (clk=>clk,reset=>reset,enable=>R2_e,Reg_in=>temp_dval,Reg_out=>R2_out);
REG3 : bit_reg_8 
    port map (clk=>clk,reset=>reset,enable=>R3_e,Reg_in=>temp_dval,Reg_out=>R3_out);

DbusMux : Mux_4_1 
    port map (in_0=>R0_out,in_1=>R1_out,in_2=>R2_out,in_3=>R3_out,
            op=>dregsel,out_mux=>temp_dbus);
SbusMux : Mux_4_1 
    port map (in_0=>R0_out,in_1=>R1_out,in_2=>R2_out,in_3=>R3_out,
            op=>sregsel,out_mux=>temp_sbus);

Zero <= NOT(temp_dbus(0) OR temp_dbus(1) OR temp_dbus(2) OR temp_dbus(3) OR temp_dbus(4)
        OR temp_dbus(5) OR temp_dbus(6) OR temp_dbus(7));

Negative <= temp_dbus(7);

dbus <= temp_dbus;
sbus <= temp_sbus;

end Behavioral;
