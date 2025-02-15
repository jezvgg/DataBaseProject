do $$
declare
	userid uuid;
	inputid uuid;
	names_ text[] := array['Воловиков Георгий Александрович', 'Какой-то нибудь ещё чёл'];
	var_name text[];
begin

foreach var_name slice 1 in array names_ loop
	userid := gen_random_uuid();
	INSERT INTO gosha.users VALUES (userid, 
	(SELECT id FROM gosha.posts ORDER BY random() LIMIT 1), 
	var_name, round(random()*100));
	for input_index in 0..100 loop
		inputid := gen_random_uuid();
		INSERT INTO gosha.inputs VALUES (inputid, random()*100, (random()-0.5)*100, 750+(random()*20), random()*50, random(), 300+random()*200);
		INSERT INTO gosha.history (user_id, input_id, logitude, latitude, device_id) 
		VALUES (userid,inputid,random()*50,random()*50,(SELECT id FROM gosha.devices ORDER BY random() LIMIT 1));
	end loop;
end loop;

end $$;