library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity key_interface is

port(
	CLK, rst_n		: in std_logic;
	
	--INPUT FRO TOPLEVEL
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);
	ROUND				: in std_logic_vector( 3 downto 0);	
	enc				: in std_logic;
	
	
	--INPUT FROM STORE
	
	R0in, R1in, R2in, R3in, R4in, 
	R5in, R6in, R7in, R8in, R9in, 
	R10in, R11in, R12in, R13in, R14in	: in std_logic_vector(128 downto 0);
	
	
	--OUTPUT TO GEN AND STORE
	reset				: out std_logic;
	key_out			: out std_logic_vector( 255 downto 0);
	key_len_out		: out std_logic_vector( 1 downto 0);
	
	
	--OUTPUT TO TOPLEVEL
	valid				: out std_logic;
	data_out 		: out std_logic_vector( 127 downto 0)
);
end key_interface;

architecture arc of key_interface is

	component key_int_datapath is
			port(
		CLK, rst_n				: in std_logic;
		key						: in std_logic_vector( 255 downto 0);
		key_len					: in std_logic_vector( 1 downto 0);	
		enc						: in std_logic;
		ROUND						: in std_logic_vector( 3 downto 0);	
		R0in, R1in, R2in, R3in, R4in, 
		R5in, R6in, R7in, R8in, R9in, 
		R10in, R11in, R12in, R13in, R14in	: in std_logic_vector(128 downto 0);
		load_key, load_len 	: in std_logic;
		sel_round				: in std_logic_vector( 1 downto 0);
		load_thisround			: in std_logic;
		sel_dataout				: in std_logic;
		load_dataout			: in std_logic;
		THISROUND				: out std_logic_vector( 3 downto 0);
		DATAOUT					: out std_logic_vector( 128 downto 0);
		key_len_out				: out std_logic_vector( 1 downto 0);
		enc_out					: out std_logic;
		key_out					: out std_logic_vector( 255 downto 0)
	);

	end component;
	
	component key_int_contr is
		port(
			CLK, rst_n		: in std_logic;
			key				: in std_logic_vector( 255 downto 0);
			key_len			: in std_logic_vector( 1 downto 0);
			ROUND				: in std_logic_vector( 3 downto 0);
			enc				: in std_logic;
			key_dp			: in std_logic_vector( 255 downto 0); --from datapath
			key_len_dp		: in std_logic_vector( 1 downto 0); --from datapath
			enc_dp			: in std_logic;
			THISROUND		: in std_logic_vector( 3 downto 0);
			sel_round		: out std_logic_vector( 1 downto 0);
			load_thisround	: out std_logic;
			sel_dataout		: out std_logic;
			load_dataout	: out std_logic;
			load_key			: out std_logic; 
			load_len 		: out std_logic;
			ctrl_valid		: out std_logic;
			reset				: out std_logic
		);
	end component;


	signal 	load_key, load_len, 
				reset_out, partvalid,
				compkey						: std_logic;
	signal 	key_dp 						: std_logic_vector( 255 downto 0);
	signal 	key_len_dp 					: std_logic_vector( 1 downto 0);
	signal 	THISROUND					: std_logic_vector( 3 downto 0);
	signal 	DATAOUT						: std_logic_vector( 128 downto 0);
	signal 	sel_round					: std_logic_vector( 1 downto 0);
	signal 	load_thisround				: std_logic;
	signal 	sel_dataout					: std_logic;
	signal 	load_dataout				: std_logic;
	signal 	ctrl_valid					: std_logic;
	signal 	enc_dp						: std_logic;

begin

	DP		: key_int_datapath port map(CLK => CLK, rst_n => rst_n, 
											key => key,
											key_len => key_len,
											enc => enc,
											load_key => load_key, load_len => load_len,
											key_len_out	=> key_len_dp,
											key_out	=> key_dp,
											THISROUND => THISROUND,
											sel_round => sel_round,
											load_thisround	=> load_thisround,
											sel_dataout => sel_dataout,
											load_dataout => load_dataout,
											ROUND => ROUND,
											R0in => R0in , R1in => R1in , R2in => R2in , R3in => R3in, 
											R4in => R4in , R5in => R5in , R6in => R6in , R7in => R7in , R8in => R8in , 
											R9in => R9in , R10in => R10in, R11in => R11in, R12in => R12in, R13in => R13in, 
											R14in => R14in,
											DATAOUT => DATAOUT,
											enc_out => enc_dp);
											
	CONTR	: key_int_contr port map(CLK => CLK, rst_n => rst_n, 
											key => key,
											key_len => key_len,
											key_dp => key_dp,
											key_len_dp => key_len_dp,
											enc_dp => enc_dp,
											ROUND	=> ROUND,
											load_key => load_key, load_len => load_len,
											reset => reset_out,
											enc => enc,
											THISROUND => THISROUND,
											sel_round => sel_round,
											load_thisround	=> load_thisround,
											sel_dataout => sel_dataout,
											load_dataout => load_dataout,
											ctrl_valid	=> ctrl_valid);

	key_out 		<= key_dp;
	key_len_out <= key_len_dp;
	reset 		<= reset_out and rst_n;	
	valid 		<= DATAOUT(128) and reset_out and rst_n and ctrl_valid; --more efficient valid signal					
	data_out 	<=	DATAOUT(127 downto 0);
						

end arc;

