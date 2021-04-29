----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 08.12.2020 18:14:11
-- Design Name: 
-- Module Name: fir_filter_tb - Behavioral
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

entity fir_filter_tb is
--  Port ( );
end fir_filter_tb;

architecture Behavioral of fir_filter_tb is

--component declaration
    component fir_filter is
        Port ( clk : in STD_LOGIC; 
               Reset : in STD_LOGIC; 
               Sample_In : in signed (sample_size-1 downto 0); 
               Sample_In_enable : in STD_LOGIC; 
               filter_select: in STD_LOGIC; --0 lowpass, 1 highpass 
               Sample_Out : out signed (sample_size-1 downto 0); 
               Sample_Out_ready : out STD_LOGIC); 
    end component;


--input signal declaration
    signal clk, Reset, Sample_In_enable, filter_select : STD_LOGIC := '0';
    signal Sample_In : signed(sample_size -1 downto 0) := "00000000";

--output signal declaration
    signal Sample_Out_ready : STD_LOGIC := '0';
    signal Sample_Out : signed(sample_size -1 downto 0) := "00000000";
	
--Clock period
    constant clk_period : time := 83.3333 ns;

begin

--DUT instantiation
    DUT1: fir_filter 
        Port Map(
            clk => clk, 
            Reset => Reset,
            Sample_In => Sample_In,
            Sample_In_enable => Sample_In_enable,
            filter_select => filter_select,
            Sample_Out => Sample_Out,
            Sample_Out_ready => Sample_Out_ready);
                          
		 
		 
-- Clock process definitions( clock with 50% duty cycle)
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
                 
                 
     Sample_In <= "00000000", "10000000" after 500ns, "00000000" after 1us;
     filter_select <= '1';
     Reset <= '1', '0' after 2 ns;	
     
     en_process: process
     begin
        Sample_in_enable <= '0';
        wait for clk_period*10;
        Sample_in_enable <= '1';
        wait for clk_period;
     end process;


end Behavioral;
