library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_tb is
end entity;

architecture a_toplevel_tb of toplevel_tb is
    component toplevel is
        port(
            clk, rst : in std_logic;
            constante_externa : in unsigned(15 downto 0);
            mux_acumulador, wr_en_acumulador : in std_logic;
            mux_ula_b : in std_logic;
            selec_op_ula : in unsigned(1 downto 0);
            wr_en_banco : in std_logic;
            reg_sel_read, reg_sel_write : in unsigned(2 downto 0);
            saida : out unsigned(15 downto 0);
            flag_z, flag_n, flag_c : out std_logic
        );
    end component;

    signal finished : std_logic := '0';
    signal clk, rst : std_logic;
    signal constante_externa : unsigned(15 downto 0);
    signal mux_acc, wr_acc, mux_ula, wr_banco : std_logic;
    signal op_ula : unsigned(1 downto 0);
    signal sel_rd, sel_wr : unsigned(2 downto 0);
    signal monitor : unsigned(15 downto 0);
    signal fz, fn, fc : std_logic;

begin
    uut: toplevel port map (
        clk => clk, rst => rst, constante_externa => constante_externa,
        mux_acumulador => mux_acc, wr_en_acumulador => wr_acc,
        mux_ula_b => mux_ula, selec_op_ula => op_ula,
        wr_en_banco => wr_banco, reg_sel_read => sel_rd,
        reg_sel_write => sel_wr, saida => monitor,
        flag_z => fz, flag_n => fn, flag_c => fc
    );

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0'; wait for 50 ns;
            clk <= '1'; wait for 50 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        -- 1. Reset Global
        rst <= '1';
        wait for 200 ns;
        rst <= '0';
        wr_acc <= '0'; wr_banco <= '0';
        wait for 100 ns;

        -- 2. LD: Carrega 50 no Acumulador
        constante_externa <= x"0032";
        mux_acc <= '1'; -- Escolhe constante
        wr_acc <= '1';
        wait for 100 ns;
        wr_acc <= '0';

        -- 3. MOV Rn, A: Salva Acc (50) no Reg 1
        sel_wr <= "001";
        wr_banco <= '1';
        wait for 100 ns;
        wr_banco <= '0';

        -- 4. ADDI: Acc = Acc + 10
        constante_externa <= x"000A";
        mux_ula <= '1';  -- cte
        op_ula <= "00"; 
        mux_acc <= '0';
        wr_acc <= '1';
        wait for 100 ns;
        wr_acc <= '0';

        -- 5. CMPR: Acc (60) com Reg 1 (50)
        sel_rd <= "001";
        mux_ula <= '0'; 
        op_ula <= "01";
        wr_acc <= '0';   -- não grava
        wr_banco <= '0';
        wait for 100 ns;

        finished <= '1';
        wait;
    end process;
end architecture;