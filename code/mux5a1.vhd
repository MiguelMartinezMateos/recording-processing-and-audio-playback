----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 02.12.2020 11:50:08
-- Design Name: 
-- Module Name: mux5a1 - Behavioral
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

entity mux5a1 is
    Port ( in0 : in signed (sample_size-1 downto 0);
           in1 : in signed (sample_size-1 downto 0);
           in2 : in signed (sample_size-1 downto 0);
           in3 : in signed (sample_size-1 downto 0);
           in4 : in signed (sample_size-1 downto 0);
           ctrl : in STD_LOGIC_VECTOR (2 downto 0);
           y : out signed (sample_size-1 downto 0));
end mux5a1;

architecture Behavioral of mux5a1 is

begin

    with ctrl select y <= in0 when "000",
                          in1 when "001",
                          in2 when "010",
                          in3 when "011",
                          in4 when "100",
                          in0 when others;

end Behavioral;
