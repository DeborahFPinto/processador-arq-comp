library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port (
		entrada_a : in unsigned(15 downto 0);
		entrada_b : in unsigned(15 downto 0);
		selec_op : in unsigned(1 downto 0);
		
		saida : out unsigned(15 downto 0);
		
		flag_c : out std_logic; -- CarryOut -> relativo a BLS
		flag_z : out std_logic; -- Zero -> relativo a BLS
		flag_n : out std_logic -- Negativo -> relativo a BMI
	);
end entity;

architecture a_ula of ula is 

	signal soma, sub: unsigned(16 downto 0); -- um bitzinho a mais por causa do CarryOut
	signal s_and, s_or : unsigned(15 downto 0);
	signal saida_interna: unsigned(15 downto 0);
	
begin	
	
	-- soma subtração and or
	soma <= ('0' & entrada_a) + ('0' & entrada_b);
	sub <= ('0' & entrada_a) - ('0' & entrada_b);
	s_and <= entrada_a and entrada_b;
	s_or <= entrada_a or entrada_b;
	
	saida_interna <= soma(15 downto 0) when selec_op = "00" else
					 sub(15 downto 0) when selec_op = "01" else
					 s_and when selec_op = "10" else
					 s_or when selec_op = "11" else
					 x"0000";
	
	saida <= saida_interna;
	
	-- CarryOut
	flag_c <= soma(16) when selec_op = "00" else
			  sub(16) when selec_op = "01" else
			  '0';
	
	-- Zero
	flag_z <= '1' when saida_interna = x"0000" else '0';
	
	-- Negativo 
	flag_n <= saida_interna(15);
	
end architecture;