----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez 
-- 
-- Create Date: 16.12.2020 12:10:41
-- Design Name: 
-- Module Name: master_controller - Behavioral
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

entity master_controller is
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
end master_controller;

architecture Behavioral of master_controller is

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
  
        component fir_filter
            Port ( clk : in STD_LOGIC; 
                   Reset : in STD_LOGIC; 
                   Sample_In : in signed (sample_size-1 downto 0); 
                   Sample_In_enable : in STD_LOGIC; 
                   filter_select: in STD_LOGIC; --0 lowpass, 1 highpass 
                   Sample_Out : out signed (sample_size-1 downto 0); 
                   Sample_Out_ready : out STD_LOGIC); 
        end component;
    
    
        component RAM
            port ( clka : IN STD_LOGIC;
                   ena : IN STD_LOGIC;                         --enable
                   wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);      --0 read, 1 write
                   addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);   --addres to read/write
                   dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);     --data in add
                   douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));  --data out add
        end component;
        
        
        component master_FSMD
            Port ( clk : in std_logic;
                   reset: in std_logic;
                   --Botones y Switches
                   BTNL: in STD_LOGIC;
                   BTNC: in STD_LOGIC;
                   BTNR: in STD_LOGIC;
                   SW0: in STD_LOGIC;
                   SW1: in STD_LOGIC;
                   --audio_interface
                   record_enable_audio_interface: out STD_LOGIC;
                   sample_out_audio_interface: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
                   sample_out_ready_audio_interface: in STD_LOGIC;
                   play_enable_audio_interface: out STD_LOGIC;
                   sample_in_audio_interface: out STD_LOGIC_VECTOR(sample_size-1 downto 0);
                   sample_request_audio_interface: in std_logic;
                   --fir_filter
                   sample_in_fir_filter : out signed (sample_size-1 downto 0);
                   sample_in_enable_fir_filter : out STD_LOGIC;
                   sample_out_fir_filter : in signed (sample_size-1 downto 0);
                   sample_out_ready_fir_filter : in STD_LOGIC;
                   --RAM
                   addra : out STD_LOGIC_VECTOR (18 downto 0);
                   dina : out STD_LOGIC_VECTOR (7 downto 0);
                   douta : in STD_LOGIC_VECTOR (7 downto 0);
                   ena : out STD_LOGIC;
                   wea : out STD_LOGIC_VECTOR (0 downto 0));
            end component;
            
            
--input signals declaration 
    signal clk_12megas_signal: std_logic;
    signal sample_in_audio_interface_signal : std_logic_vector(sample_size-1 downto 0);
    signal sample_in_fir_filter_signal : signed(sample_size-1 downto 0);
    signal sample_request_audio_interface_signal, sample_in_enable_fir_filter_signal : std_logic;
    signal dina_signal : std_logic_vector(7 downto 0);
    
--output signals declaration                 
    signal sample_out_audio_interface_signal : std_logic_vector(sample_size-1 downto 0);
    signal sample_out_fir_filter_signal : signed(sample_size-1 downto 0);
    signal record_enable_audio_interface_signal, sample_out_ready_audio_interface_signal, play_enable_audio_interface_signal, sample_out_ready_fir_filter_signal, ena_signal: std_logic;
    signal addra_signal : std_logic_vector(18 downto 0);
    signal douta_signal : std_logic_vector(7 downto 0);
    signal wea_signal : std_logic_vector(0 downto 0);


begin

    --DUT instantiation
    DUT1:  clk_12megas PORT MAP ( CLK100MHZ => CLK100MHZ,
                                  rst => BTNU,             
                                  clk_12megas => clk_12megas_signal );                  
                 
    DUT2:  audio_interface PORT MAP ( clk_12megas => clk_12megas_signal, 
                                      reset => BTNU, 
                                      record_enable => '1' , 
                                      sample_out => sample_out_audio_interface_signal, 
                                      sample_out_ready => sample_out_ready_audio_interface_signal,
                                      micro_clk => micro_clk,
                                      micro_data => micro_data,
                                      micro_LR => micro_LR,
                                      play_enable => '1',
                                      sample_in => sample_in_audio_interface_signal,
                                      sample_request => sample_request_audio_interface_signal,
                                      jack_sd => jack_sd,
                                      jack_pwm => jack_pwm );
           
    DUT3:  fir_filter PORT MAP ( clk => clk_12megas_signal,
                                 Reset => BTNU,
                                 Sample_In => sample_in_fir_filter_signal,
                                 Sample_In_enable => sample_in_enable_fir_filter_signal,
                                 filter_select => SW0,--0 lowpass, 1 highpass 
                                 Sample_Out => sample_out_fir_filter_signal,
                                 Sample_Out_ready => sample_out_ready_fir_filter_signal ); 
         
    DUT4: RAM PORT MAP ( clka => clk_12megas_signal,
                         ena => ena_signal,
                         wea => wea_signal,
                         addra => addra_signal,
                         dina => dina_signal,
                         douta => douta_signal );
                
    DUT5: master_FSMD PORT MAP ( clk => clk_12megas_signal,
                                 reset=> BTNU,
                                 --Botones y Switches
                                 BTNL => BTNL,
                                 BTNC => BTNC,
                                 BTNR => BTNR,
                                 SW0 => SW0,
                                 SW1 => SW1,
                                 --audio_interface
                                 record_enable_audio_interface => record_enable_audio_interface_signal,
                                 sample_out_audio_interface => sample_out_audio_interface_signal,
                                 sample_out_ready_audio_interface => sample_out_ready_audio_interface_signal,
                                 play_enable_audio_interface => play_enable_audio_interface_signal,
                                 sample_in_audio_interface => sample_in_audio_interface_signal,
                                 sample_request_audio_interface => sample_request_audio_interface_signal,
                                 --fir_filter
                                 sample_in_fir_filter => sample_in_fir_filter_signal,
                                 sample_in_enable_fir_filter => sample_in_enable_fir_filter_signal,
                                 sample_out_fir_filter => sample_out_fir_filter_signal,
                                 sample_out_ready_fir_filter => sample_out_ready_fir_filter_signal,
                                 --RAM
                                 addra => addra_signal,
                                 dina => dina_signal,
                                 douta => douta_signal,
                                 ena => ena_signal,
                                 wea => wea_signal );
 
end Behavioral;
