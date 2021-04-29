----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 25.11.2020 13:14:20
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

--component declaration
    component audio_interface is
        Port ( clk_12megas : in STD_LOGIC; 
               reset : in STD_LOGIC; 
               --Recording ports 
               --To/From the controller 
               record_enable: in STD_LOGIC; 
               sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0); 
               sample_out_ready: out STD_LOGIC; 
               --To/From the microphone 
               micro_clk : out STD_LOGIC; 
               micro_data : in STD_LOGIC; 
               micro_LR : out STD_LOGIC; 
               --Playing ports 
               --To/From the controller 
               play_enable: in STD_LOGIC; 
               sample_in: in std_logic_vector(sample_size-1 downto 0); 
               sample_request: out std_logic; 
               --To/From the mini-jack 
               jack_sd : out STD_LOGIC; 
               jack_pwm : out STD_LOGIC); 
    end component;


--input signals declaration
    signal clk_12megas, reset, record_enable, micro_data, play_enable: std_logic;
    signal sample_in : std_logic_vector (sample_size-1 downto 0);

--output signals declaration
    signal sample_out_ready, micro_clk, micro_LR, sample_request, jack_sd, jack_pwm: std_logic;
    signal sample_out : std_logic_vector (sample_size-1 downto 0);
    
--Clock period
    constant clk_period : time := 83.3333 ns;

--aux signals declaration
    signal signal_1, signal_2, signal_3 : std_logic := '0';

begin

    --DUT instantiation                                    
	DUT:  audio_interface PORT MAP (
                clk_12megas => clk_12megas, 
                reset => reset,
                record_enable => record_enable,
                sample_out => sample_out,
                sample_out_ready => sample_out_ready,
                micro_clk => micro_clk,
                micro_data => micro_data,
                micro_LR => micro_LR,
                play_enable => play_enable,
                sample_in => sample_in,
                sample_request => sample_request,
                jack_sd => jack_sd,
                jack_pwm => jack_pwm
                 );

	-- Clock process definitions( clock with 50% duty cycle)
    clk_process :process
    begin
        clk_12megas <= '0';
        wait for clk_period/2;
        clk_12megas <= '1';
        wait for clk_period/2;
    end process;
	
    reset <= '1', '0' after 10 ns;	
    record_enable <= '0', '1' after 40 ns;
    
    in_proccess: process
    begin
        wait for 100 ns;
        signal_1 <= not signal_1 after 1 us;
        signal_2 <= not signal_2 after 2 us;
        signal_3 <= not signal_3 after 3 us;
        --micro_data <= '1';
        micro_data <= signal_1 xor signal_2 xor signal_3;
    end process;
    
    play_enable <= '0', '1' after 30 ns;
    sample_in <= "00000000", 
                 "00100001" after 50 us,
                 "00110011" after 100 us,
                 "01000111" after 150 us,
                 "10001011" after 200 us,
                 "00010001" after 250 us,
                 "00110001" after 300 us;

end Behavioral;
