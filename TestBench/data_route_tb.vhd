----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 02.12.2020 13:23:39
-- Design Name: 
-- Module Name: data_route_tb - Behavioral
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

entity data_route_tb is
--  Port ( );
end data_route_tb;

architecture Behavioral of data_route_tb is

--component declaration
    component data_route
        Port ( c0 : in signed (sample_size-1 downto 0);
               c1 : in signed (sample_size-1 downto 0);
               c2 : in signed (sample_size-1 downto 0);
               c3 : in signed (sample_size-1 downto 0);
               c4 : in signed (sample_size-1 downto 0);
               x0 : in signed (sample_size-1 downto 0);
               x1 : in signed (sample_size-1 downto 0);
               x2 : in signed (sample_size-1 downto 0);
               x3 : in signed (sample_size-1 downto 0);
               x4 : in signed (sample_size-1 downto 0);
               ctrl : in STD_LOGIC_VECTOR (2 downto 0);
               reset: in STD_LOGIC;
               clk_12megas : in STD_LOGIC;
               y : out signed (sample_size-1 downto 0));
    end component;

--input signal declaration
    signal clk_12megas, reset : STD_LOGIC := '0';	
    signal x0, x1, x2, x3, x4, c0, c1, c2, c3, c4 : signed(sample_size -1 downto 0) := "00000000";
    signal ctrl : std_logic_vector(2 downto 0) := "000";

--output signal declaration
    signal y : signed(sample_size-1 downto 0) := "00000000";

--Clock period
    constant clk_period : time := 83.3333 ns;

begin

--DUT instantiation
	DUT1: data_route Port Map( clk_12megas => clk_12megas,
                               x0 => x0,
                               x1 => x1,
                               x2 => x2,
                               x3 => x3,
                               x4 => x4,
                               c0 => c0,
                               c1 => c1,
                               c2 => c2,
                               c3 => c3,
                               c4 => c4,
                               reset => reset,
                               ctrl => ctrl,
                               y => y);

	-- Clock process definitions( clock with 50% duty cycle)
    clk_process :process
    begin
        clk_12megas <= '0';
        wait for clk_period/2;
        clk_12megas <= '1';
        wait for clk_period/2;
    end process;

               
    x0 <= "01111111";	
    x1 <= "01111111";    
    x2 <= "01111111";    
    x3 <= "01111111";    
    x4 <= "01111111";    
    --Coeficientes del filtro paso bajo
    c0 <= "00000101";    
    c1 <= "00011111";    
    c2 <= "00111001";    
    c3 <= "00011111";    
    c4 <= "00000101";    
        
    reset <= '1', '0' after 5 ns;    
        
    ctrl <= "000", 
            "001" after 83 ns,
            "010" after 167 ns,
            "011" after 250 ns,
            "100" after 333 ns,
            "101" after 417 ns,
            "110" after 500 ns,
            "111" after 583 ns,
            "001" after 667 ns,
            "010" after 750 ns,
            "011" after 833 ns,
            "100" after 917 ns;           
    
end Behavioral;
