----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 06.11.2019 12:53:22
-- Design Name: 
-- Module Name: package_dsed - Behavioral
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

package package_dsed is

    constant sample_size: integer := 8;
    
    constant cont_size : std_logic_vector (sample_size downto 0) := "100101011"; --299     
    constant sample_in_zero : std_logic_vector (sample_size-1 downto 0) := (others => '0'); 

    --Coeficientes del filtro paso bajo
    constant c0_FPB, c4_FPB : signed(sample_size -1 downto 0) := "00000101"; --to_signed(5,8);
    constant c1_FPB, c3_FPB : signed(sample_size -1 downto 0) := "00011111";
    constant c2_FPB : signed(sample_size -1 downto 0) := "00111001";
    --Coeficientes del filtro paso alto
    constant c0_FPA, c4_FPA : signed(sample_size -1 downto 0) := "11111111";
    constant c1_FPA, c3_FPA : signed(sample_size -1 downto 0) := "11100110";
    constant c2_FPA : signed(sample_size -1 downto 0) := "01001101";
    
end package_dsed;


