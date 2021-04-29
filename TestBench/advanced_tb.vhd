----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez 
-- 
-- Create Date: 11.12.2020 11:36:52
-- Design Name: 
-- Module Name: advanced_tb - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

use std.textio.all;

entity advanced_tb is
--  Port ( );
end advanced_tb;

architecture Behavioral of advanced_tb is

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
    signal clk, Reset, filter_select, Sample_In_enable : STD_LOGIC := '0';
    signal Sample_In : signed(sample_size-1 downto 0) := (others => '0');

--output signal declaration
    signal Sample_Out : signed(sample_size-1 downto 0) := (others => '0');
    signal Sample_Out_ready : STD_LOGIC := '0';

--aux signal declaration
    signal Sample_Out_matlab : integer;
    signal control : STD_LOGIC := '1'; --control para selecionar un fichero de salida diferente segun el filtro

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

    read_process : process (clk) 
    file in_file : text open read_mode IS "C:\Users\Lucas de Miguel\Documents\Dsed\Proyecto\Matlab\sample_in.dat"; 
    
    variable in_line : line; 
    variable in_int : integer;  
    variable in_read_ok : BOOLEAN; 
    
    begin 
        if (clk'event and clk = '1') then 
            if(sample_in_enable = '1') then
                if NOT endfile(in_file) then 
                    ReadLine(in_file,in_line); 
                    Read(in_line, in_int, in_read_ok); 
                    sample_in <= to_signed(in_int, sample_size); -- 8 = the bit width 
                else 
                    assert false report "Simulation Finished" severity failure; 
                end if; 
            end if;       
        end if; 
    end process;
 
    filter_select <= '1'; --0 lowpass, 1 highpass
 
    write_process : process (Sample_Out_ready,filter_select)
    file out_file : text;
    
    variable out_line : line;
    
    begin
        if(control='1') then
            if(filter_select='0') then
                file_open(out_file,"C:\Users\Lucas de Miguel\Documents\Dsed\Proyecto\Matlab\sample_out_lp.dat",write_mode); 
             else
                file_open(out_file,"C:\Users\Lucas de Miguel\Documents\Dsed\Proyecto\Matlab\sample_out_hp.dat",write_mode); 
             end if;
         end if;
         control <= '0';
         if (Sample_Out_ready = '1') then
             Sample_Out_matlab <= to_integer(Sample_Out);
             write(out_line, Sample_Out_matlab, left, sample_size);
             writeline(out_file, out_line);
         end if;        
    end process;    

     reset <= '1', '0' after 50 us;
    
    valores_process : process
    begin
        wait for 50 us; 
        Sample_In_enable <= '1';
        wait for 80 ns; 
        Sample_In_enable <= '0';
    end process;

end Behavioral;
