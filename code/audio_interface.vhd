----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 25.11.2020 12:48:37
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

entity audio_interface is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           --Recording ports
            --To/From the controller
            record_enable : in STD_LOGIC;
            sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
            sample_out_ready : out STD_LOGIC;
            --To/From the microphone
            micro_clk : out STD_LOGIC;
            micro_data : in STD_LOGIC;
            micro_LR : out STD_LOGIC;
            --Playing ports
            --To/From the controller
            play_enable : in STD_LOGIC;
            sample_in : in std_logic_vector(sample_size-1 downto 0);
            sample_request : out std_logic;
            --To/From the mini-jack
            jack_sd : out STD_LOGIC;
            jack_pwm : out STD_LOGIC);
end audio_interface;

architecture Behavioral of audio_interface is

--component declaration
    component en_4_cycles Port ( 
        clk_12megas, reset : in STD_LOGIC;
        clk_3megas, en_2_cycles, en_4_cycles : out STD_LOGIC );
    end component;
    
    component FSMD_microphone port ( 
        clk_12megas, reset, enable_4_cycles, micro_data : in STD_LOGIC;
        sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_out_ready : out STD_LOGIC );
    end component;
    
    component pwm Port ( 
        clk_12megas, reset, en_2_cycles : in STD_LOGIC;
        sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_request, pwm_pulse : out STD_LOGIC);
    end component;

--aux signals declaration
    signal en_2cycles, en_4cycles ,en4, en2 :std_logic;
    
begin

    --aux signals
    en4 <= en_4cycles and record_enable;
    en2 <= en_2cycles and play_enable;
    
    --DUT instantiation                                    
    DUT1 : en_4_cycles port map(clk_12megas => clk_12megas,
                                reset => reset,
                                clk_3megas => micro_clk,
                                en_2_cycles => en_2cycles,
                                en_4_cycles => en_4cycles);
                                
    DUT2 : FSMD_microphone port map(clk_12megas => clk_12megas,
                                    reset => reset,
                                    enable_4_cycles => en4,
                                    micro_data => micro_data,
                                    sample_out => sample_out,
                                    sample_out_ready => sample_out_ready);
    
    DUT3 : pwm port map(clk_12megas => clk_12megas,
                        reset => reset,
                        en_2_cycles => en2,
                        sample_in => sample_in,
                        sample_request => sample_request,
                        pwm_pulse => jack_pwm);

    jack_sd <= '1';
    micro_LR <= '1';

end Behavioral;
