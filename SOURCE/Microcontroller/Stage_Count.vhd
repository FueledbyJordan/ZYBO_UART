----------------------------------------------------------------------------------
-- Company: The University of North Carolina at Charlotte
-- Engineer: Roy Helms
-- 
-- Create Date: 03/21/2018 03:41:31 PM
-- Design Name: Project 1 - Intro to VHDL
-- Module Name: Stage_Count - Behavioral
-- Project Name: Team 6
-- Target Devices: 
-- Tool Versions: 
-- Description: This file contains the logic for the Stage Counter
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

entity Stage_Count is
  Port ( 
  clk:    in std_logic;
  rst:    in std_logic;
  enable: in std_logic;
  --irbit7: in std_logic;
  stage:  out std_logic_vector(1 downto 0):= "11"
  );
end Stage_Count;

architecture Behavioral of Stage_Count is
signal stage_next: std_logic_vector(1 downto 0) := "11";
--shared variable flag : std_logic := '0';
begin

process(clk, rst, enable)
    begin
        if (enable = '1') then
            if (rst = '1') then
                stage <= "00";
                stage_next <= "00";
            end if;
            if (stage_next = "11") then
                stage_next <= "00";
            elsif (clk'event and clk = '1') then -- could also use "if rising_edge(clk) then ..."
                stage <= stage_next;
                stage_next <= std_logic_vector(unsigned(stage_next) + 1);
--                if stage_next = "10" and irbit7 = '1' and flag = '1' then
--                    flag := '0';
--                    stage_next <= "01";  
--                end if;
            end if;
        end if;
    end process;

--stage_next <= std_logic_vector(unsigned(stage_next) + 1);
    
end Behavioral;
