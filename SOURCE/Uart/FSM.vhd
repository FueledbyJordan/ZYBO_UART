library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Port(
        clock : in std_logic;
        reset : in std_logic;
        rx_pin : in std_logic;
        tx_pin : out std_logic
    );
end entity;

architecture Behavioral of FSM is

component Microcontroller is
    port (
        clk : in std_logic;
        sc_enable : in std_logic;
        DMA_mem_address_in : in std_logic_vector(7 downto 0);
        DMA_mem_rw : in std_logic;
        DMA_mem_data_in : in std_logic_vector(7 downto 0);
        DMA_mem_data_out : out std_logic_vector(7 downto 0);
        sbus : out std_logic_vector(7 downto 0);
        dbus : out std_logic_vector(7 downto 0);
        aluout : out std_logic_vector(7 downto 0);
        immed : out std_logic_vector(7 downto 0);
        aluop : out std_logic_vector(1 downto 0);
        negative : out std_logic;
        zero : out std_logic;
        pcsel : out std_logic;
        stage : out std_logic_vector(1 downto 0);
        pcload : out std_logic;
        addressout : out std_logic_vector(7 downto 0);
        irlineout : out std_logic_vector(7 downto 0)
    );
end component;

component uart is
    port (
        clock : in std_logic;
        uart_write_en : in std_logic;
        uart_byte_in : in std_logic_vector(7 downto 0);
        uart_byte_out : out std_logic_vector(7 downto 0);
        tx_pin : out std_logic;
        rx_pin : in std_logic;
        uart_tx_done : out std_logic;
        uart_rx_done : out std_logic
    );
end component;

-- Microcontroller Signals
signal sbus : std_logic_vector(7 downto 0);
signal dbus : std_logic_vector(7 downto 0);
signal aluout : std_logic_vector(7 downto 0);
signal immed : std_logic_vector(7 downto 0);
signal aluop : std_logic_vector(1 downto 0);
signal negative : std_logic;
signal zero : std_logic;
signal pcsel : std_logic;
signal pcload : std_logic;
signal dataout : std_logic_vector(7 downto 0);
signal stage : std_logic_vector (1 downto 0);
signal address : std_logic_vector(7 downto 0);
signal irline : std_logic_vector(7 downto 0);

-- UART Signals
signal uart_read_en : std_logic;
signal uart_write_en : std_logic := '0';
signal uart_byte_in : std_logic_vector(7 downto 0) := X"00";
signal uart_byte_out : std_logic_vector(7 downto 0);
signal uart_tx_done : std_logic;
signal uart_rx_done : std_logic;

-- DMA
signal sc_enable : std_logic;
signal mem_address : std_logic_vector(7 downto 0) := (others => '0');
signal mem_rw : std_logic;
signal mem_data_in : std_logic_vector (7 downto 0);
signal mem_data_out : std_logic_vector(7 downto 0);

-- States
type state_type is (read, execute, write, done);
signal state_reg, state_next : state_type := read;

shared variable counter : integer := 0;

begin
  -- Instantiate UART transmitter
    UART_INST : uart
        port map (
            clock => clock,
            uart_write_en => uart_write_en,
            uart_byte_in => uart_byte_in,
            uart_byte_out => uart_byte_out,
            tx_pin => tx_pin,
            rx_pin => rx_pin,
            uart_tx_done => uart_tx_done,
            uart_rx_done => uart_rx_done
        );

  -- Instantiate UART transmitter
    MC_INST : Microcontroller
        port map (
            clk => clock,
            sc_enable => sc_enable,
            DMA_mem_address_in => mem_address,
            DMA_mem_rw => mem_rw,
            DMA_mem_data_in => mem_data_in,
            DMA_mem_data_out => mem_data_out,
            sbus => sbus,
            dbus => dbus,
            aluout => aluout,
            immed => immed,
            aluop => aluop,
            negative => negative,
            zero => zero,
            pcsel => pcsel,
            stage => stage,
            pcload => pcload,
            addressout => address,
            irlineout => irline
        );

    -- state change
    process(clock,reset,state_reg)
    begin
        if reset = '1' then
            state_reg <= read;
        elsif (clock'event and clock = '1') then
            state_reg <= state_next;
        end if;
    end process;

    -- next state logic
    process(state_reg, clock, uart_byte_out, uart_tx_done, uart_rx_done)
    variable address_temp : std_logic_vector(7 downto 0) := (others => '0');
    variable toggle : std_logic := '1';
    begin
        if (rising_edge(clock)) then
            case state_reg is
                when read =>
                    sc_enable <= '0';
                    mem_rw <= '1';
                    if uart_byte_out = X"72" then
                        state_next <= execute;
                    else
                        if uart_rx_done = '1' then
                            mem_address <= address_temp;
                            if uart_byte_out = X"73" then
                                address_temp := X"40";
                            elsif uart_byte_out = X"72" then

                            else
                                mem_data_in <= uart_byte_out;
                                address_temp := std_logic_vector(to_unsigned(((to_integer(unsigned(address_temp)) + 1) MOD 256), address_temp'length));
                            end if;
                        end if;
                        state_next <= read;
                    end if;
                when execute =>
                    --sc_enable <= '1';
                    state_next <= write;
                when write =>
                    sc_enable <= '0';
                    uart_write_en <= '1';
                    mem_rw <= '0';
                    mem_address <= std_logic_vector(to_unsigned(counter, mem_address'length));
                    uart_byte_in <= mem_data_out;
                    if uart_tx_done = '1' then
                        if toggle = '1' then
                            if counter < 256 - 1 then
                                state_next <= write;
                                counter := counter + 1;
                            else
                                state_next <= done;
                                counter := 0;
                            end if;
                        end if;
                        toggle := not toggle;
                    end if;
                 when done =>
                    uart_write_en <= '0';
            end case;
        end if;
    end process;
end Behavioral;
