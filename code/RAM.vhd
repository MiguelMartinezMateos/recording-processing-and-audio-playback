----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez
-- 
-- Create Date: 13.12.2020 13:20:40
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
    PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;                         --enable
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);      --0 read, 1 write
        addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);   --addres to read/write
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);     --data in add
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)    --data out add
    );
end RAM;

architecture Behavioral of RAM is

    component blk_mem_gen_0 is
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    end component;

begin

    RAM: blk_mem_gen_0 port map( clka => clka,
                                 ena => ena,
                                 wea => wea,
                                 addra => addra,
                                 dina => dina,
                                 douta => douta );

end Behavioral;
