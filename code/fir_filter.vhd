----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez 
-- 
-- Create Date: 08.12.2020 17:36:08
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            sample_in : in signed (sample_size-1 downto 0);
            sample_in_enable : in STD_LOGIC;
            filter_select: in STD_LOGIC; --0 lowpass, 1 highpass
            sample_out : out signed (sample_size-1 downto 0);
            sample_out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is

--component declaration
    component data_route
    Port (  clk_12megas : in STD_LOGIC;
            reset : in STD_LOGIC;
            c0 : in signed (sample_size-1 downto 0);
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
            y : out signed (sample_size-1 downto 0));
    end component;
    
    component FSMD_fir
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            new_sample : in STD_LOGIC;
            ctrl1 : out STD_LOGIC_VECTOR (2 downto 0);
            ctrl2 : out STD_LOGIC_VECTOR (2 downto 0);
            ready : out STD_LOGIC);
    end component;

--inout signals declaration    
    signal c0, c1, c2, c3, c4 : signed (sample_size-1 downto 0);
    signal x0, x1, x2, x3, x4 : signed (sample_size-1 downto 0);
    signal ctrl1, ctrl2 : STD_LOGIC_VECTOR (2 downto 0);

begin

    process (clk, sample_in_enable, reset)
    begin
        if (reset = '1') then
            x0 <= (others => '0');
            x1 <= (others => '0');
            x2 <= (others => '0');
            x3 <= (others => '0');
            x4 <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (sample_in_enable = '1') then
                x0 <= sample_in;
                x1 <= x0;
                x2 <= x1;
                x3 <= x2;
                x4 <= x3;
            end if;
        end if;
    end process;
    
    process(filter_select)
    begin
        if (filter_select = '0') then
            c0 <= c0_FPB;
            c1 <= c1_FPB;
            c2 <= c2_FPB;
            c3 <= c3_FPB;
            c4 <= c4_FPB;
        else
            c0 <= c0_FPA;
            c1 <= c1_FPA;
            c2 <= c2_FPA;
            c3 <= c3_FPA;
            c4 <= c4_FPA;
        end if;
    end process;
    
    
--DUT instantiation
    DUT1 : data_route
    port map (
        clk_12megas => clk,
        reset => reset,
        c0 => c0,
        c1 => c1,
        c2 => c2,
        c3 => c3,
        c4 => c4,
        x0 => x0,
        x1 => x1,
        x2 => x2,
        x3 => x3,
        x4 => x4,
        ctrl1 => ctrl1,
        ctrl2 => ctrl2,
        y => sample_out
    );

    DUT2 : FSMD_fir
    port map (
        clk => clk,
        reset => reset,
        new_sample => sample_in_enable,
        ctrl1 => ctrl1,
        ctrl2 => ctrl2,
        ready => sample_out_ready
    );

end Behavioral;
