----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 17.11.2020 18:14:40
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

    signal dato1_reg, dato2_reg, dato1_next, dato2_next, sample_out_reg, sample_out_next : STD_LOGIC_VECTOR (sample_size-1 downto 0) := (others => '0');
    type state is (s0, s1, s2);
    signal state_reg, state_next : state := s0;
    signal cuenta_reg, cuenta_next : integer := 0;
    signal primer_ciclo_reg, primer_ciclo_next, sample_out_ready_reg, sample_out_ready_next : STD_LOGIC := '0';

begin

    SYNC_PROC : process (clk_12megas, reset, enable_4_cycles)
    begin
        if (reset = '1') then
            state_reg <= s0;
            cuenta_reg <= 0;
            dato1_reg <= (others => '0');
            dato2_reg <= (others => '0');
            primer_ciclo_reg <= '0';
            sample_out_reg <= (others => '0');
            sample_out_ready_reg <= '0';
        elsif (clk_12megas'event and clk_12megas = '1') then
            if (enable_4_cycles = '1') then
                state_reg <= state_next;
                cuenta_reg <= cuenta_next;
                dato1_reg <= dato1_next;
                dato2_reg <= dato2_next;
                primer_ciclo_reg <= primer_ciclo_next;
                sample_out_reg <= sample_out_next;
                sample_out_ready_reg <= sample_out_ready_next;
            end if;
        end if;
    end process;
    
    NEXT_STATE_LOGIC: process(state_reg, cuenta_reg, micro_data, primer_ciclo_reg, dato1_reg, dato2_reg, sample_out_reg, sample_out_ready_reg)
    begin
        
        cuenta_next <= cuenta_reg;
        dato1_next <= dato1_reg;
        dato2_next <= dato2_reg;
        sample_out_next <= sample_out_reg;
        sample_out_ready_next <= '0';
        primer_ciclo_next <= primer_ciclo_reg;
        
        case state_reg is
                
            when s0   => 
                if (micro_data = '1') then
                    dato1_next <= std_logic_vector(unsigned(dato1_reg) + 1);
                    dato2_next <= std_logic_vector(unsigned(dato2_reg) + 1);
                end if;
                cuenta_next <= cuenta_reg + 1;
                
            when s1   =>
                if (micro_data = '1') then
                    dato1_next <= std_logic_vector(unsigned(dato1_reg) + 1);
                end if;   
                if ((primer_ciclo_reg = '1') and (cuenta_reg = 106)) then
                    sample_out_next <= dato2_reg;
                    dato2_next <= (others => '0');
                    sample_out_ready_next <= '1';
                else
                    sample_out_ready_next <= '0';
                end if; 
                cuenta_next <= cuenta_reg + 1;
                
            when s2   =>          
                if (cuenta_reg = 299) then
                    cuenta_next <= 0;
                    primer_ciclo_next <= '1';
                else
                    cuenta_next <= cuenta_reg + 1;
                end if;
                if (micro_data = '1') then
                    dato2_next <= std_logic_vector(unsigned(dato2_reg) + 1);
                end if;      
                if (cuenta_reg = 256) then
                    sample_out_next <= dato1_reg;
                    dato1_next <= (others => '0');
                    sample_out_ready_next <= '1';
                else
                    sample_out_ready_next <= '0';
                end if;

        end case;
    end process;
    
    NEXT_STATE_DECODE : process (state_reg,cuenta_reg)
    begin
        state_next <= s0;
        
        case (state_reg) is
            
            when s0 =>
                -- El valor de la condicion de la cuenta es un numero menos ya que tras actualizar estados perdemos un ciclo
                if (cuenta_reg = 254) then
                    state_next <= s2;
                elsif(cuenta_reg = 104) then
                    state_next <= s1;
                end if;  
            
            when s1 =>
                if (cuenta_reg = 148) then
                    state_next <= s0;
                else
                    state_next <= s1;
                end if;          
            
            when s2 =>
                if (cuenta_reg = 299) then
                    state_next <= s0;
                else
                    state_next <= s2;
                end if; 
            
            when others =>
                state_next <= s0;
        
        end case;
    end process;
    
    --Output logic
    sample_out <= sample_out_reg;
    sample_out_ready <= sample_out_ready_reg and enable_4_cycles;

end Behavioral;
