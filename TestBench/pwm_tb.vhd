----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 20.11.2020 12:56:50
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_tb is
end pwm_tb;

architecture Behavioral of pwm_tb is

--component declaration
    component pwm Port ( 
        clk_12megas, reset, en_2_cycles : in STD_LOGIC;
        sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_request, pwm_pulse : out STD_LOGIC);
    end component;

    component en_4_cycles Port ( 
        clk_12megas, reset : in STD_LOGIC;
        clk_3megas, en_2_cycles, en_4_cycles : out STD_LOGIC);
    end component;
    
--input signals declaration
    signal clk_12megas, rst: std_logic;
    signal sample_in : std_logic_vector (sample_size-1 downto 0);

--output signals declaration
    signal clk_3megas, en_2cycles, en_4cycles, sample_request, pwm_pulse: std_logic;
    
--Clock period
    constant clk_period : time := 83.3333 ns;

begin


    --DUT instantiation                                    
    DUT1 : en_4_cycles port map(clk_12megas => clk_12megas,
                                reset => rst,
                                clk_3megas => clk_3megas,
                                en_2_cycles => en_2cycles,
                                en_4_cycles => en_4cycles);
                                
    DUT2 : pwm port map(clk_12megas => clk_12megas,
                        reset => rst,
                        en_2_cycles => en_2cycles,
                        sample_in => sample_in,
                        sample_request => sample_request,
                        pwm_pulse => pwm_pulse);

	-- Clock process definitions( clock with 50% duty cycle)
    clk_process :process
    begin
        clk_12megas <= '0';
        wait for clk_period/2;
        clk_12megas <= '1';
        wait for clk_period/2;
    end process;
    
    in_process :process
    begin
        rst <= '1'; sample_in <= "11111111";
        wait for 10 ns; rst <= '0';
        wait for 1000us; sample_in <= "00000000";
        wait for 1000us; sample_in <= "11010010";
        wait for 1000us; sample_in <= "11100011";
        wait;
    end process;

end Behavioral;
