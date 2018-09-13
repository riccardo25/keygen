library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity key_int_contr is
port(
	CLK, rst_n		: in std_logic;
	
	--INPUT
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	key_dp			: in std_logic_vector( 255 downto 0); --from datapath
	key_len_dp		: in std_logic_vector( 1 downto 0); --from datapath
	ROUND				: in std_logic_vector( 3 downto 0);
	curr_round		: in std_logic_vector( 3 downto 0);
	
	
	--OUTPUT
	sel_key, sel_len, load_key, load_len : out std_logic;
	reset				: out std_logic;
	valid				: out std_logic
);
end key_int_contr;

architecture arc of key_int_contr is

	type statetype is (INIT, KEY_WAIT, PUTOUT);
	signal state, nextstate : statetype;

begin

--FSM
	state <= INIT 	when rst_n = '0' else
				INIT when (rising_edge(CLK) and (key /= key_dp or key_len /= key_len_dp)) else
				nextstate when rising_edge(CLK);
				
	process (state, key_dp, key_len_dp, curr_round, ROUND)
	begin
	
		if( unsigned(curr_round) < unsigned(ROUND)) then --10
				nextstate <= KEY_WAIT;
		else
				nextstate <= PUTOUT;
		end if;

	end process;
	
	sel_key <= '1' when state=INIT else '0';
	sel_len <= '1' when state=INIT else '0';
	load_key <= '1' when state=INIT else '0';
	load_len <= '1' when state=INIT else '0';
	
	valid <= '1' when state=PUTOUT else '0';
	reset <= '0' when state=INIT else '1';
	
	


end arc;

