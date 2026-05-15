library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
	port(
		clk : in std_logic;
		rst : in std_logic;
		wr_en : in std_logic;
		
		reg_sel_read : in unsigned(2 downto 0);
		reg_sel_write : in unsigned(2 downto 0);
		
		data_in : in unsigned(15 downto 0); -- do acumulador
		
		data_out : out unsigned(15 downto 0)
	);
end entity;

architecture a_banco_regs of banco_regs is 

	component reg16bits is
		port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
 
	signal r0_out, r1_out, r2_out, r3_out, r4_out : unsigned(15 downto 0); -- sinal saida dos regs
	signal r0_en, r1_en, r2_en, r3_en, r4_en : std_logic; -- enable dos regs
	
begin 
	
	r0_en <= '1' when (wr_en = '1' and reg_sel_write = "000") else '0';
	r1_en <= '1' when (wr_en = '1' and reg_sel_write = "001") else '0';
	r2_en <= '1' when (wr_en = '1' and reg_sel_write = "010") else '0';
	r3_en <= '1' when (wr_en = '1' and reg_sel_write = "011") else '0';
	r4_en <= '1' when (wr_en = '1' and reg_sel_write = "100") else '0';
	
	-- instanciação
	r0: reg16bits port map(clk => clk, rst => rst, wr_en => r0_en, data_in => data_in, data_out => r0_out);
	r1: reg16bits port map(clk => clk, rst => rst, wr_en => r1_en, data_in => data_in, data_out => r1_out);
	r2: reg16bits port map(clk => clk, rst => rst, wr_en => r2_en, data_in => data_in, data_out => r2_out);
	r3: reg16bits port map(clk => clk, rst => rst, wr_en => r3_en, data_in => data_in, data_out => r3_out);
	r4: reg16bits port map(clk => clk, rst => rst, wr_en => r4_en, data_in => data_in, data_out => r4_out);
	
	data_out <= r0_out when reg_sel_read = "000" else
				r1_out when reg_sel_read = "001" else
				r2_out when reg_sel_read = "010" else
				r3_out when reg_sel_read = "011" else
				r4_out when reg_sel_read = "100" else
				x"0000";

end architecture;