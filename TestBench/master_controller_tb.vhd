----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 07.01.2021 12:21:10
-- Design Name: 
-- Module Name: master_controller_tb - Behavioral
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

entity master_controller_tb is
--  Port ( );
end master_controller_tb;

architecture Behavioral of master_controller_tb is

--component declaration
    component master_controller is
        Port ( CLK100MHZ : in std_logic; 
               reset: in std_logic;
               --Control ports 
               BTNL: in STD_LOGIC; 
               BTNC: in STD_LOGIC; 
               BTNR: in STD_LOGIC;
               BTNU: in STD_LOGIC; --reset
               SW0: in STD_LOGIC; 
               SW1: in STD_LOGIC; 
               --Microphone 
               micro_clk : out STD_LOGIC; 
               micro_data : in STD_LOGIC; 
               micro_LR : out STD_LOGIC; 
               --Mini-jack 
               jack_sd : out STD_LOGIC; 
               jack_pwm : out STD_LOGIC); 
    end component;


--input signals declaration
    signal CLK100MHZ, reset, BTNL, BTNC, BTNR, BTNU, SW0, SW1, micro_data: std_logic;

--output signals declaration
    signal micro_clk, micro_LR, jack_sd, jack_pwm: std_logic;
    
--Clock period
    constant clk_period : time := 10 ns;

--aux signals declaration
    signal signal_1, signal_2, signal_3 : std_logic := '0';

begin

    --DUT instantiation                                    
	DUT:  master_controller PORT MAP (
                CLK100MHZ => CLK100MHZ,
                reset => reset,
                --Control ports 
                BTNL => BTNL,
                BTNC => BTNC,
                BTNR => BTNR,
                BTNU => BTNU, --reset
                SW0 => SW0,
                SW1 => SW1,
                --Microphone 
                micro_clk => micro_clk,
                micro_data => micro_data,
                micro_LR => micro_LR,
                --Mini-jack 
                jack_sd => jack_sd,
                jack_pwm => jack_pwm
                 );

	-- Clock process definitions( clock with 50% duty cycle)
    clk_process :process
    begin
        CLK100MHZ <= '0';
        wait for clk_period/2;
        CLK100MHZ <= '1';
        wait for clk_period/2;
    end process;
    
    in_proccess: process
    begin
        wait for 100 ns;
        signal_1 <= not signal_1 after 1300 ns;
        signal_2 <= not signal_2 after 2100 ns;
        signal_3 <= not signal_3 after 3700 ns;
        micro_data <= '1';
        --micro_data <= signal_1 xor signal_2 xor signal_3;
    end process;
    
    reset <= '0';
    BTNL <= '0', '1' after 1 ms, '0' after 2 ms; --grabar
    BTNC <= '0', '1' after 5 ns, '0' after 6 ns; --borrar
    BTNR <= '0', '1' after 2 ms, '0' after 4 ms; --reproducir
    BTNU <= '0', '1' after 1 ns, '0' after 2 ns;
    SW0 <= '0';
    SW1 <= '0';
    

end Behavioral;
