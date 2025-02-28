do $$
declare
	userid uuid;
	inputid uuid;
	names_ text[] := array['Воловиков Георгий Александрович', 'Какой-то нибудь ещё чёл'];
	var_name text;
begin

foreach var_name in array names_ loop
	userid := gen_random_uuid();
	INSERT INTO gosha.users VALUES (userid, 
	(SELECT id FROM gosha.posts ORDER BY random() LIMIT 1), 
	var_name, round(random()*100));
	for input_index in 0..100 loop
		inputid := gen_random_uuid();
		INSERT INTO gosha.inputs VALUES (inputid, random()*100, (random()-0.5)*150, 750+(random()*20), random()*50, random(), 300+random()*250);
		INSERT INTO gosha.history (user_id, input_id, logitude, latitude, device_id) 
		VALUES (userid,inputid,random()*50,random()*50,(SELECT id FROM gosha.devices ORDER BY random() LIMIT 1));
	end loop;
end loop;

end $$;

with get_users_errors as 
(
	select t3.fullname as name, t4.name as post, count(*) as cnt, sum((not gosha."fnInputValidate"(t2.height, t2.temperature, t2.pressure, t2.wind_speed, t2.wind_direction))::integer) as wrong 
	from gosha.history as t1
	inner join gosha.inputs as t2 on t1.input_id = t2.id
	inner join gosha.users as t3 on t1.user_id = t3.id
	inner join  gosha.posts as t4 on t3.post = t4.id
	group by t3.fullname, t4.name
)

select * from get_users_errors 
order by wrong;