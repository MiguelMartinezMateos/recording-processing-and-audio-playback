----------------------------------------------------------------------------------
-- Company: Grupo 11
-- Engineer: Lucas de Miguel y Miguel Martinez 
-- 
-- Create Date: 16.12.2020 12:10:41
-- Design Name: 
-- Module Name: master_controller - Behavioral
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

entity master_FSMD is
    Port ( clk : in std_logic;
           reset: in std_logic;
           --Botones y Switches
           BTNL: in STD_LOGIC;
           BTNC: in STD_LOGIC;
           BTNR: in STD_LOGIC;
           SW0: in STD_LOGIC;
           SW1: in STD_LOGIC;
           --audio_interface
           record_enable_audio_interface: out STD_LOGIC;
           sample_out_audio_interface: in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_out_ready_audio_interface: in STD_LOGIC;
           play_enable_audio_interface: out STD_LOGIC;
           sample_in_audio_interface: out STD_LOGIC_VECTOR(sample_size-1 downto 0);
           sample_request_audio_interface: in std_logic;
           --fir_filter
           sample_in_fir_filter : out signed (sample_size-1 downto 0);
           sample_in_enable_fir_filter : out STD_LOGIC;
           sample_out_fir_filter : in signed (sample_size-1 downto 0);
           sample_out_ready_fir_filter : in STD_LOGIC;
           --RAM
           addra : out STD_LOGIC_VECTOR (18 downto 0);
           dina : out STD_LOGIC_VECTOR (7 downto 0);
           douta : in STD_LOGIC_VECTOR (7 downto 0);
           ena : out STD_LOGIC;
           wea : out STD_LOGIC_VECTOR (0 downto 0));
end master_FSMD;

architecture Behavioral of master_FSMD is

    type state_type is (reposo, borrar, grabar, reproducir);
    signal state_next, state_reg : state_type;
    signal posicion_next, posicion_reg, posicion_i_next, posicion_i_reg, puntero_next, puntero_reg : STD_LOGIC_VECTOR (18 downto 0);
    signal sample_in_audio_interface_next, sample_in_audio_interface_reg : STD_LOGIC_VECTOR (sample_size-1 downto 0);
    signal sample : STD_LOGIC_VECTOR (sample_size-1 downto 0);

begin

    SYNC_PROC : process (clk, reset)
    begin
        if (reset = '1') then
            state_reg <= reposo;
            posicion_reg <= (others => '0');
            posicion_i_reg <= (others => '0');
            puntero_reg <=  (others => '0');
            sample_in_audio_interface_reg <= (others => '0');                       
        else
            if (clk'event and clk = '1') then
                state_reg <= state_next;
                posicion_reg <= posicion_next;
                posicion_i_reg <= posicion_i_next;
                puntero_reg <= puntero_next;
                sample_in_audio_interface_reg <= sample_in_audio_interface_next;
            end if;
        end if;
    end process;
    
    NEXT_STATE_LOGIC : process (state_reg, posicion_reg, posicion_i_reg, puntero_reg, sample_in_audio_interface_reg, BTNL, BTNR, BTNC, SW0, SW1, sample_out_audio_interface, sample_out_ready_audio_interface, sample_request_audio_interface, sample_out_fir_filter, sample_out_ready_fir_filter, douta)
    begin
        state_next <= reposo;
        posicion_next <= posicion_reg;
        posicion_i_next <= posicion_i_reg;
        puntero_next <= puntero_reg;
        sample_in_audio_interface_next <= sample_in_audio_interface_reg;        
        play_enable_audio_interface <= '0';
        record_enable_audio_interface <= '0';
        sample_in_audio_interface <= (others => '0');
        sample_in_enable_fir_filter <= '0';
        dina <= (others => '0');
        sample_in_fir_filter <= (others => '0');   
        ena <= '1';
        wea <= "0";
        
        case state_reg is
            when reposo =>
                sample_in_audio_interface <= (others => '0');
                if (BTNL = '1') then                                
                    posicion_next <= puntero_reg;
                    if (unsigned(puntero_reg) >= 524287) then 
                        state_next <= reposo;
                    else
                        state_next <= grabar;
                    end if;
                elsif (BTNR = '1') then                             
                    state_next <= reproducir;
                    posicion_next <= (others => '0');
                    posicion_i_next <= puntero_reg;
                    
                elsif (BTNC = '1') then                             
                    state_next <= borrar;
                end if;
            
            when borrar =>
                puntero_next <= (others => '0');
                if (BTNC = '0') then
                    state_next <= reposo;
                else
                    state_next <= borrar;
                end if; 
            
            when grabar =>
                record_enable_audio_interface <= '1'; 
                if (sample_out_ready_audio_interface = '1') then
                    wea <= "1";
                    ena <= '1';
                    posicion_next <= std_logic_vector(unsigned(posicion_reg) + 1);
                    posicion_i_next <= posicion_reg;
                    dina <= sample_out_audio_interface;
                    puntero_next <= posicion_reg;
                end if; 
                if (BTNL = '0' or unsigned(puntero_reg) = 524287) then
                    state_next <= reposo;
                else
                    state_next <= grabar;
                end if; 
            
            when reproducir =>
                wea <= "0";
                play_enable_audio_interface <= '1';
                if (SW1 = '0') then                                 
                    sample_in_audio_interface <= douta;
                    if (sample_request_audio_interface = '1') then
                        if (SW0 = '0') then                         
                            if (posicion_reg = puntero_reg) then
                                state_next <= reposo;
                            else
                                posicion_next <= std_logic_vector(unsigned(posicion_reg) + 1);
                                posicion_i_next <= posicion_reg;
                                state_next <= reproducir;
                            end if;
                        else                                        
                            if (unsigned(posicion_i_reg) = 0) then
                                state_next <= reposo;
                            else
                                posicion_i_next <= std_logic_vector(unsigned(posicion_i_reg) - 1);
                                posicion_next <= posicion_i_reg;
                                state_next <= reproducir;
                            end if;
                        end if;
                    else
                        state_next <= reproducir;
                    end if;
                else                                                
                    sample_in_fir_filter <= signed(not(douta(7)) & douta(6 downto 0));
                    sample_in_audio_interface <= sample_in_audio_interface_reg;
                    sample_in_enable_fir_filter <= '1';
                        
                    if (sample_out_ready_fir_filter = '1') then
                        sample_in_audio_interface_next <= std_logic_vector(not(sample_out_fir_filter(7)) & sample_out_fir_filter(6 downto 0)); 
                    end if;
                    if (sample_request_audio_interface = '1') then
                        sample_in_enable_fir_filter <= '1';
                        if (posicion_reg = puntero_reg) then    
                            state_next <= reposo;
                        else
                            posicion_next <= std_logic_vector(unsigned(posicion_reg) + 1);
                            posicion_i_next <= posicion_reg;
                            state_next <= reproducir;
                        end if;
                    else
                        state_next <= reproducir;
                    end if;
                end if;
        end case;
    end process;
    
    process (SW1, SW0, posicion_reg, posicion_i_reg)
        begin
            addra <= posicion_reg;
            if (SW1 = '0' and SW0 = '1') then
              addra <= posicion_i_reg;  
            end if;
        end process;

end Behavioral;

