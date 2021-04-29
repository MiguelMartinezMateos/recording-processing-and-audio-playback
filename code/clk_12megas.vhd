----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 11.11.2020 13:42:32
-- Design Name: 
-- Module Name: clk_12megas - Behavioral
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

entity clk_12megas is
    Port ( CLK100MHZ : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_12megas : out STD_LOGIC;
           lck : out STD_LOGIC);
end clk_12megas;

architecture Behavioral of clk_12megas is
    
    component clk_wiz_0 is              --clk_12MHz
        port ( reset    : in  STD_LOGIC;
               clk_in1  : in  STD_LOGIC;
               clk_out1 : out STD_LOGIC);
    end component;

begin

    CLK12M: clk_wiz_0 port map( reset    => rst,
                                clk_in1  => CLK100MHZ,
                                clk_out1 => clk_12megas);

end Behavioral;
