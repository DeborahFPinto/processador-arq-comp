library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is 
    port(
        clk, rst : in std_logic;
        constante_externa : in unsigned(15 downto 0);
        saida : out unsigned(15 downto 0);
        flag_z, flag_n, flag_c : out std_logic 
    );
end entity;

architecture a_processador of processador is 

    component uc is
        port(
            clk, rst : in std_logic;
            pc_out : out unsigned(6 downto 0);
            instr_out : out unsigned(18 downto 0);
            estado_out : out unsigned(1 downto 0);
            mux_acumulador : out std_logic;
			 wr_en_acumulador : out std_logic;
            mux_ula_b : out std_logic;
            selec_op_ula : out unsigned(1 downto 0);
            wr_en_banco : out std_logic
        );
    end component;

    component ula is
        port(
            entrada_a, entrada_b : in unsigned(15 downto 0);
            selec_op : in unsigned(1 downto 0);
            saida : out unsigned(15 downto 0);
            flag_c, flag_z, flag_n : out std_logic
        );
    end component;

    component banco_regs is
        port(
            clk, rst : in std_logic;
            wr_en : in std_logic;
            reg_sel_read, reg_sel_write : in unsigned(2 downto 0);
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component reg16bits is 
        port (
            clk, rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- sinais
    signal s_mux_acc, s_wr_acc, s_mux_ula, s_wr_banco : std_logic;
    signal s_sel_op_ula : unsigned(1 downto 0);
    signal s_instr : unsigned(18 downto 0);
    signal saida_ula, saida_acumulador, saida_banco : unsigned(15 downto 0);
    signal sinal_mux_ula_b, sinal_mux_acumulador : unsigned(15 downto 0);
	signal s_constante_interna : unsigned(15 downto 0);

begin 
    -- pega os 12 MSB da instrução e ajusta p/16 com sinal
	s_constante_interna <= unsigned(resize(signed(s_instr(11 downto 0)), 16));

    -- fiação
    controle : uc port map(
        clk => clk, rst => rst,
        instr_out => s_instr,
        mux_acumulador => s_mux_acc, wr_en_acumulador => s_wr_acc,
        mux_ula_b => s_mux_ula, selec_op_ula => s_sel_op_ula,
        wr_en_banco => s_wr_banco
    );

	sinal_mux_ula_b <= saida_banco when s_mux_ula = '0' else s_constante_interna;
	sinal_mux_acumulador <= saida_ula when s_mux_acc = '0' else s_constante_interna;

    acumulador_ula : reg16bits port map(clk, rst, s_wr_acc, sinal_mux_acumulador, saida_acumulador);
    
    banco : banco_regs port map(
        clk, rst, s_wr_banco, 
        s_instr(14 downto 12), s_instr(14 downto 12), 
        saida_acumulador, saida_banco
    );

    ula_processador : ula port map(saida_acumulador, sinal_mux_ula_b, s_sel_op_ula, saida_ula, flag_c, flag_z, flag_n);
    
    saida <= saida_acumulador;

end architecture;