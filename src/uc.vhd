library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        clk, rst               : in std_logic;
        flag_z, flag_n, flag_c : in std_logic;
        pc_out            : out unsigned(6 downto 0);
        instr_out         : out unsigned(18 downto 0);
        estado_out        : out unsigned(1 downto 0);
        mux_acumulador    : out std_logic;
        wr_en_acumulador  : out std_logic;
        mux_ula_b         : out std_logic;
        selec_op_ula      : out unsigned(1 downto 0);
        wr_en_banco       : out std_logic;
        wr_en_flags       : out std_logic;
        wr_en_ram : out std_logic;
        mux_banco: out std_logic
    );
end entity;

architecture a_uc of uc is
    component rom is
        port( clk : in std_logic; endereco : in unsigned(6 downto 0); dado : out unsigned(18 downto 0) );
    end component;

    -- Sinais da Máquina de Estados
    signal estado_s     : unsigned(1 downto 0);
    signal reg_pc       : unsigned(6 downto 0);
    signal next_pc       : unsigned(6 downto 0);
    signal pc_inc        : unsigned(6 downto 0);
    signal reg_instr    : unsigned(18 downto 0);
    signal proximo_reg_instr : unsigned(18 downto 0);
    signal sinal_dado   : unsigned(18 downto 0);
    signal sinal_opcode : unsigned(3 downto 0);

begin

    memoria: rom port map(clk => clk, endereco => reg_pc, dado => sinal_dado);

    -- maquina de 3 estados
    process(clk,rst)
    begin
        if rst='1' then
            estado_s <= "00";
        elsif rising_edge(clk) then
            if estado_s = "10" then        -- se agora esta em 2
                estado_s <= "00";         -- o prox vai voltar ao zero
            else
                estado_s <= estado_s + 1;   -- senao avanca
            end if;
        end if;
    end process;
    estado_out <= estado_s;

    -- Registrador de Instrução
    proximo_reg_instr <= sinal_dado when estado_s = "01" else reg_instr;

    process(clk)
    begin
        if rising_edge(clk) then
            reg_instr <= proximo_reg_instr;
        end if;
    end process;

    sinal_opcode <= reg_instr(18 downto 15);

    -- Decodificador
    mux_acumulador <= '1' when estado_s /= "10" else
                      '1' when sinal_opcode = "0001" else
                      '0' when sinal_opcode = "0100" or sinal_opcode = "0101" or sinal_opcode = "0110" else
                      '1';

    wr_en_acumulador <= '0' when estado_s /= "10" else
                        '1' when sinal_opcode = "0001" or sinal_opcode = "0100" or sinal_opcode = "0101" or sinal_opcode = "0110" else
                        '0';

    mux_ula_b <= '0' when estado_s /= "10" else
                  '1' when sinal_opcode = "0001" or sinal_opcode = "0110" else
                  '0';

    selec_op_ula <= "00" when estado_s /= "10" or sinal_opcode = "0001" or sinal_opcode = "0011" or sinal_opcode = "0100" or sinal_opcode = "0110" else
                     "01" when sinal_opcode = "0101" else
                     "00";

    wr_en_banco <= '0' when estado_s /= "10" else
                   '1' when sinal_opcode = "0011" else
                   '0';

    wr_en_flags <= '0' when estado_s /= "10" else
                   '1' when sinal_opcode = "0100" or sinal_opcode = "0101" or sinal_opcode = "0110" else
                   '0';

    wr_en_ram <= '1' when estado_s = "10" and sinal_opcode = "1011" else '0';
    
    mux_banco <= '1' when sinal_opcode = "1010" else '0';

    -- PC implementar os saltos
    pc_inc <= reg_pc + 1;
    
    next_pc <= reg_pc + reg_instr(6 downto 0) when (estado_s = "10" and sinal_opcode = "0111") else -- JMP relativo
               reg_instr(6 downto 0) when (estado_s = "10" and sinal_opcode = "1000" and (flag_z = '1' or flag_c = '1')) else -- BLS relativo
               reg_instr(6 downto 0) when (estado_s = "10" and sinal_opcode = "1001" and flag_n = '1') else -- BMI relativo
               pc_inc when (estado_s = "10") else
               reg_pc; 

    process(clk, rst)
    begin
        if rst = '1' then 
            reg_pc <= (others => '0');
        elsif rising_edge(clk) then
            reg_pc <= next_pc;
        end if;
    end process;

    pc_out <= reg_pc;
    instr_out <= reg_instr;
    estado_out <= estado_s;

end architecture;