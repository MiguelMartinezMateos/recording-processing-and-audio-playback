----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 14.10.2020 13:20:01
-- Design Name: 
-- Module Name: en_4_cycles_tb - Behavioral
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

entity en_4_cycles_tb is
end en_4_cycles_tb;

architecture Behavioral of en_4_cycles_tb is

--component declaration
    component en_4_cycles Port ( 
        clk_12megas, reset : in STD_LOGIC;
        clk_3megas, en_2_cycles, en_4_cycles : out STD_LOGIC );
    end component;

--input signals declaration
    signal clk_12megas, rst: std_logic;

--output signals declaration
    signal clk_3megas, en_2_cycles, en_4cycles: std_logic;
    
--Clock peroid
    constant clk_period : time := 83.3333 ns;

begin

--DUT instantiation
    DUT : en_4_cycles port map(clk_12megas => clk_12megas,
                               reset => rst,
                               clk_3megas => clk_3megas,
                               en_2_cycles => en_2_cycles,
                               en_4_cycles => en_4cycles);

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
		rst <= '1'; 
		wait for 30 ns; rst <= '0';		
		wait;
	end process;

end Behavioral;