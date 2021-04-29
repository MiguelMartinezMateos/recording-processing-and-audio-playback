----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 13.12.2020 13:30:57
-- Design Name: 
-- Module Name: RAM_tb - Behavioral
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

entity RAM_tb is
--  Port ( );
end RAM_tb;

architecture Behavioral of RAM_tb is

--component declaration
    component RAM is
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    end component;

--input signals declaration
    signal clka, ena : STD_LOGIC := '0';
    signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '0');
    signal addra : STD_LOGIC_VECTOR(18 DOWNTO 0) := (others => '0');
    signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');

--output signals declaration
    signal douta : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');

--Clock period
    constant clk_period : time := 83.3333 ns;

--axu time DELTA
    constant DELTA : time := 500 ns;

begin

--DUT instantiation
    DUT:  RAM Port Map(
           clka => clka, 
           ena => ena,
           wea => wea,
           addra => addra,
           dina => dina,
           douta => douta);

-- Clock process definitions( clock with 50% duty cycle)               
    clk_process :process
        begin
            clka <= '0';
            wait for clk_period/2;
            clka <= '1';
            wait for clk_period/2;
        end process;

--in process
    ena <= '1';
    in_process: process
        begin
            wea <= "0";
            addra <= "0000000000000000000";
            dina <= "00000000";
            wait for DELTA*2;
            dina <= "10101010";
            wait for DELTA;
            addra <= "0000000000000000001";
            dina <= "11111111";
            wait for DELTA;
            wea <= "1";
            wait for DELTA;
            addra <= "0000000000000000000";
            wait for DELTA;
            addra <= "0000000000000000001";
        end process;

end Behavioral;
