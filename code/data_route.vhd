----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 02.12.2020 12:35:09
-- Design Name: 
-- Module Name: data_route - Behavioral
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

entity data_route is
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
           ctrl1 : in STD_LOGIC_VECTOR (2 downto 0);
           ctrl2 : in STD_LOGIC_VECTOR (2 downto 0);
           reset: in STD_LOGIC;
           clk_12megas : in STD_LOGIC;
           y : out signed (sample_size-1 downto 0));
end data_route;

architecture Behavioral of data_route is

--component declaration    
    component mux5a1 port(
        in0, in1, in2, in3, in4 : in signed (sample_size-1 downto 0);
        ctrl: in STD_LOGIC_VECTOR (2 downto 0);
        y : out signed (sample_size-1 downto 0));
    end component;

--mux out signals declaration
    signal out_c, out_x, out_R3 : signed (sample_size-1 downto 0);
    
--register signals declaration
    signal r1_reg, r1_next, r2_reg, r2_next : signed ((2*sample_size)-1 downto 0);
    signal r3_reg, r3_next : signed(sample_size-1 downto 0);

begin

--MUX instantiation                                    
    MUX1 : mux5a1 port map( in0 => c0,
                            in1 => c1,
                            in2 => c2,
                            in3 => c3,
                            in4 => c4,
                            ctrl => ctrl1,
                            y => out_c);

    MUX2 : mux5a1 port map( in0 => x0,
                            in1 => x1,
                            in2 => x2,
                            in3 => x3,
                            in4 => x4,
                            ctrl => ctrl1,
                            y => out_x);

    MUX3 : mux5a1 port map( in0 => (others => '0'),
                            in1 => r3_reg,
                            in2 => r3_reg,
                            in3 => r3_reg,
                            in4 => r3_reg,
                            ctrl => ctrl2,
                            y => out_R3);

    SYNC_PROC : process(clk_12megas, reset)
    begin
        if(reset = '1') then
            r1_reg <= (others => '0');
            r2_reg <= (others => '0');
            r3_reg <= (others => '0');
        elsif(clk_12megas'event and clk_12megas= '1') then
            r1_reg <= r1_next;
            r2_reg <= r2_next;
            r3_reg <= r3_next;
        end if;
    end process;

--next state logic
    r1_next <= out_c * out_x;
    r2_next <= r1_reg;
    r3_next <= r2_reg((2*sample_size)-2 downto sample_size-1) + out_R3;
    
--output logic
    y <= r3_next;

end Behavioral;
