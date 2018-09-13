
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gen_control is
	port(
		CLK, rst_n : in std_logic;
	
-- INPUT
		key 										: in std_logic_vector (255 downto 0);
		key_len 									: in std_logic_vector (1 downto 0); 
		ROUND 									: in std_logic_vector (3 downto 0);
		w0, w1, w2, w3, w4, w5, w6, w7 	: in std_logic_vector (31 downto 0);
		curr_round 								: in std_logic_vector (3 downto 0);
		
-- OUTPUT
		valid 									: out std_logic;
		
-- CONTROL SIGNAL
		load_curr,
		sel_curr, sel_s, sel_t5, 
		sel_t7, sel_w6, sel_w7 				: out std_logic;
		sel_rotWord, sel_dataround, 
		sel_t4, sel_t6, sel_w0, sel_w1, 
		sel_w2, sel_w3, sel_w4, sel_w5 	: out std_logic_vector (1 downto 0);
		load_w0, load_w1, load_w2, 
		load_w3, load_w4, load_w5, 
		load_w6, load_w7 						: out std_logic
		
	);
end gen_control;

architecture arc of gen_control is

	type statetype is (	INIT0, INIT1, WORK0, WORK1, WORK2, WORK3, WORK4,
									FINAL0, FINAL1, FINAL2, FINAL3, FINAL4, FINAL5, FINAL6,
									WAIT0, WAIT1, WAIT2, WAIT3, WAIT4, WAIT5, WAIT6, WAIT7, 
									WAIT8, WAIT9, WAIT10, WAIT11, WAIT12);
									
	signal state, nextstate : statetype;

begin

	state <= 	INIT0 	when rst_n = '0' else nextstate when rising_edge(CLK);

	process (state, key, key_len, ROUND, w0, w1, w2, w3, w4, w5, w6, w7, curr_round)
		begin
		
		case state is
			when INIT0 =>
				if key_len = "00" then
					nextstate <= WORK0;
				elsif key_len = "01" then
					nextstate <= WORK1;
				else
					nextstate <= INIT1;
				end if;
			when WORK0 =>
				nextstate <= WAIT0;
			when WAIT0 =>
				nextstate <= WAIT1;
			when WAIT1 =>
				nextstate <= FINAL0;
			when WAIT2 =>
				nextstate <= WAIT2;
			when FINAL0 =>
				if curr_round = "1010" then
					nextstate <= WAIT2;
				else
					nextstate <= WORK0;
				end if;
			when WORK1 =>
				nextstate <= WAIT3;
			when WAIT3 =>
				nextstate <= WAIT4;
			when WAIT4 =>
				nextstate <= FINAL1;
			when FINAL1 =>
				nextstate <= FINAL2;
			when FINAL2 =>
				nextstate <= WORK2;
			when WORK2 =>
				nextstate <= WAIT5;
			when WAIT5 =>
				nextstate <= WAIT6;
			when WAIT6 =>
				nextstate <= FINAL3;
			when FINAL3 =>
				if curr_round = "1100" then
					nextstate <= WAIT2;
				else
					nextstate <= WORK3;
				end if;
			when WORK3 =>
				nextstate <= WAIT7;
			when WAIT7 =>
				nextstate <= WAIT8;
			when WAIT8 =>
				nextstate <= FINAL4;
			when FINAL4 =>
				nextstate <= FINAL2;
			when INIT1 =>
				nextstate <= WORK4;
			when WORK4 =>
				nextstate <= WAIT9;
			when WAIT9 =>
				nextstate <= WAIT10;
			when WAIT10 =>
				nextstate <= FINAL5;
			when FINAL5 =>
				nextstate <= WAIT11;
			when WAIT11 =>
				nextstate <= WAIT12;
			when WAIT12 =>
				nextstate <= FINAL6;
			when FINAL6 =>
				if curr_round = "1110" then
					nextstate <= WAIT2;
				else
					nextstate <= WORK4;
				end if;
		end case;
	end process;


--CURR_ROUND

		sel_curr <= '0' when state= INIT0 else '1';
		load_curr <= '1' when state=FINAL0 or state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or state=INIT1 or state=FINAL5 or state=FINAL6 else '0';

-- X1 BLOCK

		sel_rotWord <= "00" when state=WORK0  else
							"01" when state=WORK1 or state=WORK3 else
							"10" when state=WORK4 else
							"11" when state=WORK2 else
							"00";
							
		sel_s <= '0' when state=FINAL5 else 
					'1' when state=WORK0 or state=WORK1 or state=WORK2 or state=WORK3 or state=WORK4 else
					'1';
		
-- DATAROUND

		sel_dataround <= 	"00" when state=INIT0 else
								"01" when state=INIT1 else
								"10" when state=FINAL0 or state=FINAL1 or state=FINAL2 or state=FINAL3 or 
												state=FINAL4 or state=FINAL5 or state=FINAL6 else
								"10";
								
	-- T SECTION
		sel_t4 <= 	"00" when state= FINAL0 or state=FINAL3 or state=FINAL6 or state=FINAL5 else
						"01" when state=WORK1 or state=FINAL1 else
						"10" when state=FINAL2 or state=FINAL4 or state=WORK3 else
						"10";
						
		sel_t5 <= 	'1' when state=WORK1 or state=FINAL1 else 
						'0' when state=FINAL0 or state=FINAL2 or state=FINAL3 or state=WORK3 or state=FINAL4 or state=FINAL5 or state=FINAL6 else
						'0';
		
		sel_t6 <= 	"00" when state=FINAL0 or state=FINAL2 or state=FINAL3 or state=FINAL5 or state=FINAL6 else
						"01" when state=FINAL1 else
						"10" when state=FINAL4 else
						"00";
		
		sel_t7 <=	'0' when state=FINAL0 or state=FINAL2 or state=FINAL3 or state=FINAL4 or state=FINAL5 or state=FINAL6 else 
						'1' when state=FINAL1 else
						'0';
		
	-- W SECTION

		sel_w0 <= 	"00" when state=INIT0 or state=INIT1 or state=WORK1 else
						"01" when state=FINAL0 else
						"10" when state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or state=FINAL5 or state=FINAL6 else
						"10";
						
		sel_w1 <= 	"00" when state=INIT0 or state=INIT1 or state=WORK1 else
						"01" when state=FINAL0 else
						"10" when state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or state=FINAL5 or state=FINAL6 else
						"10";
						
		sel_w2 <=	"00" when state=INIT0 or state=INIT1 or state=WORK1 else
						"01" when state=FINAL0 else
						"10" when state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 else
						"11" when state=FINAL5 or state=FINAL6 else
						"10";
						
		sel_w3 <= 	"00" when state=INIT0 or state=INIT1 or state=WORK1 else
						"01" when state=FINAL0 else
						"10" when state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 else
						"11" when state=FINAL5 or state=FINAL6 else
						"10";
						
						
		sel_w4 <=	"00" when state=INIT0 or state=INIT1 or state=WORK1 else
						"01" when state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 else
						"10" when state=FINAL5 or state=FINAL6 else
						"01";
						
		sel_w5 <= 	"00" when state=INIT0 or state=INIT1 or state=WORK1 else
						"01" when state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 else
						"10" when state=FINAL5 or state=FINAL6 else
						"01";
						
		sel_w6 <=	'0' when state=INIT0 or state=INIT1 else 
						'1' when state=FINAL5 or state=FINAL6 else
						'1';
		
		sel_w7 <=	'0' when state=INIT0 or state=INIT1 else 
						'1' when state=FINAL5 or state=FINAL6 else
						'1';
						
						
						
		load_w0 <= 	'1' when state=INIT0 or state=INIT1 or state=WORK1 or state=FINAL0 or
									state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
									state=FINAL5 or state=FINAL6 else '0';
		
		load_w1 <= '1' when 	state=INIT0 or state=INIT1 or state=WORK1 or state=FINAL0 or
									state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
									state=FINAL5 or state=FINAL6 else '0';
									
		load_w2 <= '1' when 	state=INIT0 or state=INIT1 or state=WORK1 or state=FINAL0 or
									state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
									state=FINAL5 or state=FINAL6 else '0';
									
		load_w3 <= '1' when 	state=INIT0 or state=INIT1 or state=WORK1 or state=FINAL0 or
									state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
									state=FINAL5 or state=FINAL6 else '0';
									
									
		load_w4 <= '1' when state=INIT0 or state=INIT1 or state=WORK1 or
									state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
									state=FINAL5 or state=FINAL6 else '0';
									
		load_w5 <= '1' when state=INIT0 or state=INIT1 or state=WORK1 or
									state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
									state=FINAL5 or state=FINAL6 else '0';
									
		load_w6 <= '1' when state=INIT0 or state=INIT1  or state=FINAL5 or state=FINAL6 else '0';
		 
		load_w7 <= '1' when state=INIT0 or state=INIT1  or state=FINAL5 or state=FINAL6 else '0';
		
	-- DATA VALID
		valid <= '0' when state=INIT0 or state=FINAL0 or state=FINAL1 or state=FINAL2 or state=FINAL3 or state=FINAL4 or
								state=FINAL5 or state=FINAL6 or state=INIT1 else '1';


end arc;

