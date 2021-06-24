reg valid_access;
reg [NUM_CORE_TEAM-1:0] process_id_temp;
reg [NUM_CORE_TEAM-1:0] process_id_onehot_temp;

always@(*)
begin
	process_id_temp = 0;
	process_id_onehot_temp = 0;
	valid_access = 0;
	case(master_nodeid)
		`NODE_ID_I_MNIM_I_MAIN_CORE_INST:
		begin
			process_id_temp = `PROCESS_ID_I_MNIM_I_MAIN_CORE_INST;
			process_id_onehot_temp[`PROCESS_ID_I_MNIM_I_MAIN_CORE_INST] = 1'b 1;
			valid_access = 1;
		end
		`NODE_ID_I_MNIM_I_MAIN_CORE_DATA:
		begin
			process_id_temp = `PROCESS_ID_I_MNIM_I_MAIN_CORE_DATA;
			process_id_onehot_temp[`PROCESS_ID_I_MNIM_I_MAIN_CORE_DATA] = 1'b 1;
			valid_access = 1;
		end
	endcase
end