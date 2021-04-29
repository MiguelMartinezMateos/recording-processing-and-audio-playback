----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 08.12.2020 17:00:29
-- Design Name: 
-- Module Name: FSMD_fir - Behavioral
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

entity FSMD_fir is
    Port ( clk : in STD_LOGIC;
           new_sample : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : out STD_LOGIC;
           ctrl1 : out STD_LOGIC_VECTOR (2 downto 0);
           ctrl2 : out STD_LOGIC_VECTOR (2 downto 0));
end FSMD_fir;

architecture Behavioral of FSMD_fir is

    type state is (idle, s0, s1, s2, s3, s4, s5, s6);
    signal state_reg, state_next : state := idle;

begin

    SYNC_PROC : process (clk, reset)
    begin
        if (reset = '1') then
            state_reg <= idle;
        elsif (clk'event and clk = '1') then
            state_reg <= state_next;
        end if;
    end process;

    NEXT_STATE_LOGIC : process(state_reg)
    begin
        
        ready <= '0';
        --ctrl1 <= "000";
        --ctrl2 <= "000";
        
        case state_reg is
            
            when idle => 
                ctrl1 <= "000";
                ctrl2 <= "000";
                
            when s0   => 
                ctrl1 <= "000";
                
            when s1   =>
                ctrl1 <= "001";
                
            when s2   =>          
                ctrl1 <= "010";
                ctrl2 <= "000";

            when s3   =>          
                ctrl1 <= "011";
                ctrl2 <= "001";
 
             when s4   =>          
                ctrl1 <= "100";
                ctrl2 <= "010";
                
            when s5   => 
                ctrl2 <= "011";
                
            when s6   =>     
                ctrl2 <= "100";
                ready <= '1';
                
        end case;
    end process;
    
    NEXT_STATE_DECODE : process (state_reg, new_sample)
    begin
        state_next <= idle;
        
        case (state_reg) is
            
            when idle =>
                if (new_sample = '1') then
                    state_next <= s0;
                end if;
                
            when s0 =>
                state_next <= s1;
            
            when s1 =>
                state_next <= s2;     
            
            when s2 =>
                state_next <= s3;
            
            when s3 =>
                state_next <= s4; 

            when s4 =>
                state_next <= s5;

            when s5 =>
                state_next <= s6;
            
            when s6 =>
                state_next <= idle;
            
            when others =>
                state_next <= idle;
        
        end case;
    end process;

end Behavioral;
