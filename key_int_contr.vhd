library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity key_int_contr is
port(
	CLK, rst_n		: in std_logic;
	
	--INPUT
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	
	ROUND				: in std_logic_vector( 3 downto 0);
	enc				: in std_logic;
	
	--INPUT FROM DATAPATH
	key_dp			: in std_logic_vector( 255 downto 0); --from datapath
	key_len_dp		: in std_logic_vector( 1 downto 0); --from datapath
	enc_dp			: in std_logic;
	THISROUND		: in std_logic_vector( 3 downto 0);
	
	--OUTPUT
	sel_round		: out std_logic_vector( 1 downto 0);
	load_thisround	: out std_logic;
	sel_dataout		: out std_logic;
	load_dataout	: out std_logic;
	load_key			: out std_logic; 
	load_len 		: out std_logic;
	ctrl_valid		: out std_logic;
	reset				: out std_logic
);
end key_int_contr;

architecture arc of key_int_contr is

	type statetype is (INIT0, WAIT0_enc, PRE0_enc, WAIT1_dec, PRE1_dec);
	signal state, nextstate : statetype;

begin

--FSM
	state <= INIT0 	when rst_n = '0' else nextstate when rising_edge(CLK);
				
	process (state, key_dp, key_len_dp, enc_dp, ROUND, key, key_len, enc, THISROUND)
	begin
		
		case state is
			when INIT0 =>
				if( enc = '1' and key_dp = key and key_len_dp = key_len and enc = enc_dp) then
					nextstate <= WAIT0_enc;
				elsif( key_dp = key and key_len_dp = key_len and enc = enc_dp) then
					nextstate <= WAIT1_dec;
				else
					nextstate <= INIT0;
				end if;
			when WAIT0_enc =>
				if(key_dp = key and key_len_dp = key_len and enc = enc_dp and ROUND /= THISROUND) then
					nextstate <= PRE0_enc;
				elsif(key_dp = key and key_len_dp = key_len and enc = enc_dp) then
					nextstate <= WAIT0_enc;
				else
					nextstate <= INIT0;
				end if;
				
			when PRE0_enc =>
				if(key_dp = key and key_len_dp = key_len and enc = enc_dp and ROUND /= THISROUND) then
					nextstate <= PRE0_enc;
				elsif(key_dp = key and key_len_dp = key_len and enc = enc_dp) then
					nextstate <= WAIT0_enc;
				else
					nextstate <= INIT0;
				end if;
			when WAIT1_dec =>
				if(key_dp = key and key_len_dp = key_len and enc = enc_dp and ROUND /= THISROUND) then
					nextstate <= WAIT1_dec;
				elsif(key_dp = key and key_len_dp = key_len and enc = enc_dp) then
					nextstate <= PRE1_dec;
				else
					nextstate <= INIT0;
				end if;
			when PRE1_dec =>
				if(key_dp = key and key_len_dp = key_len and enc = enc_dp and ROUND /= THISROUND) then
					nextstate <= WAIT1_dec;
				elsif(key_dp = key and key_len_dp = key_len and enc = enc_dp) then
					nextstate <= PRE1_dec;
				else
					nextstate <= INIT0;
				end if;
		end case;
		

	end process;
	
	
	sel_round 		<= "00" when state=INIT0 else
							"01" when enc='1' else
							"10";
							
	load_thisround	<= '1' when state=INIT0 or state=PRE0_enc or state=PRE1_dec else
							'0';
							
	sel_dataout 	<= '0' when state=INIT0 else
							'1';
							
	load_dataout	<= '1' when state=INIT0 or state=PRE0_enc or state=PRE1_dec else
							'0';
						
	load_key 		<= '1' when state=INIT0 else '0';
	load_len 		<= '1' when state=INIT0 else '0';
	reset 			<= '0' when state=INIT0 else '1';
	
	ctrl_valid 		<= '0' when state=INIT0 or state=PRE0_enc or state=PRE1_dec or key /= key_dp or key_len/=key_len_dp else '1';


end arc;

