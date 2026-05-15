library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        clk : in std_logic;
        rst : in std_logic;
		
        pc_out : out unsigned(6 downto 0);
        instr_out : out unsigned(18 downto 0);
        estado_out : out std_logic
    );
end entity;

architecture a_uc of uc is

    component rom is
        port(
            clk : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado : out unsigned(18 downto 0)
        );
    end component;

    signal reg_pc : unsigned(6 downto 0) := (others => '0');
    signal reg_instr : unsigned(18 downto 0) := (others => '0');
    signal estado : std_logic := '0';

    signal sinal_dado : unsigned(18 downto 0);
    signal sinal_opcode : unsigned(3 downto 0);
    signal sinal_delta : signed(14 downto 0);
    signal sinal_somapc : unsigned(6 downto 0);
    signal sinal_proxpc : unsigned(6 downto 0);
    signal sinal_pulo : std_logic;

begin

    -- fios
    memoria: rom port map(
        clk      => clk,
        endereco => reg_pc,
        dado     => sinal_dado
    );

    -- flip-flop T
    process(clk, rst)
    begin
        if rst = '1' then
            estado <= '0';
        elsif rising_edge(clk) then
            estado <= not estado;
        end if;
    end process;

    -- no 1
    process(clk, rst)
    begin
        if rst = '1' then
            reg_instr <= (others => '0');
        elsif rising_edge(clk) then
            if estado = '1' then
                reg_instr <= sinal_dado;
            end if;
        end if;
    end process;

    sinal_opcode <= reg_instr(18 downto 15);
    sinal_delta <= signed(reg_instr(14 downto 0));
    sinal_somapc <= reg_pc + 1;
    sinal_pulo <= '1' when sinal_opcode = "1111" else '0';
	
	sinal_proxpc <= unsigned(resize(signed(resize(sinal_somapc, 15)) + sinal_delta, 7)) 
                when sinal_pulo = '1' else sinal_somapc;

	-- grava sincrono
    process(clk, rst)
    begin
        if rst = '1' then
            reg_pc <= (others => '0');
        elsif rising_edge(clk) then
            if estado = '1' then
                reg_pc <= sinal_proxpc;
            end if;
        end if;
    end process;

    pc_out <= reg_pc;
    instr_out <= reg_instr;
    estado_out <= estado;

end architecture;