----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 17.11.2020 19:14:25
-- Design Name: 
-- Module Name: FSDM_microphone_tb - Behavioral
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

entity FSMD_microphone_tb is
end FSMD_microphone_tb;

architecture Behavioral of FSMD_microphone_tb is

--component declaration
    component FSMD_microphone port ( 
            clk_12megas, reset, enable_4_cycles, micro_data : in STD_LOGIC;
            sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
            sample_out_ready : out STD_LOGIC );
    end component;

    component en_4_cycles Port ( 
        clk_12megas, reset : in STD_LOGIC;
        clk_3megas, en_2_cycles, en_4_cycles : out STD_LOGIC );
    end component;
    
--input signals declaration
    signal clk_12megas, rst, micro_data: std_logic;

--output signals declaration
    signal clk_3megas, en_2_cycles, en_4cycles, sample_out_ready: std_logic;
    signal sample_out : std_logic_vector (sample_size-1 downto 0);
    
--Clock period
    constant clk_period : time := 83.3333 ns;

begin

    --DUT instantiation                                    
    DUT1 : en_4_cycles port map(clk_12megas => clk_12megas,
                                reset => rst,
                                clk_3megas => clk_3megas,
                                en_2_cycles => en_2_cycles,
                                en_4_cycles => en_4cycles);
                                
    DUT2 : FSMD_microphone port map(clk_12megas => clk_12megas,
                                    reset => rst,
                                    enable_4_cycles => en_4cycles,
                                    micro_data => micro_data,
                                    sample_out => sample_out,
                                    sample_out_ready => sample_out_ready);

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
		--micro_data constante
--		rst <= '1'; micro_data <= '1';
--		wait for 100 ns; rst <= '0';		
--		wait;
		
		--micro_data aleatorio
		rst <= '1'; micro_data <= '1';
		wait for 100 ns; rst <= '0';
		wait for 1us; micro_data <= '0';
		wait for 3us; micro_data <= '1';
		wait for 1us; micro_data <= '0';
		wait for 10us; micro_data <= '1';
		wait for 40us; micro_data <= '0';
		wait for 5us; micro_data <= '1';
		wait for 20us; micro_data <= '0';
        wait for 10us; micro_data <= '1';
        wait for 15us; micro_data <= '0';
		wait for 25us; micro_data <= '1';
		wait for 10us; micro_data <= '0';
	    wait for 1us; micro_data <= '0';
        wait for 3us; micro_data <= '1';
        wait for 15us; micro_data <= '0';
        wait for 25us; micro_data <= '1';
        wait for 10us; micro_data <= '0';
        wait for 1us; micro_data <= '0';
        wait for 3us; micro_data <= '1';
        wait for 1us; micro_data <= '0';
        wait for 3us; micro_data <= '1';
        wait for 100us; micro_data <= '0';
        wait for 150us; micro_data <= '1';


		wait;
	end process;

end Behavioral;
