library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is 
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		constante_externa : in unsigned(15 downto 0); -- p/ LD e ADDI
		
		-- acumulador
		mux_acumulador : in std_logic;
		wr_en_acumulador : in std_logic;
		
		-- ULA
		mux_ula_b : in std_logic; -- 0 banco, 1 Constante
		selec_op_ula : in unsigned(1 downto 0);
		
		-- Banco
		wr_en_banco : in std_logic;
		reg_sel_read : in unsigned(2 downto 0);
		reg_sel_write : in unsigned(2 downto 0);
		
		-- Saida
		saida : out unsigned(15 downto 0);
		flag_z : out std_logic; 
        flag_n : out std_logic; 
        flag_c : out std_logic 
	);
end entity;

architecture a_toplevel of toplevel is 

	-- Declaração
	component ula is
		port(
			entrada_a : in  unsigned(15 downto 0);
            entrada_b : in  unsigned(15 downto 0);
            selec_op  : in  unsigned(1 downto 0);
            saida     : out unsigned(15 downto 0);
            flag_c    : out std_logic;
            flag_z    : out std_logic;
            flag_n    : out std_logic
		);
	end component; 
	
	component banco_regs is
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			reg_sel_read : in unsigned(2 downto 0);
			reg_sel_write : in unsigned(2 downto 0);		
			data_in : in unsigned(15 downto 0);
			data_out : out unsigned(15 downto 0)
		);
	end component;
	
	component reg16bits is 
		port (
			clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in unsigned(15 downto 0);
			data_out : out unsigned(15 downto 0)
		);
	end component;
	
	-- Fios
	signal saida_ula, saida_acumulador, saida_banco : unsigned(15 downto 0);
	signal sinal_mux_ula_b, sinal_mux_acumulador : unsigned(15 downto 0);
	
begin 

	sinal_mux_ula_b <= saida_banco when mux_ula_b = '0' else constante_externa; -- 0 banco 1 constante
	sinal_mux_acumulador <= saida_ula when mux_acumulador = '0' else constante_externa; -- 0 ula 1 constante
	
	-- Mapeando
	acumulador_ula : reg16bits port map(
		clk => clk, 
		rst => rst, 
		wr_en => wr_en_acumulador, 
		data_in => sinal_mux_acumulador, 
		data_out => saida_acumulador
	);
	banco : banco_regs port map(
		clk => clk, 
		rst => rst, 
		wr_en => wr_en_banco, 
		reg_sel_read => reg_sel_read, 
		reg_sel_write => reg_sel_write,
		data_in => saida_acumulador, 
		data_out => saida_banco
	);
	ula_toplevel : ula port map(
		entrada_a => saida_acumulador, -- Entrada A é fixa no Acc[cite: 2]
        entrada_b => sinal_mux_ula_b,
        selec_op  => selec_op_ula,
        saida     => saida_ula,
        flag_z    => flag_z,
        flag_n    => flag_n,
        flag_c    => flag_c
	);
	
	saida <= saida_acumulador;
	
end architecture;