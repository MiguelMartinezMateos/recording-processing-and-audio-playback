----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 27.11.2020 17:11:06
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port (
        CLK100MHZ : in std_logic;
        reset: in std_logic;
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC
        );
end controlador;

architecture Behavioral of controlador is

--component declaration
    component clk_12megas
        Port ( CLK100MHZ : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_12megas : out STD_LOGIC);
    end component;
          
    component audio_interface
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
    signal clk_12megas_signal: STD_LOGIC;
    signal sample_in : STD_LOGIC_VECTOR(sample_size-1 downto 0);
    signal sample_in_s : signed (8 downto 0);
    signal sample_in_s2 : signed (10 downto 0);
  
--output signals declaration
    signal sample_out : STD_LOGIC_VECTOR(sample_size-1 downto 0);
    signal sample_out_ready_signal, sample_request_signal : STD_LOGIC;

begin

    --DUT instantiation
    DUT1:  clk_12megas PORT MAP ( CLK100MHZ => CLK100MHZ,
                                  rst => reset,             
                                  clk_12megas => clk_12megas_signal );
                 
               
    DUT2:  audio_interface PORT MAP ( clk_12megas => clk_12megas_signal, 
                                      reset => reset, 
                                      record_enable => '1' , 
                                      sample_out => sample_out, 
                                      sample_out_ready => sample_out_ready_signal,
                                      micro_clk => micro_clk,
                                      micro_data => micro_data,
                                      micro_LR => micro_LR,
                                      play_enable => '1',
                                      sample_in => sample_in,
                                      sample_request => sample_request_signal,
                                      jack_sd => jack_sd,
                                      jack_pwm => jack_pwm );
           
    sample_in_s <= signed( '0' & sample_out) - 128;
    sample_in_s2 <= sample_in_s & "00" + 128;
    sample_in <= std_logic_vector(sample_in_s2(9 downto 2));

end Behavioral;
