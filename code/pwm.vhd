----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez 
-- 
-- Create Date: 20.11.2020 11:38:01
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

    signal cont_reg, cont_next : std_logic_vector (sample_size downto 0);
    signal pwm_reg, pwm_next, sample_req_reg, sample_req_next : std_logic;

begin

    SYNC_PROC : process(clk_12megas,reset)
    begin
        if(reset = '1') then
            cont_reg <= (others => '0');
            pwm_reg <= '0';
            sample_req_reg <= '0';
        elsif(clk_12megas'event and clk_12megas= '1') then
           cont_reg <= cont_next;
           pwm_reg <= pwm_next;
           sample_req_reg <= sample_req_next;
        end if;    
    end process;
    
    OUTPUT_DECODE : process(cont_reg, pwm_reg, sample_req_reg, en_2_cycles, sample_in)
    begin
        cont_next <= cont_reg;
        pwm_next <= '0';
        sample_req_next <= '0';
        
        --logica contador
        if (en_2_cycles = '1') then 
            if (cont_reg = cont_size) then
                cont_next <= (others => '0');
            else
                cont_next <= std_logic_vector(unsigned(cont_reg) + 1);
            end if;
        end if;
        
        --logica pwm
        if ((cont_reg < ('0'&sample_in)) or (sample_in = sample_in_zero)) then
            pwm_next <= '1';
        end if;
        
        --logica sample_req
        if ((en_2_cycles = '1') and (cont_reg = cont_size)) then 
            sample_req_next <= '1';
        end if;
        
    end process;
    
    --output logic
    sample_request <= sample_req_reg;
    pwm_pulse <= pwm_reg;

end Behavioral;
