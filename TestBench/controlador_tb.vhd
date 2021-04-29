----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 27.11.2020 17:52:34
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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

use work.package_dsed.all;

entity controlador_tb is
--  Port ( );
end controlador_tb;

architecture Behavioral of controlador_tb is

--component declaration
    component controlador 
        Port (
            CLK100MHZ : in std_logic;
            reset: in std_logic;
            --To/From the microphone
            micro_clk : out STD_LOGIC;
            micro_data : in STD_LOGIC;
            micro_LR : out STD_LOGIC;
            --To/From the mini-jack
            jack_sd : out STD_LOGIC;
            jack_pwm : out STD_LOGIC);
    end component;

--input signals declaration
    signal clk_100MHz, reset, micro_data : STD_LOGIC := '0';

--output signals declaration
    signal micro_clk, micro_LR, jack_sd, jack_pwm : STD_LOGIC := '0';

--aux signals declaration
    signal signal_1, signal_2, signal_3 : std_logic := '0';

--Clock period
    constant clk_period : time := 10000 ps;
	
begin

--DUT instantiation
    DUT:  controlador PORT MAP ( CLK100MHZ => clk_100MHz, 
                                 reset => reset, 
                                 micro_clk => micro_clk,
                                 micro_data => micro_data,
                                 micro_LR => micro_LR,
                                 jack_sd => jack_sd,
                                 jack_pwm => jack_pwm);

-- Clock process definitions( clock with 50% duty cycle)               
    clk_process :process
        begin
            clk_100MHz <= '0';
            wait for clk_period/2;
            clk_100MHz <= '1';
            wait for clk_period/2;
        end process;
                             
    reset <= '1', '0' after 10 ns;	
          
    micro_data_proccess: process
        begin
            wait for 100 ns;
            signal_1 <= not signal_1 after 1300 ns;
            signal_2 <= not signal_2 after 2100 ns;
            signal_3 <= not signal_3 after 3700 ns;
            micro_data <= signal_1 xor signal_2 xor signal_3;
        end process;

end Behavioral;
