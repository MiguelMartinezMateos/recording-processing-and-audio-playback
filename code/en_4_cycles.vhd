----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 11.11.2020 13:19:55
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is

    signal current_state, next_state: integer := 0;
    constant cont3 : integer := 3;

begin

    NEXT_STATE_DECODE : process(current_state)
    begin 
        if(current_state < cont3) then
            next_state <= current_state + 1;
        else
            next_state <= 0;
        end if;
    end process;
    
    SYNC_PROC : process(clk_12megas, reset)
    begin
        if(reset = '1') then
            current_state <= 0;
        elsif(clk_12megas'event and clk_12megas= '1') then
            current_state <= next_state;
        end if;
    end process;
    
    --output logic
    clk_3megas <= '1' when (current_state >= 2) else '0';
    en_2_cycles <= '1' when ((current_state = 1) or (current_state = 3)) else '0';
    en_4_cycles <= '1' when ((current_state = 2)) else '0';
    
end Behavioral;
